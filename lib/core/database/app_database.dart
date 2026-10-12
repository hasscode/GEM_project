import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase(this.factory, {this.path});
  final DatabaseFactory factory;
  final String? path;
  Future<Database>? _opening;

  Future<Database> get database => _opening ??= _open();
  Future<Database> _open() async {
    try {
      final dbPath = path ?? '${await factory.getDatabasesPath()}/gem.db';
      return await factory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 2,
          onConfigure: (db) => db.execute('PRAGMA foreign_keys = ON'),
          onCreate: (db, version) => createSchema(db),
          onUpgrade: (db, old, next) async {
            if (old < 2) {
              await createSchema(db);
              // Preserve the v1 table and its attendance; unknown identity data stays null.
              await db.insert('events', {
                'id': 'legacy',
                'name': 'قائمة الضيوف السابقة',
                'loaded_at': DateTime.now().toUtc().toIso8601String(),
              });
              await db.execute("""
              INSERT INTO event_guests (event_id, guest_id, name, location,
                companions, checked_in, pending_sync)
              SELECT 'legacy', COALESCE(guestId, 'legacy-' || id),
                COALESCE(name, ''), location, companions,
                CASE WHEN verified = 1 THEN 1 ELSE 0 END,
                CASE WHEN verified = 1 THEN 1 ELSE 0 END FROM guests
            """);
            }
          },
        ),
      );
    } catch (_) {
      _opening = null;
      rethrow;
    }
  }

  static Future<void> createSchema(DatabaseExecutor db) async {
    await db.execute('''CREATE TABLE events (
      id TEXT PRIMARY KEY, name TEXT NOT NULL, loaded_at TEXT NOT NULL)''');
    await db.execute('''CREATE TABLE event_guests (
      event_id TEXT NOT NULL REFERENCES events(id), guest_id TEXT NOT NULL,
      name TEXT NOT NULL, national_id TEXT, companions INTEGER, location TEXT,
      checked_in INTEGER NOT NULL DEFAULT 0 CHECK(checked_in IN (0,1)),
      checked_in_at TEXT, pending_sync INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY(event_id, guest_id))''');
    await db.execute(
      'CREATE INDEX guest_identity ON event_guests(event_id, national_id)',
    );
  }

  Future<void> close() async {
    final opening = _opening;
    if (opening != null) await (await opening).close();
    _opening = null;
  }
}
