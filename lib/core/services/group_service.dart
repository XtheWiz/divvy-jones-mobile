import '../api/api_client.dart';
import '../api/api_endpoints.dart';
import '../api/response_unwrapper.dart';
import '../models/models.dart';
import '../utils/app_logger.dart';

class GroupService {
  static const _log = AppLogger('GroupService');
  final ApiClient _apiClient;

  GroupService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Group>> getGroups() async {
    try {
      final rawResponse = await _apiClient.get<dynamic>(ApiEndpoints.groups);
      final groupsList = ResponseUnwrapper.unwrapList(rawResponse, listKey: 'groups');

      return groupsList
          .map((json) => Group.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _log.error('Failed to fetch groups', e, st);
      rethrow;
    }
  }

  Future<Group> getGroupById(String id) async {
    try {
      final rawResponse = await _apiClient.get<dynamic>(
        ApiEndpoints.groupById(id),
      );

      if (rawResponse is Map<String, dynamic>) {
        final response = ResponseUnwrapper.unwrapMap(rawResponse);
        if (response['group'] != null) {
          return Group.fromJson(response['group']);
        }
        return Group.fromJson(response);
      }

      throw Exception('Invalid response format');
    } catch (e, st) {
      _log.error('Failed to fetch group $id', e, st);
      rethrow;
    }
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

      final response = ResponseUnwrapper.unwrapMap(rawResponse);

      if (response['group'] != null) {
        return Group.fromJson(response['group']);
      }
      return Group.fromJson(response);
    } catch (e, st) {
      _log.error('Failed to create group', e, st);
      rethrow;
    }
  }

  Future<Group> joinGroup(String joinCode) async {
    try {
      final rawResponse = await _apiClient.post<Map<String, dynamic>>(
        ApiEndpoints.joinGroup,
        data: {'joinCode': joinCode},
      );

      final response = ResponseUnwrapper.unwrapMap(rawResponse);

      if (response['group'] != null) {
        return Group.fromJson(response['group']);
      }
      return Group.fromJson(response);
    } catch (e, st) {
      _log.error('Failed to join group', e, st);
      rethrow;
    }
  }

  Future<List<Balance>> getGroupBalances(String groupId) async {
    try {
      final rawResponse = await _apiClient.get<dynamic>(
        ApiEndpoints.groupBalances(groupId),
      );

      final balancesList = ResponseUnwrapper.unwrapList(rawResponse, listKey: 'balances');

      return balancesList
          .map((json) => Balance.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      _log.error('Failed to fetch balances for group $groupId', e, st);
      rethrow;
    }
  }

  Future<List<Expense>> getGroupExpenses(String groupId) async {
    try {
      final rawResponse = await _apiClient.get<dynamic>(
        ApiEndpoints.groupExpenses(groupId),
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
}
