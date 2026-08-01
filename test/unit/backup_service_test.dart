import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:gymbuddy/data/database/database.dart';
import 'package:gymbuddy/data/services/backup_service.dart';

void main() {
  group('BackupService Logic Tests', () {
    test('serializeBackup generates valid JSON with correct structure', () async {
      final db = AppDatabase(NativeDatabase.memory());
      final backupService = BackupService(db);
      
      final jsonStr = await backupService.serializeBackup();
      final parsed = jsonDecode(jsonStr);
      
      expect(parsed['backupFormatVersion'], 1);
      expect(parsed['schemaVersion'], isNotNull);
      expect(parsed['data'], isA<Map<String, dynamic>>());
      expect(parsed['data']['UserPreferences'], isA<List>());
      
      await db.close();
    });
  });
}
