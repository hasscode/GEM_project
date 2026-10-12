# EEM — Events Entry Manager

تطبيق Flutter لتسجيل حضور مناسبات التخرج والأفراح. الواجهة عربية واتجاهها RTL،
بالكحلي والنعناعي. النسخة الحالية تعمل محليًا ببيانات تجريبية؛ لا يوجد خادم متصل.

## تشغيل وتجربة

يتطلب Dart 3.9.2 أو أحدث وFlutter متوافقًا. بيئة التحقق: Flutter 3.41.9.

```sh
flutter pub get
flutter run
```

1. افتح «التجربة»، ثم «توليد ٤ ضيوف تجريبيين».
2. افتح تذكرة QR واعرضها على جهاز آخر لمسحها. أو انسخ رمزها والصقه في شاشة المسح لتجربة الجهاز الواحد.
3. أحمد وسارة ويوسف سجلات مكتملة. مريم بدون مكان عمدًا، لاختبار البحث ومراجعة البيانات.
4. أول دخول صحيح يعرض Accepted ويسجل الحضور والوقت. التكرار يعرض «حاضر بالفعل».
5. ابحث بالاسم أو جزء منه، أو بالرقم القومي كاملًا. الأرقام العربية مدعومة.
6. أغلق التطبيق وافتحه: البيانات والحضور محفوظان.
7. إعادة توليد التجربة تتطلب تأكيدًا وتمسح حضور المناسبة التجريبية فقط.

كل أرقام الهوية التجريبية تبدأ بأصفار، وليست أرقامًا قومية حقيقية.
السجل الناقص لا يقبل تلقائيًا؛ تعرض الشاشة الحقول التي تحتاج مراجعة.
صفحة البحث للعرض والتحقق فقط، ولا تمنح تجاوزًا يدويًا لسياسة الحضور.

### APK Release للتجربة على Android

لبناء نسخة منفصلة لا تتعارض مع التطبيق القديم:

```sh
flutter build apk --release --android-project-arg=eemPreview=true
```

الناتج `build/app/outputs/flutter-apk/app-release.apk`، باسم **EEM Preview**
ومعرف `com.example.gem_project.preview`. هذه نسخة Release عامة لمعمارية
ARM وARM64 وx86_64، وتبدأ بقاعدة بيانات مستقلة؛ ولّد الضيوف من صفحة التجربة.
لا تحتاج حذف التطبيق القديم، ولا تنتقل بياناته تلقائيًا إلى نسخة التجربة.
بدون الخيار `eemPreview=true` يظل الاسم ومعرف الحزمة الأصليان دون تغيير.

إعداد Release الحالي يستخدم مفتاح التطوير المحلي للتثبيت المباشر فقط؛
النشر على المتجر يحتاج مفتاح توقيع Release محفوظًا بشكل آمن.
تحديث نسخة Preview لاحقًا يحتاج نفس المفتاح؛ التحويل من Debug إلى Release
وحده لا يعالج تعارض توقيع حزمة موجودة.

## المعمارية

```text
lib/
  app/                 composition root, routing, theme
  core/
    database/          SQLite schema and migration
    widgets/           shared visual components
  features/
    guests/
      domain/          immutable models and repository contract
      data/            DTO, demo source, local source, repository implementation
      presentation/    event Cubit and guest details/cards
    check_in/
      domain/          QR payload, check-in use case and typed outcomes
      presentation/    scan Cubit, camera, manual input and result dialog
    guest_lookup/
      domain/          Arabic normalization and search policy
      presentation/    search and incomplete-record filters
    dashboard/         local statistics
    demo_data/         generation and QR ticket display
    sync/domain/       future backend gateway contract
```

Presentation depends on domain contracts; SQLite and demo details are wired in
`app/dependencies.dart`. Domain has no Flutter, SQLite or networking imports.
Cubit dependencies are constructor-injected. Widgets have separate files,
async work checks closure, refresh retains existing data, and stale loads are ignored.
The previous model/view/view_model implementation and Excel flow were replaced.

