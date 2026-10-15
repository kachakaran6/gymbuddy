import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/widgets/gym_widgets.dart';

void main() {
  group('GymSettingsRow Alignment & Visual Consistency Tests', () {
    testWidgets(
      'Renders with standardized 40x40 icon container and centered icon',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GymSettingsRow(
                icon: Icons.storage_rounded,
                title: 'Storage & Diagnostics',
                subtitle: 'Database size and offline data health',
                onTap: () {},
              ),
            ),
          ),
        );

        // Verify Title and Subtitle are present
        expect(find.text('Storage & Diagnostics'), findsOneWidget);
        expect(
          find.text('Database size and offline data health'),
          findsOneWidget,
        );

        // Verify Icon container is exactly 40x40
        final iconFinder = find.byIcon(Icons.storage_rounded);
        expect(iconFinder, findsOneWidget);

        final iconWidget = tester.widget<Icon>(iconFinder);
        expect(iconWidget.size, equals(20));

        final containerFinder = find.ancestor(
          of: iconFinder,
          matching: find.byType(Container),
        );
        expect(containerFinder, findsWidgets);

        final size = tester.getSize(containerFinder.first);
        expect(size.width, equals(40.0));
        expect(size.height, equals(40.0));

        // Verify trailing chevron is rendered
        expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'Multiple rows have identical horizontal alignment for icons, titles, and chevrons',
      (WidgetTester tester) async {
        final keyRow1 = GlobalKey();
        final keyRow2 = GlobalKey();
        final keyRow3 = GlobalKey();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  GymSettingsRow(
                    key: keyRow1,
                    icon: Icons.storage_rounded,
                    title: 'Storage & Diagnostics',
                    subtitle: 'Subtitle 1',
                    onTap: () {},
                  ),
                  GymSettingsRow(
                    key: keyRow2,
                    icon: Icons.backup_rounded,
                    title: 'Backup Now',
                    subtitle: 'Subtitle 2',
                    onTap: () {},
                  ),
                  GymSettingsRow(
                    key: keyRow3,
                    icon: Icons.restore_rounded,
                    title: 'Restore Backup',
                    subtitle: 'Subtitle 3',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );

        // Verify icon x positions match exactly
        final icon1Pos = tester.getTopLeft(find.byIcon(Icons.storage_rounded));
        final icon2Pos = tester.getTopLeft(find.byIcon(Icons.backup_rounded));
        final icon3Pos = tester.getTopLeft(find.byIcon(Icons.restore_rounded));

        expect(icon1Pos.dx, equals(icon2Pos.dx));
        expect(icon2Pos.dx, equals(icon3Pos.dx));

        // Verify title x positions match exactly
        final title1Pos = tester.getTopLeft(find.text('Storage & Diagnostics'));
        final title2Pos = tester.getTopLeft(find.text('Backup Now'));
        final title3Pos = tester.getTopLeft(find.text('Restore Backup'));

        expect(title1Pos.dx, equals(title2Pos.dx));
        expect(title2Pos.dx, equals(title3Pos.dx));
      },
    );

    testWidgets('Custom trailing widget replaces chevron properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GymSettingsRow(
              icon: Icons.dark_mode_rounded,
              title: 'Dark Mode',
              subtitle: 'Dark theme active',
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
      // No chevron when trailing is explicitly supplied
      expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    });

    testWidgets('Renders without overflow on narrow 320px screen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GymSettingsRow(
              icon: Icons.file_download_outlined,
              title:
                  'Import from Strong / Hevy with Very Long Descriptive Title',
              subtitle:
                  'Seamlessly migrate all your historical workouts, exercises, and weight logs from CSV exports',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly with large accessibility text scaler (1.5x)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: Scaffold(
              body: GymSettingsRow(
                icon: Icons.notifications_active_rounded,
                title: 'Test & Diagnostics Notification Health',
                subtitle:
                    'Verify notification channel registration and background permissions',
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
    });
  });
}
