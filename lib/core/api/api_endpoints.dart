class ApiEndpoints {
  static const String baseUrl =
      'https://divvy-jones-backend-production.up.railway.app';

  // Auth
  static const String login = '/v1/auth/login';
  static const String register = '/v1/auth/register';
  static const String refresh = '/v1/auth/refresh';
  static const String me = '/v1/auth/me';

  // Groups
  static const String groups = '/v1/groups';
  static String groupById(String id) => '/v1/groups/$id';
  static String groupBalances(String id) => '/v1/groups/$id/balances';
  static String groupExpenses(String id) => '/v1/groups/$id/expenses';
  static const String joinGroup = '/v1/groups/join';

  // Expenses
  static const String expenses = '/v1/expenses';
  static String expenseById(String id) => '/v1/expenses/$id';
}
