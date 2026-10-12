import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../core/database/app_database.dart';
import '../features/guests/data/datasources/demo_guest_source.dart';
import '../features/guests/data/datasources/guest_local_source.dart';
import '../features/guests/data/repositories/local_guest_repository.dart';
import '../features/guests/domain/repositories/guest_repository.dart';

GuestRepository createRepository() {
  final desktop =
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;
  if (desktop) sqfliteFfiInit();
  final database = AppDatabase(desktop ? databaseFactoryFfi : databaseFactory);
  return LocalGuestRepository(GuestLocalSource(database), DemoGuestSource());
}
