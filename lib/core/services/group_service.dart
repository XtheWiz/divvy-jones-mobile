import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../models/models.dart';

class GroupService {
  final ApiClient _apiClient;

  GroupService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Group>> getGroups() async {
    try {
      final response = await _apiClient.get<dynamic>(ApiEndpoints.groups);

      List<dynamic> groupsList;
      if (response is Map<String, dynamic>) {
        groupsList = response['groups'] ?? response['data'] ?? [];
      } else if (response is List) {
        groupsList = response;
      } else {
        return [];
      }

      return groupsList
          .map((json) => Group.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Group> getGroupById(String id) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.groupById(id),
      );

      if (response is Map<String, dynamic>) {
        if (response['group'] != null) {
          return Group.fromJson(response['group']);
        }
        return Group.fromJson(response);
      }

      throw Exception('Invalid response format');
    } catch (e) {
      rethrow;
    }
  }

  Future<Group> createGroup({
    required String name,
    String? currencyCode,
    List<String>? memberIds,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.groups,
        data: {
          'name': name,
          if (currencyCode != null) 'default_currency_code': currencyCode,
          if (memberIds != null && memberIds.isNotEmpty) 'member_ids': memberIds,
        },
      );

      if (response['group'] != null) {
        return Group.fromJson(response['group']);
      }
      return Group.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Group> joinGroup(String joinCode) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.joinGroup,
        data: {'join_code': joinCode},
      );

      if (response['group'] != null) {
        return Group.fromJson(response['group']);
      }
      return Group.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Balance>> getGroupBalances(String groupId) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiEndpoints.groupBalances(groupId),
      );

      List<dynamic> balancesList;
      if (response is Map<String, dynamic>) {
        balancesList = response['balances'] ?? response['data'] ?? [];
      } else if (response is List) {
        balancesList = response;
      } else {
        return [];
      }

      return balancesList
          .map((json) => Balance.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

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
}
