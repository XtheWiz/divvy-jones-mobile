import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/group_service.dart';
import '../api/api_exceptions.dart';

enum GroupsStatus {
  initial,
  loading,
  loaded,
  error,
}

class GroupsProvider with ChangeNotifier {
  final GroupService _groupService;

  GroupsProvider({required GroupService groupService})
      : _groupService = groupService;

  List<Group> _groups = [];
  GroupsStatus _status = GroupsStatus.initial;
  String? _error;

  // For single group details
  Group? _selectedGroup;
  List<Balance> _selectedGroupBalances = [];
  List<Expense> _selectedGroupExpenses = [];
  bool _isLoadingDetails = false;

  List<Group> get groups => _groups;
  GroupsStatus get status => _status;
  String? get error => _error;
  bool get isLoading => _status == GroupsStatus.loading;

  Group? get selectedGroup => _selectedGroup;
  List<Balance> get selectedGroupBalances => _selectedGroupBalances;
  List<Expense> get selectedGroupExpenses => _selectedGroupExpenses;
  bool get isLoadingDetails => _isLoadingDetails;

  double get totalExpenses => _groups.fold(
        0.0,
        (sum, group) => sum + (group.totalExpenses ?? 0),
      );

  Future<void> loadGroups() async {
    _status = GroupsStatus.loading;
    _error = null;
    notifyListeners();

    try {
      _groups = await _groupService.getGroups();
      _status = GroupsStatus.loaded;
    } on ApiException catch (e) {
      _error = e.message;
      _status = GroupsStatus.error;
    } catch (e) {
      _error = 'Failed to load groups. Please try again.';
      _status = GroupsStatus.error;
    }

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
