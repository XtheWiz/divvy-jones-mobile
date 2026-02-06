import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/group_service.dart';
import '../api/api_exceptions.dart';
import '../utils/app_logger.dart';

enum GroupsStatus {
  initial,
  loading,
  loaded,
  error,
}

class GroupsProvider with ChangeNotifier {
  static const _log = AppLogger('GroupsProvider');
  final GroupService _groupService;

  GroupsProvider({required GroupService groupService})
      : _groupService = groupService;

  static const int _pageSize = 20;

  List<Group> _groups = [];
  GroupsStatus _status = GroupsStatus.initial;
  String? _error;
  int _currentPage = 1;
  bool _hasMoreGroups = true;
  bool _isLoadingMore = false;

  // Aggregated balances across all groups
  final Map<String, List<Balance>> _balancesByGroup = {};
  final Set<String> _failedBalanceGroups = {};

  // For single group details
  Group? _selectedGroup;
  List<Balance> _selectedGroupBalances = [];
  List<Expense> _selectedGroupExpenses = [];
  bool _isLoadingDetails = false;

  List<Group> get groups => _groups;
  GroupsStatus get status => _status;
  String? get error => _error;
  bool get isLoading => _status == GroupsStatus.loading;
  bool get hasMoreGroups => _hasMoreGroups;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasBalanceErrors => _failedBalanceGroups.isNotEmpty;

  Group? get selectedGroup => _selectedGroup;
  List<Balance> get selectedGroupBalances => _selectedGroupBalances;
  List<Expense> get selectedGroupExpenses => _selectedGroupExpenses;
  bool get isLoadingDetails => _isLoadingDetails;

  double get totalExpenses => _groups.fold(
        0.0,
        (sum, group) => sum + (group.totalExpenses ?? 0),
      );

  /// Sum of all positive balances across groups (money owed to the user).
  double get totalOwed {
    double total = 0.0;
    for (final balances in _balancesByGroup.values) {
      for (final b in balances) {
        if (b.balance > 0) total += b.balance;
      }
    }
    return total;
  }

  /// Sum of all negative balances across groups (money the user owes).
  double get totalOwing {
    double total = 0.0;
    for (final balances in _balancesByGroup.values) {
      for (final b in balances) {
        if (b.balance < 0) total += b.balance.abs();
      }
    }
    return total;
  }

  /// Net balance across all groups.
  double get netBalance => totalOwed - totalOwing;

  Future<void> loadGroups() async {
    _status = GroupsStatus.loading;
    _error = null;
    _currentPage = 1;
    _hasMoreGroups = true;
    notifyListeners();

    try {
      final groups = await _groupService.getGroups(page: 1, limit: _pageSize);
      _groups = groups;
      _hasMoreGroups = groups.length >= _pageSize;
      _status = GroupsStatus.loaded;

      // Load balances for all groups in parallel
      _loadAllBalances();
    } on ApiException catch (e) {
      _error = e.message;
      _status = GroupsStatus.error;
    } catch (e) {
      _error = 'Failed to load groups. Please try again.';
      _status = GroupsStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadMoreGroups() async {
    if (_isLoadingMore || !_hasMoreGroups) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final newGroups = await _groupService.getGroups(page: nextPage, limit: _pageSize);
      _groups.addAll(newGroups);
      _currentPage = nextPage;
      _hasMoreGroups = newGroups.length >= _pageSize;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load more groups.';
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  /// Loads balances for all groups in parallel. Failures for individual groups
  /// are silently ignored so the rest of the data remains available.
  Future<void> _loadAllBalances() async {
    _failedBalanceGroups.clear();
    final futures = <Future<void>>[];
    for (final group in _groups) {
      futures.add(
        _groupService.getGroupBalances(group.id).then((balances) {
          _balancesByGroup[group.id] = balances;
        }).catchError((e, st) {
          _log.warning('Failed to load balances for group ${group.id}', e, st);
          _failedBalanceGroups.add(group.id);
        }),
      );
    }
    await Future.wait(futures);
    notifyListeners();
  }

  Future<void> loadGroupDetails(String groupId) async {
    _isLoadingDetails = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _groupService.getGroupById(groupId),
        _groupService.getGroupBalances(groupId),
        _groupService.getGroupExpenses(groupId),
      ]);

      _selectedGroup = results[0] as Group;
      _selectedGroupBalances = results[1] as List<Balance>;
      _selectedGroupExpenses = results[2] as List<Expense>;

      // Also update the aggregated balances cache
      _balancesByGroup[groupId] = _selectedGroupBalances;
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load group details. Please try again.';
    }

    _isLoadingDetails = false;
    notifyListeners();
  }

  Future<Group?> createGroup(String name, {String? currencyCode}) async {
    _error = null;

    try {
      final group = await _groupService.createGroup(
        name: name,
        currencyCode: currencyCode,
      );
      _groups.insert(0, group);
      notifyListeners();
      return group;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      _error = 'Failed to create group. Please try again.';
      notifyListeners();
      return null;
    }
  }

  Future<Group?> joinGroup(String joinCode) async {
    _error = null;

    try {
      final group = await _groupService.joinGroup(joinCode);
      // Check if already in list
      final existingIndex = _groups.indexWhere((g) => g.id == group.id);
      if (existingIndex == -1) {
        _groups.insert(0, group);
      } else {
        _groups[existingIndex] = group;
      }
      notifyListeners();
      return group;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return null;
    } catch (e) {
      _error = 'Failed to join group. Please try again.';
      notifyListeners();
      return null;
    }
  }

  void clearSelectedGroup() {
    _selectedGroup = null;
    _selectedGroupBalances = [];
    _selectedGroupExpenses = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Group? getGroupById(String id) {
    try {
      return _groups.firstWhere((g) => g.id == id);
    } catch (e) {
      return null;
    }
  }
}
