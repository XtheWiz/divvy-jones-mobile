import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../api/response_unwrapper.dart';
import '../models/models.dart';
import '../utils/app_logger.dart';

class ExpenseService {
  static const _log = AppLogger('ExpenseService');
  final ApiClient _apiClient;

  ExpenseService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Expense>> getGroupExpenses(String groupId, {int page = 1, int limit = 20}) async {
    try {
      final rawResponse = await _apiClient.get<dynamic>(
        ApiEndpoints.groupExpenses(groupId),
        queryParameters: {'page': page, 'limit': limit},
      );

      final expensesList = ResponseUnwrapper.unwrapList(rawResponse, listKey: 'expenses');

      return expensesList
          .map((json) => Expense.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _log.error('Failed to fetch expenses for group $groupId', e, st);
      rethrow;
    }
  }

  Future<Expense> createExpense(CreateExpenseRequest request) async {
    try {
      final rawResponse = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.expenses,
        data: request.toJson(),
      );

      final response = ResponseUnwrapper.unwrapMap(rawResponse);

      if (response['expense'] != null) {
        return Expense.fromJson(response['expense']);
      }
      return Expense.fromJson(response);
    } catch (e, st) {
      _log.error('Failed to create expense', e, st);
      rethrow;
    }
  }

  Future<Expense> getExpenseById(String id) async {
    try {
      final rawResponse = await _apiClient.get<dynamic>(
        ApiEndpoints.expenseById(id),
      );

      if (rawResponse is Map<String, dynamic>) {
        final response = ResponseUnwrapper.unwrapMap(rawResponse);
        if (response['expense'] != null) {
          return Expense.fromJson(response['expense']);
        }
        return Expense.fromJson(response);
      }

      throw Exception('Invalid response format');
    } catch (e, st) {
      _log.error('Failed to fetch expense $id', e, st);
      rethrow;
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _apiClient.delete<dynamic>(ApiEndpoints.expenseById(id));
    } catch (e, st) {
      _log.error('Failed to delete expense $id', e, st);
      rethrow;
    }
  }
}
