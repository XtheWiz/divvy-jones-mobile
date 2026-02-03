import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../models/models.dart';

class ExpenseService {
  final ApiClient _apiClient;

  ExpenseService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Expense>> getGroupExpenses(String groupId) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.groupExpenses(groupId),
      );

      List<dynamic> expensesList;
      if (response is Map<String, dynamic>) {
        expensesList = response['expenses'] ?? response['data'] ?? [];
      } else if (response is List) {
        expensesList = response;
      } else {
        return [];
      }

      return expensesList
          .map((json) => Expense.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Expense> createExpense(CreateExpenseRequest request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.expenses,
        data: request.toJson(),
      );

      if (response['expense'] != null) {
        return Expense.fromJson(response['expense']);
      }
      return Expense.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Expense> getExpenseById(String id) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.expenseById(id),
      );

      if (response is Map<String, dynamic>) {
        if (response['expense'] != null) {
          return Expense.fromJson(response['expense']);
        }
        return Expense.fromJson(response);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _apiClient.delete<dynamic>(ApiEndpoints.expenseById(id));
    } catch (e) {
      rethrow;
    }
  }
}
