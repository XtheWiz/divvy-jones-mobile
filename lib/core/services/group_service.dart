import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../models/models.dart';

class GroupService {
  final ApiClient _apiClient;

  GroupService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Group>> getGroups() async {
    try {
      final rawResponse = await _apiClient.get<dynamic>(ApiEndpoints.groups);

      Map<String, dynamic> response;
      if (rawResponse is Map<String, dynamic>) {
        response = _unwrapResponse(rawResponse);
      } else {
        return [];
      }

      List<dynamic> groupsList = response['groups'] ?? [];
      if (groupsList.isEmpty && response is List) {
        groupsList = response as List;
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
      final rawResponse = await _apiClient.get<dynamic>(
        ApiEndpoints.groupById(id),
      );

      if (rawResponse is Map<String, dynamic>) {
        final response = _unwrapResponse(rawResponse);
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

  /// Unwrap the backend response which has format: {success: bool, data: {...}}
  Map<String, dynamic> _unwrapResponse(Map<String, dynamic> response) {
    if (response['data'] != null) {
      return response['data'] as Map<String, dynamic>;
    }
    return response;
  }

  Future<Group> createGroup({
    required String name,
    String? currencyCode,
    List<String>? memberIds,
  }) async {
    try {
      final rawResponse = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.groups,
        data: {
          'name': name,
          if (currencyCode != null) 'defaultCurrencyCode': currencyCode,
          if (memberIds != null && memberIds.isNotEmpty) 'memberIds': memberIds,
        },
      );

      final response = _unwrapResponse(rawResponse);

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
      final rawResponse = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.joinGroup,
        data: {'joinCode': joinCode},
      );

      final response = _unwrapResponse(rawResponse);

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
      final rawResponse = await _apiClient.get<dynamic>(
        ApiEndpoints.groupBalances(groupId),
      );

      Map<String, dynamic> response;
      if (rawResponse is Map<String, dynamic>) {
        response = _unwrapResponse(rawResponse);
      } else {
        return [];
      }

      List<dynamic> balancesList = response['balances'] ?? [];

      return balancesList
          .map((json) => Balance.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Expense>> getGroupExpenses(String groupId) async {
    try {
      final rawResponse = await _apiClient.get<dynamic>(
        ApiEndpoints.groupExpenses(groupId),
      );

      Map<String, dynamic> response;
      if (rawResponse is Map<String, dynamic>) {
        response = _unwrapResponse(rawResponse);
      } else {
        return [];
      }

      List<dynamic> expensesList = response['expenses'] ?? [];

      return expensesList
          .map((json) => Expense.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
