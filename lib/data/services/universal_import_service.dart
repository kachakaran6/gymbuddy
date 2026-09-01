import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database/database.dart';

class UniversalImportSummary {
  final int workoutsImported;
  final int exercisesMatched;
  final int setsImported;
  final DateTime? earliestDate;
  final DateTime? latestDate;

  const UniversalImportSummary({
    required this.workoutsImported,
    required this.exercisesMatched,
    required this.setsImported,
    this.earliestDate,
    this.latestDate,
  });
}

class UniversalImportService {
  final AppDatabase _db;
  final _uuid = const Uuid();

  UniversalImportService(this._db);

  /// Auto-detects whether the CSV content is from Strong or Hevy, and imports into the database.
  Future<UniversalImportSummary> importCsv(String csvContent) async {
    final lines = const LineSplitter().convert(csvContent);
    if (lines.isEmpty) {
      throw const FormatException('Empty CSV file provided');
    }

    final headerLine = lines.first.toLowerCase();
    if (headerLine.contains('start_time') || headerLine.contains('exercise_title')) {
      return _importHevy(lines);
    } else if (headerLine.contains('workout name') || headerLine.contains('exercise name')) {
      return _importStrong(lines);
    } else {
      throw const FormatException('Unrecognized CSV format. Supported formats: Strong App, Hevy App.');
    }
  }

