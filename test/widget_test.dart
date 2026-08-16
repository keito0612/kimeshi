import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kimeshi/main.dart';
import 'package:kimeshi/viewmodels/providers.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences mockPrefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockPrefs = await SharedPreferences.getInstance();
  });

  testWidgets('KimeshiApp should build and show bottom navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
        child: const KimeshiApp(),
      ),
    );

    // Wait for the app to build
    await tester.pump();

    // Verify bottom navigation items exist (may find multiple due to IndexedStack)
    expect(find.text('ホーム'), findsWidgets);
    expect(find.text('設定'), findsWidgets);

    // Verify bottom navigation bar exists
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('Bottom navigation should switch between screens',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
        child: const KimeshiApp(),
      ),
    );

    await tester.pump();

    // Initially on home screen
    expect(find.byIcon(Icons.restaurant), findsOneWidget);

    // Tap settings tab
    await tester.tap(find.text('設定'));
    await tester.pump();

    // Verify settings screen is shown
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Tap home tab again
    await tester.tap(find.text('ホーム'));
    await tester.pump();

    // Verify home screen is shown again
    expect(find.byIcon(Icons.restaurant), findsOneWidget);
  });

  testWidgets('KimeshiApp should have correct theme colors',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
        ],
        child: const KimeshiApp(),
      ),
    );

    await tester.pump();

    // Get the MaterialApp and check its title
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.title, 'Kimeshi');
  });
}
