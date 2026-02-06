import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/expense_service.dart';
import '../api/api_exceptions.dart';
import '../utils/app_logger.dart';

enum ExpenseStatus {
  initial,
  loading,
  loaded,
  creating,
  error,
}

class ExpenseProvider with ChangeNotifier {
  static const _log = AppLogger('ExpenseProvider');
  static const int _pageSize = 20;
  final ExpenseService _expenseService;

  ExpenseProvider({required ExpenseService expenseService})
      : _expenseService = expenseService;

  Map<String, List<Expense>> _expensesByGroup = {};
  ExpenseStatus _status = ExpenseStatus.initial;
  String? _error;
  List<Expense> _recentActivity = [];

  // Pagination state per group
  final Map<String, int> _currentPageByGroup = {};
  final Map<String, bool> _hasMoreByGroup = {};
  bool _isLoadingMore = false;

  List<Expense> getExpensesForGroup(String groupId) =>
      _expensesByGroup[groupId] ?? [];

  ExpenseStatus get status => _status;
  String? get error => _error;
  bool get isLoading => _status == ExpenseStatus.loading;
  bool get isCreating => _status == ExpenseStatus.creating;
  bool get isLoadingMore => _isLoadingMore;
  List<Expense> get recentActivity => _recentActivity;

  bool hasMoreExpenses(String groupId) => _hasMoreByGroup[groupId] ?? true;

  Future<void> loadGroupExpenses(String groupId) async {
    _status = ExpenseStatus.loading;
    _error = null;
    _currentPageByGroup[groupId] = 1;
    _hasMoreByGroup[groupId] = true;
    notifyListeners();

    try {
      final expenses = await _expenseService.getGroupExpenses(
        groupId,
        page: 1,
        limit: _pageSize,
      );
      _expensesByGroup[groupId] = expenses;
      _hasMoreByGroup[groupId] = expenses.length >= _pageSize;
      _status = ExpenseStatus.loaded;

      // Update recent activity (combine all groups, sort by date, take first 5)
      _updateRecentActivity();
    } on ApiException catch (e) {
      _error = e.message;
      _status = ExpenseStatus.error;
    } catch (e, st) {
      _log.error('Failed to load expenses for group $groupId', e, st);
      _error = 'Failed to load expenses. Please try again.';
      _status = ExpenseStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadMoreGroupExpenses(String groupId) async {
    if (_isLoadingMore || !(_hasMoreByGroup[groupId] ?? false)) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = (_currentPageByGroup[groupId] ?? 1) + 1;
      final newExpenses = await _expenseService.getGroupExpenses(
        groupId,
        page: nextPage,
        limit: _pageSize,
      );

      final existing = _expensesByGroup[groupId] ?? [];
      existing.addAll(newExpenses);
      _expensesByGroup[groupId] = existing;
      _currentPageByGroup[groupId] = nextPage;
      _hasMoreByGroup[groupId] = newExpenses.length >= _pageSize;

      _updateRecentActivity();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e, st) {
      _log.error('Failed to load more expenses for group $groupId', e, st);
      _error = 'Failed to load more expenses.';
    }

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<Expense?> createExpense(CreateExpenseRequest request) async {
    _status = ExpenseStatus.creating;
    _error = null;
    notifyListeners();

    try {
      final expense = await _expenseService.createExpense(request);

      // Add to group's expenses list
      final groupExpenses = _expensesByGroup[request.groupId] ?? [];
      groupExpenses.insert(0, expense);
      _expensesByGroup[request.groupId] = groupExpenses;

      _status = ExpenseStatus.loaded;
      _updateRecentActivity();
      notifyListeners();
      return expense;
    } on ApiException catch (e) {
      _error = e.message;
      _status = ExpenseStatus.error;
      notifyListeners();
      return null;
    } catch (e, st) {
      _log.error('Failed to create expense', e, st);
      _error = 'Failed to create expense. Please try again.';
      _status = ExpenseStatus.error;
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteExpense(String expenseId, String groupId) async {
    _error = null;

    try {
      await _expenseService.deleteExpense(expenseId);

      // Remove from group's expenses list
      final groupExpenses = _expensesByGroup[groupId] ?? [];
      groupExpenses.removeWhere((e) => e.id == expenseId);
      _expensesByGroup[groupId] = groupExpenses;

      _updateRecentActivity();
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    } catch (e, st) {
      _log.error('Failed to delete expense $expenseId', e, st);
      _error = 'Failed to delete expense. Please try again.';
      notifyListeners();
      return false;
    }
  }

  void _updateRecentActivity() {
    final allExpenses = _expensesByGroup.values.expand((list) => list).toList();
    allExpenses.sort((a, b) {
      final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    _recentActivity = allExpenses.take(5).toList();
  }

  void clearGroupExpenses(String groupId) {
    _expensesByGroup.remove(groupId);
    _updateRecentActivity();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearAll() {
    _expensesByGroup = {};
    _recentActivity = [];
    _status = ExpenseStatus.initial;
    _error = null;
    notifyListeners();
  }
}
