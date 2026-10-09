import 'dart:io';

import '../data_source/guest_local_data_source.dart';
import '../data_source/services/excel_import_service.dart';
import '../models/guest_model.dart';

enum ScanResult { verified, alreadyVerified, denied }

class GuestRepository {
  final GuestDao _dao = GuestDao();
  final ExcelImportService _excelService = ExcelImportService();

  /// 🔥 Import Excel
  Future<void> importFromExcel(File file) async {
    final guests = await _excelService.parseExcel(file);

    await _dao.insertGuestsBulk(guests);
  }

  /// verify logic
  Future<(ScanResult, Guest?)> verifyGuest(String id) async {
    final guest = await _dao.getGuestById(id);

    if (guest == null) return (ScanResult.denied, null);

    if (guest.verified) {
      return (ScanResult.alreadyVerified, guest);
    }

    await _dao.markVerified(id);

    return (ScanResult.verified, guest);
  }

  /// dashboard stats
  Future<Map<String, int>> getStats() {
    return _dao.getStats();
  }

  Future<List<Guest>> getAllGuests() {
    return _dao.getAllGuests();
  }

  /// clear database
  Future<void> clearAll() {
    return _dao.clearAll();
  }
}
