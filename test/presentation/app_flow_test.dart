import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gem_project/app/app.dart';
import 'package:gem_project/features/check_in/domain/qr_payload.dart';
import '../support/memory_guest_repository.dart';

void main() {
  testWidgets(
    'generate, inspect ticket, search incomplete guest, check in and reject duplicate',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = MemoryGuestRepository();
      await tester.pumpWidget(GEMApp(repository: repo));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ابدأ بالبيانات التجريبية'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('توليد ٤ ضيوف تجريبيين'));
      await tester.tap(find.text('توليد ٤ ضيوف تجريبيين'));
      await tester.pumpAndSettle();
      expect(repo.guests.length, 4);
      await tester.ensureVisible(find.text('عرض تذكرة QR').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('عرض تذكرة QR').first);
      await tester.pumpAndSettle();
      expect(find.text('تذكرة الدخول'), findsOneWidget);
      await tester.tap(find.text('إغلاق'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('الضيوف'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'مريم');
      await tester.pumpAndSettle();
      expect(find.text('مريم تامر أحمد'), findsOneWidget);
      expect(find.text('المكان: غير مسجل'), findsOneWidget);
      await tester.tap(find.text('نظرة عامة'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('مسح تذكرة الدخول'));
      await tester.pumpAndSettle();
      final raw = QrPayload(
        repo.guests.first.eventId,
        repo.guests.first.id,
      ).encode();
      await tester.ensureVisible(find.byType(TextField));
      await tester.enterText(find.byType(TextField), raw);
      await tester.ensureVisible(find.text('التحقق وتسجيل الحضور'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('التحقق وتسجيل الحضور'));
      await tester.pumpAndSettle();
      expect(find.text('Accepted • تم قبول الدخول'), findsOneWidget);
      await tester.tap(find.text('تم'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('التحقق وتسجيل الحضور'));
      await tester.pumpAndSettle();
      expect(find.text('حاضر بالفعل'), findsOneWidget);
      expect(repo.guests.where((g) => g.checkedIn).length, 1);
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.windows),
  );

  testWidgets('compact layout and enlarged text remain usable', (tester) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(() {
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    final repo = MemoryGuestRepository();
    await repo.generateDemo();
    await tester.pumpWidget(GEMApp(repository: repo));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('الضيوف'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('reset requires confirmation and cancel preserves attendance', (
    tester,
  ) async {
    final repo = MemoryGuestRepository();
    await repo.generateDemo();
    await repo.checkIn(repo.guests.first.eventId, repo.guests.first.id);
    await tester.pumpWidget(GEMApp(repository: repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('التجربة'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('إعادة توليد البيانات التجريبية'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('إعادة توليد البيانات التجريبية'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('إلغاء'));
    await tester.pumpAndSettle();
    expect(repo.guests.where((g) => g.checkedIn).length, 1);
    await tester.tap(find.text('إعادة توليد البيانات التجريبية'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('إعادة توليد البيانات'));
    await tester.pumpAndSettle();
    expect(repo.guests.where((g) => g.checkedIn), isEmpty);
  });

  testWidgets('dashboard visual preview', (tester) async {
    if (const bool.fromEnvironment('CAPTURE_UI')) {
      await tester.runAsync(() async {
        final text = FontLoader('Inter')
          ..addFont(
            File(
              'C:/Windows/Fonts/tahoma.ttf',
            ).readAsBytes().then((v) => ByteData.sublistView(v)),
          );
        final icons = FontLoader('MaterialIcons')
          ..addFont(
            File(
              'C:/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
            ).readAsBytes().then((v) => ByteData.sublistView(v)),
          );
        await text.load();
        await icons.load();
      });
    }
    tester.view.physicalSize = const Size(1100, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repo = MemoryGuestRepository();
    await repo.generateDemo();
    await repo.checkIn(repo.guests.first.eventId, repo.guests.first.id);
    final boundary = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: boundary,
        child: GEMApp(repository: repo),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    for (final preview in {
      'dashboard': const Size(1100, 900),
      'dashboard-mobile': const Size(390, 844),
    }.entries) {
      tester.view.physicalSize = preview.value;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (const bool.fromEnvironment('CAPTURE_UI')) {
        await tester.runAsync(() async {
          final image =
              await (boundary.currentContext!.findRenderObject()
                      as RenderRepaintBoundary)
                  .toImage();
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          await Directory('build/review').create(recursive: true);
          await File(
            'build/review/${preview.key}.png',
          ).writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
    }
  });
}
