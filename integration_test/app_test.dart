import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:meditate/main.dart';
import 'package:provider/provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the start button, verify timer', (tester) async {
      // Load app widget.
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => TimerProvider(),
          child: const MyApp(),
        ),
      );

      // Verify the counter starts at 0.
      expect(find.text('00:05'), findsOneWidget);

      // Finds the floating action button to tap on.
      final fab = find.byTooltip('Start');

      // Emulate a tap on the start button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle(Duration(seconds: 5));

      // Verify the counter increments by 1.
      expect(find.text('reset'), findsOneWidget);
    });
  });
}
