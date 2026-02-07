import 'dart:io';
import 'package:excel/excel.dart';
import '../../models/guest_model.dart';

class ExcelImportService {
  Future<List<Guest>> parseExcel(File file) async {
    final bytes = await file.readAsBytes();

    final excel = Excel.decodeBytes(bytes);

    final sheet = excel.tables.values.first;

    final List<Guest> guests = [];

    /// Skip header row
    for (final row in sheet.rows.skip(1)) {
      if (row.isEmpty) continue;

      guests.add(
        Guest(
          guestId: row[0]?.value.toString() ?? '',
          name: row[1]?.value.toString() ?? '',
          location: row[2]?.value.toString() ?? '',
          companions:
          int.tryParse(row[3]?.value.toString() ?? '0') ?? 0,
        ),
      );
    }

    return guests;
  }
}