## التخزين والحضور

- ملف `gem.db` بإصدار 2، وجدولا `events` و`event_guests`.
- المفتاح المركب `event_id + guest_id` يمنع خلط المناسبات.
- `checked_in`, `checked_in_at`, `pending_sync` محفوظة على القرص.
- القراءة والتحقق وتحديث الحضور داخل transaction واحدة؛ لا يقبل مسحان متزامنان نفس الضيف.
- استيراد/استبدال التجربة transaction واحدة، وأي فشل يعيد البيانات السابقة.
- الترحيل من إصدار 1 يحتفظ بالجدول الأصلي وينسخ الحضور إلى مناسبة «قائمة الضيوف السابقة».
  الرقم القومي القديم غير متاح في المخطط السابق، فيظل فارغًا ويظهر ضمن البيانات الناقصة.
- يمكن اختيار المناسبة من لوحة المتابعة عند وجود أكثر من قائمة.
- القوائم والإحصائيات لعدد الضيوف الأساسيين، لا مجموع المرافقين.
- الإحصائيات لقطة محلية تُحدّث بعد كل تسجيل حضور وعند إعادة التحميل.

QR payload:
```json
{"v":1,"eventId":"demo-graduation","guestId":"GUEST-001"}
```

لا يتضمن QR الاسم أو الرقم القومي. هو معرف تذكرة، وليس توقيعًا أمنيًا.
النسخة الحالية تخزن SQLite محليًا دون تشفير إضافي أو تسجيل دخول.

## المزامنة القادمة

`EventSyncGateway` عقد مستقل لتحميل قائمة مرة واحدة ورفع الحضور على دفعة
بعد المناسبة. لا يوجد endpoint أو إرسال فعلي الآن، ولا يتم مسح
`pending_sync` أو إظهار نجاح رفع وهمي.

عند توفر الخادم: أضف المصدر البعيد والمصادقة ومعرف دفعة ثابتًا لإعادة المحاولة،
ثم امسح فقط العلامات التي أكد الخادم استقبالها. فشل الشبكة يحتفظ بكل الحضور
المعلق. الطلبان هما المسار الطبيعي فقط؛ إعادة المحاولة قد تحتاج طلبات إضافية.

منع التكرار حاليًا على **الجهاز نفسه**. عدة أجهزة تعمل بلا اتصال لا تستطيع
تبادل حالة الحضور؛ يلزم تصميم تنسيق منفصل قبل استخدام عدة بوابات لنفس القائمة.

## المنصات والتحقق

- Android وiOS: SQLite ومسح الكاميرا، مع إعداد وصف/إذن الكاميرا.
- macOS: إعداد SQLite ووصف الكاميرا وentitlement؛ يحتاج تحققًا على Mac.
- Windows وLinux: SQLite عبر FFI، وعرض التذاكر وتجربتها بلصق الرمز.
  حزمة الكاميرا المستخدمة لا تدعم هاتين المنصتين.
- Web ليس هدفًا مدعومًا لهذه النسخة المحلية.

اختبارات محددة للميزات الجديدة:
```sh
flutter analyze
flutter test test/domain/guest_policy_test.dart test/data/local_guest_repository_test.dart test/presentation/cubit_lifecycle_test.dart test/presentation/app_flow_test.dart
flutter build apk --debug
```

تغطي الاختبارات: حالات QR، البحث العربي، الحقول الناقصة، منع المسح المتزامن،
rollback، الترحيل وإعادة فتح SQLite، عمر Cubit، النتائج القديمة، ومسار المستخدم
والشاشة الصغيرة مع تكبير النص. يلزم أيضًا اختبار فعلي لكاميرا هاتف وصلاحياتها
في الضوء الواقعي قبل الاستخدام في مناسبة.

معاينة UI اختيارية على Windows في بيئة التطوير:
`flutter test --dart-define=CAPTURE_UI=true test/presentation/app_flow_test.dart`.
تُحفظ داخل `build/review/`؛ تستخدم خطوط النظام للاختبار البصري فقط.