  /// Parses CSV line respecting quoted commas.
  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    final sb = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(sb.toString().trim());
        sb.clear();
      } else {
        sb.write(char);
      }
    }
    result.add(sb.toString().trim());
    return result;
  }

  Future<UniversalImportSummary> _importStrong(List<String> lines) async {
    final headers = _parseCsvLine(lines.first).map((h) => h.toLowerCase()).toList();

    int dateIdx = headers.indexWhere((h) => h == 'date');
    int workoutIdx = headers.indexWhere((h) => h.contains('workout name') || h == 'workout #');
    int exerciseIdx = headers.indexWhere((h) => h.contains('exercise name'));
    int weightIdx = headers.indexWhere((h) => h.contains('weight'));
    int repsIdx = headers.indexWhere((h) => h == 'reps');
    int secondsIdx = headers.indexWhere((h) => h.contains('seconds') || h == 'duration');

    if (dateIdx == -1 || exerciseIdx == -1) {
      throw const FormatException('Missing required Strong columns (Date, Exercise Name)');
    }

    // Key: date_workoutName
    final sessionsMap = <String, _RawSession>{};

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final cols = _parseCsvLine(line);
      if (cols.length <= dateIdx || cols.length <= exerciseIdx) continue;

      final dateStr = cols[dateIdx];
      DateTime? parsedDate = DateTime.tryParse(dateStr);
      parsedDate ??= _parseFlexibleDate(dateStr);
      if (parsedDate == null) continue;

      final workoutName = workoutIdx != -1 && cols.length > workoutIdx ? cols[workoutIdx] : 'Strong Workout';
      final exerciseName = cols[exerciseIdx];
      final weight = weightIdx != -1 && cols.length > weightIdx ? double.tryParse(cols[weightIdx]) : null;
      final reps = repsIdx != -1 && cols.length > repsIdx ? int.tryParse(cols[repsIdx]) : null;
      final secs = secondsIdx != -1 && cols.length > secondsIdx ? int.tryParse(cols[secondsIdx]) : null;

      final sessionKey = '${parsedDate.toIso8601String()}_$workoutName';
      final session = sessionsMap.putIfAbsent(sessionKey, () => _RawSession(
        startTime: parsedDate!,
        name: workoutName.isNotEmpty ? workoutName : 'Strong Workout',
      ));

      session.entries.add(_RawEntry(
        exerciseName: exerciseName,
        weightKg: weight,
        reps: reps,
        durationSeconds: secs,
      ));
    }

    return _persistSessions(sessionsMap.values.toList());
  }

  Future<UniversalImportSummary> _importHevy(List<String> lines) async {
    final headers = _parseCsvLine(lines.first).map((h) => h.toLowerCase()).toList();

    int startIdx = headers.indexWhere((h) => h.contains('start_time'));
    int endIdx = headers.indexWhere((h) => h.contains('end_time'));
    int titleIdx = headers.indexWhere((h) => h == 'title');
    int exIdx = headers.indexWhere((h) => h.contains('exercise_title'));
    int weightIdx = headers.indexWhere((h) => h.contains('weight_kg'));
    if (weightIdx == -1) weightIdx = headers.indexWhere((h) => h.contains('weight_lbs'));
    int repsIdx = headers.indexWhere((h) => h == 'reps');

    if (startIdx == -1 || exIdx == -1) {
      throw const FormatException('Missing required Hevy columns (start_time, exercise_title)');
    }

    final sessionsMap = <String, _RawSession>{};

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      final cols = _parseCsvLine(line);
      if (cols.length <= startIdx || cols.length <= exIdx) continue;

      final startStr = cols[startIdx];
      final parsedStart = DateTime.tryParse(startStr) ?? _parseFlexibleDate(startStr);
      if (parsedStart == null) continue;

      DateTime? parsedEnd;
      if (endIdx != -1 && cols.length > endIdx) {
        parsedEnd = DateTime.tryParse(cols[endIdx]) ?? _parseFlexibleDate(cols[endIdx]);
      }

      final title = titleIdx != -1 && cols.length > titleIdx ? cols[titleIdx] : 'Hevy Workout';
      final exName = cols[exIdx];
      final weight = weightIdx != -1 && cols.length > weightIdx ? double.tryParse(cols[weightIdx]) : null;
      final reps = repsIdx != -1 && cols.length > repsIdx ? int.tryParse(cols[repsIdx]) : null;

      final key = '${parsedStart.toIso8601String()}_$title';
      final session = sessionsMap.putIfAbsent(key, () => _RawSession(
        startTime: parsedStart,
        endTime: parsedEnd,
        name: title.isNotEmpty ? title : 'Hevy Workout',
      ));

      session.entries.add(_RawEntry(
        exerciseName: exName,
        weightKg: weight,
        reps: reps,
      ));
    }

    return _persistSessions(sessionsMap.values.toList());
  }

  Future<UniversalImportSummary> _persistSessions(List<_RawSession> rawSessions) async {
    if (rawSessions.isEmpty) {
      return const UniversalImportSummary(workoutsImported: 0, exercisesMatched: 0, setsImported: 0);
    }

    final existingDefs = await _db.select(_db.exerciseDefinitions).get();
    final defMap = {for (var d in existingDefs) d.name.toLowerCase().trim(): d.id};

    int workoutsCount = 0;
    int setsCount = 0;
    int matchedExCount = 0;
    DateTime? minDate;
    DateTime? maxDate;

    await _db.transaction(() async {
      for (final s in rawSessions) {
        if (minDate == null || s.startTime.isBefore(minDate!)) minDate = s.startTime;
        if (maxDate == null || s.startTime.isAfter(maxDate!)) maxDate = s.startTime;

        final workoutId = _uuid.v4();
        await _db.into(_db.workouts).insert(
          WorkoutsCompanion.insert(
            id: workoutId,
            startedAt: s.startTime,
            endedAt: Value(s.endTime ?? s.startTime.add(const Duration(minutes: 45))),
            status: 'completed',
            notes: Value(s.name),
          ),
        );
        workoutsCount++;

        // Group entries in this session by exercise name
        final exGroup = <String, List<_RawEntry>>{};
        for (final e in s.entries) {
          exGroup.putIfAbsent(e.exerciseName.trim(), () => []).add(e);
        }

        int exSortOrder = 0;
        for (final entry in exGroup.entries) {
          final rawName = entry.key;
          final norm = rawName.toLowerCase();

          String? defId = defMap[norm];
          if (defId == null) {
            defId = 'imported_${_uuid.v4().substring(0, 8)}';
            await _db.into(_db.exerciseDefinitions).insert(
              ExerciseDefinitionsCompanion.insert(
                id: defId,
                name: rawName,
                category: 'Imported',
                isCustom: const Value(true),
                createdAt: Value(DateTime.now()),
              ),
            );
            defMap[norm] = defId;
          }
          matchedExCount++;

          final workoutExId = _uuid.v4();
          await _db.into(_db.workoutExercises).insert(
            WorkoutExercisesCompanion.insert(
              id: workoutExId,
              workoutId: workoutId,
              exerciseId: defId,
              sortOrder: exSortOrder++,
            ),
          );

          int setSort = 0;
          for (final set in entry.value) {
            await _db.into(_db.workoutSets).insert(
              WorkoutSetsCompanion.insert(
                id: _uuid.v4(),
                workoutExerciseId: workoutExId,
                sortOrder: setSort++,
                weightKg: Value(set.weightKg),
                reps: Value(set.reps),
                durationSeconds: Value(set.durationSeconds),
                completedAt: Value(s.startTime),
              ),
            );
            setsCount++;
          }
        }
      }
    });

    return UniversalImportSummary(
      workoutsImported: workoutsCount,
      exercisesMatched: matchedExCount,
      setsImported: setsCount,
      earliestDate: minDate,
      latestDate: maxDate,
    );
  }

  DateTime? _parseFlexibleDate(String str) {
    try {
      // Handles formats like "2024-03-15 14:30:00" or "15 Mar 2024, 14:30"
      final clean = str.replaceAll('"', '').trim();
      return DateTime.tryParse(clean);
    } catch (_) {
      return null;
    }
  }
}

class _RawSession {
  final DateTime startTime;
  final DateTime? endTime;
  final String name;
  final List<_RawEntry> entries = [];

  _RawSession({required this.startTime, this.endTime, required this.name});
}

class _RawEntry {
  final String exerciseName;
  final double? weightKg;
  final int? reps;
  final int? durationSeconds;

  _RawEntry({
    required this.exerciseName,
    this.weightKg,
    this.reps,
    this.durationSeconds,
  });
}
