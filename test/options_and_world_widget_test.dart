import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz/options/options_page.dart';
import 'package:quiz/settings/settings_controller.dart';
import 'package:quiz/settings/settings_repository.dart';
import 'package:quiz/settings/settings_scope.dart';
import 'package:quiz/the_world/world.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Options switches update and persist', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final repository = SettingsRepository();
    final initial = await repository.load();
    final controller = SettingsController(repository: repository, initial: initial);

    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScope(
          controller: controller,
          child: const OptionsPage(),
        ),
      ),
    );

    expect(find.text('Sound effects'), findsOneWidget);

    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('settings.soundEnabled'), false);
  });

  testWidgets('The World node tap opens details sheet', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: World()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('8').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('Champagne Pool'), findsWidgets);
    expect(find.text('#8'), findsOneWidget);
    expect(find.text('Open Location'), findsOneWidget);
  });
}
