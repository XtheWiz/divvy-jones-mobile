/// Utility for unwrapping the standard backend response format.
///
/// The backend wraps responses as: `{success: bool, data: <payload>}`
/// This class provides consistent unwrapping for both Map and List payloads.
class ResponseUnwrapper {
  const ResponseUnwrapper._();

  /// Unwraps a Map response from `{success, data: {...}}` to just the inner map.
  /// Returns the response as-is if no `data` wrapper is present.
  static Map<String, dynamic> unwrapMap(Map<String, dynamic> response) {
    if (response['data'] != null && response['data'] is Map<String, dynamic>) {
      return response['data'] as Map<String, dynamic>;
    }
    return response;
  }

  /// Unwraps a dynamic response that may contain a list.
  /// Handles: `{success, data: [...]}`, `{success, data: {key: [...]}}`, or a raw `[...]`.
  /// [listKey] is the fallback key to look for inside unwrapped data (e.g. 'groups', 'expenses').
  static List<dynamic> unwrapList(dynamic response, {String? listKey}) {
    if (response is List) {
      return response;
    }

    if (response is Map<String, dynamic>) {
      final data = response['data'];

      // {success, data: [...]}
      if (data is List) {
        return data;
      }

      // {success, data: {key: [...]}}
      if (data is Map<String, dynamic> && listKey != null) {
        final list = data[listKey];
        if (list is List) return list;
      }

      // No wrapper — try listKey directly on response: {key: [...]}
      if (listKey != null) {
        final list = response[listKey];
        if (list is List) return list;
      }

      // Fallback: try 'data' as a list key
      if (data is List) return data;
    }

    return [];
  }
}
