/// Mock user data
class MockUser {
  final String id;
  final String name;
  final String email;
  final String avatarInitial;

  const MockUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarInitial,
  });
}

/// Mock group data
class MockGroup {
  final String id;
  final String name;
  final double totalExpenses;
  final List<MockUser> members;
  final List<MockExpense> expenses;

  const MockGroup({
    required this.id,
    required this.name,
    required this.totalExpenses,
    required this.members,
    required this.expenses,
  });
}

/// Mock expense data
class MockExpense {
  final String id;
  final String title;
  final String category;
  final double amount;
  final String paidBy;
  final String date;
  final String status;
  final List<String> splitWith;

  const MockExpense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.paidBy,
    required this.date,
    required this.status,
    required this.splitWith,
  });
}

/// Mock data service for demo mode
class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Demo credentials
  static const String demoEmail = 'demo@divvyjones.com';
  static const String demoPassword = 'demo123';

  // Current user
  MockUser? _currentUser;
  MockUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // Mock Users
  static const List<MockUser> allUsers = [
    MockUser(
      id: '1',
      name: 'Captain Wiruj',
      email: 'wiruj@divvyjones.com',
      avatarInitial: 'W',
    ),
    MockUser(
      id: '2',
      name: 'Akane',
      email: 'akane@email.com',
      avatarInitial: 'A',
    ),
    MockUser(
      id: '3',
      name: 'Makoto',
      email: 'makoto@email.com',
      avatarInitial: 'M',
    ),
    MockUser(
      id: '4',
      name: 'Sakura',
      email: 'sakura@email.com',
      avatarInitial: 'S',
    ),
    MockUser(
      id: '5',
      name: 'Kenji',
      email: 'kenji@email.com',
      avatarInitial: 'K',
    ),
    MockUser(
      id: '6',
      name: 'Yuki',
      email: 'yuki@email.com',
      avatarInitial: 'Y',
    ),
    MockUser(
      id: '7',
      name: 'Arther',
      email: 'arther@email.com',
      avatarInitial: 'R',
    ),
  ];

  // Mock Expenses
  static const List<MockExpense> mockExpenses = [
    MockExpense(
      id: 'e1',
      title: 'Hidden Backyard Dinner',
      category: 'Food',
      amount: 72.58,
      paidBy: 'Wiruj',
      date: '2 hours ago',
      status: 'Settled',
      splitWith: ['Wiruj', 'Akane', 'Arther'],
    ),
    MockExpense(
      id: 'e2',
      title: 'Movie Night',
      category: 'Entertainment',
      amount: 18.50,
      paidBy: 'Makoto',
      date: 'Yesterday',
      status: 'Pending',
      splitWith: ['Wiruj', 'Makoto'],
    ),
    MockExpense(
      id: 'e3',
      title: 'Taxi to Airport',
      category: 'Transport',
      amount: 45.50,
      paidBy: 'Akane',
      date: 'Jan 20',
      status: 'Pending',
      splitWith: ['Wiruj', 'Akane', 'Makoto'],
    ),
    MockExpense(
      id: 'e4',
      title: 'Hotel Booking',
      category: 'Accommodation',
      amount: 320.00,
      paidBy: 'Makoto',
      date: 'Jan 19',
      status: 'Settled',
      splitWith: ['Wiruj', 'Akane', 'Makoto', 'Sakura', 'Kenji'],
    ),
    MockExpense(
      id: 'e5',
      title: 'Groceries',
      category: 'Shopping',
      amount: 85.00,
      paidBy: 'Wiruj',
      date: 'Jan 18',
      status: 'Settled',
      splitWith: ['Wiruj', 'Sakura'],
    ),
  ];

  // Mock Groups
  List<MockGroup> get groups => [
    MockGroup(
      id: 'g1',
      name: 'South Asia Trip',
      totalExpenses: 2450.00,
      members: allUsers.take(5).toList(),
      expenses: mockExpenses.take(3).toList(),
    ),
    MockGroup(
      id: 'g2',
      name: 'Office Lunch Club',
      totalExpenses: 890.50,
      members: allUsers.skip(1).take(4).toList(),
      expenses: [mockExpenses[0], mockExpenses[4]],
    ),
    MockGroup(
      id: 'g3',
      name: 'Movie Night Gang',
      totalExpenses: 156.00,
      members: [allUsers[0], allUsers[2], allUsers[3]],
      expenses: [mockExpenses[1]],
    ),
    MockGroup(
      id: 'g4',
      name: 'Weekend Hikers',
      totalExpenses: 520.75,
      members: allUsers.skip(3).toList(),
      expenses: [mockExpenses[3], mockExpenses[4]],
    ),
  ];

  // Balance data
  double get totalOwed => 850.00;
  double get totalOwing => 384.56;
  double get netBalance => totalOwed - totalOwing;

  // Recent activity
  List<MockExpense> get recentActivity => mockExpenses.take(3).toList();

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Check demo credentials or any non-empty credentials
    if ((email == demoEmail && password == demoPassword) ||
        (email.contains('@') && password.length >= 4)) {
      _currentUser = allUsers[0]; // Login as Captain Wiruj
      return true;
    }
    return false;
  }

  /// Register new user
  Future<bool> register(String email, String password, String fullName) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.contains('@') && password.length >= 4 && fullName.isNotEmpty) {
      _currentUser = MockUser(
        id: 'new',
        name: fullName,
        email: email,
        avatarInitial: fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
      );
      return true;
    }
    return false;
  }

  /// Logout
  void logout() {
    _currentUser = null;
  }

  /// Get group by ID
  MockGroup? getGroup(String id) {
    try {
      return groups.firstWhere((g) => g.id == id);
    } catch (_) {
      return groups.first;
    }
  }

  /// Add expense (mock)
  Future<bool> addExpense({
    required String description,
    required double amount,
    required String groupId,
    required String category,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, this would add to the database
    return true;
  }

  /// Create group (mock)
  Future<String?> createGroup({
    required String name,
    required List<String> memberIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Return mock group ID
    return 'new_group_${DateTime.now().millisecondsSinceEpoch}';
  }
}
