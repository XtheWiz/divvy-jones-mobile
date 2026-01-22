import 'package:flutter_test/flutter_test.dart';
import 'package:divvy_jones/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DivvyJonesApp());

    // Verify Sign In screen is shown
    expect(find.text('Sign In'), findsOneWidget);
  });
}
