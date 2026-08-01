// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, UserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _accentKeyMeta = const VerificationMeta(
    'accentKey',
  );
  @override
  late final GeneratedColumn<String> accentKey = GeneratedColumn<String>(
    'accent_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('indigo'),
  );
  static const VerificationMeta _weightUnitMeta = const VerificationMeta(
    'weightUnit',
  );
  @override
  late final GeneratedColumn<String> weightUnit = GeneratedColumn<String>(
    'weight_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kg'),
  );
  static const VerificationMeta _onboardingCompleteMeta =
      const VerificationMeta('onboardingComplete');
  @override
  late final GeneratedColumn<bool> onboardingComplete = GeneratedColumn<bool>(
    'onboarding_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notificationPermissionStateMeta =
      const VerificationMeta('notificationPermissionState');
  @override
  late final GeneratedColumn<String> notificationPermissionState =
      GeneratedColumn<String>(
        'notification_permission_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('unknown'),
      );
  static const VerificationMeta _reviewLastRequestedAtMeta =
      const VerificationMeta('reviewLastRequestedAt');
  @override
  late final GeneratedColumn<DateTime> reviewLastRequestedAt =
      GeneratedColumn<DateTime>(
        'review_last_requested_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _reviewEligibleCompletedWorkoutsMeta =
      const VerificationMeta('reviewEligibleCompletedWorkouts');
  @override
  late final GeneratedColumn<int> reviewEligibleCompletedWorkouts =
      GeneratedColumn<int>(
        'review_eligible_completed_workouts',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _schemaVersionMeta = const VerificationMeta(
    'schemaVersion',
  );
  @override
  late final GeneratedColumn<int> schemaVersion = GeneratedColumn<int>(
    'schema_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    accentKey,
    weightUnit,
    onboardingComplete,
    notificationPermissionState,
    reviewLastRequestedAt,
    reviewEligibleCompletedWorkouts,
    schemaVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('accent_key')) {
      context.handle(
        _accentKeyMeta,
        accentKey.isAcceptableOrUnknown(data['accent_key']!, _accentKeyMeta),
      );
    }
    if (data.containsKey('weight_unit')) {
      context.handle(
        _weightUnitMeta,
        weightUnit.isAcceptableOrUnknown(data['weight_unit']!, _weightUnitMeta),
      );
    }
    if (data.containsKey('onboarding_complete')) {
      context.handle(
        _onboardingCompleteMeta,
        onboardingComplete.isAcceptableOrUnknown(
          data['onboarding_complete']!,
          _onboardingCompleteMeta,
        ),
      );
    }
    if (data.containsKey('notification_permission_state')) {
      context.handle(
        _notificationPermissionStateMeta,
        notificationPermissionState.isAcceptableOrUnknown(
          data['notification_permission_state']!,
          _notificationPermissionStateMeta,
        ),
      );
    }
    if (data.containsKey('review_last_requested_at')) {
      context.handle(
        _reviewLastRequestedAtMeta,
        reviewLastRequestedAt.isAcceptableOrUnknown(
          data['review_last_requested_at']!,
          _reviewLastRequestedAtMeta,
        ),
      );
    }
    if (data.containsKey('review_eligible_completed_workouts')) {
      context.handle(
        _reviewEligibleCompletedWorkoutsMeta,
        reviewEligibleCompletedWorkouts.isAcceptableOrUnknown(
          data['review_eligible_completed_workouts']!,
          _reviewEligibleCompletedWorkoutsMeta,
        ),
      );
    }
    if (data.containsKey('schema_version')) {
      context.handle(
        _schemaVersionMeta,
        schemaVersion.isAcceptableOrUnknown(
          data['schema_version']!,
          _schemaVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      accentKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent_key'],
      )!,
      weightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight_unit'],
      )!,
      onboardingComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_complete'],
      )!,
      notificationPermissionState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_permission_state'],
      )!,
      reviewLastRequestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}review_last_requested_at'],
      ),
      reviewEligibleCompletedWorkouts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_eligible_completed_workouts'],
      )!,
      schemaVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}schema_version'],
      )!,
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class UserPreference extends DataClass implements Insertable<UserPreference> {
  final int id;
  final String themeMode;
  final String accentKey;
  final String weightUnit;
  final bool onboardingComplete;
  final String notificationPermissionState;
  final DateTime? reviewLastRequestedAt;
  final int reviewEligibleCompletedWorkouts;
  final int schemaVersion;
  const UserPreference({
    required this.id,
    required this.themeMode,
    required this.accentKey,
    required this.weightUnit,
    required this.onboardingComplete,
    required this.notificationPermissionState,
    this.reviewLastRequestedAt,
    required this.reviewEligibleCompletedWorkouts,
    required this.schemaVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['accent_key'] = Variable<String>(accentKey);
    map['weight_unit'] = Variable<String>(weightUnit);
    map['onboarding_complete'] = Variable<bool>(onboardingComplete);
    map['notification_permission_state'] = Variable<String>(
      notificationPermissionState,
    );
    if (!nullToAbsent || reviewLastRequestedAt != null) {
      map['review_last_requested_at'] = Variable<DateTime>(
        reviewLastRequestedAt,
      );
    }
    map['review_eligible_completed_workouts'] = Variable<int>(
      reviewEligibleCompletedWorkouts,
    );
    map['schema_version'] = Variable<int>(schemaVersion);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      accentKey: Value(accentKey),
      weightUnit: Value(weightUnit),
      onboardingComplete: Value(onboardingComplete),
      notificationPermissionState: Value(notificationPermissionState),
      reviewLastRequestedAt: reviewLastRequestedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewLastRequestedAt),
      reviewEligibleCompletedWorkouts: Value(reviewEligibleCompletedWorkouts),
      schemaVersion: Value(schemaVersion),
    );
  }

  factory UserPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreference(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      accentKey: serializer.fromJson<String>(json['accentKey']),
      weightUnit: serializer.fromJson<String>(json['weightUnit']),
      onboardingComplete: serializer.fromJson<bool>(json['onboardingComplete']),
      notificationPermissionState: serializer.fromJson<String>(
        json['notificationPermissionState'],
      ),
      reviewLastRequestedAt: serializer.fromJson<DateTime?>(
        json['reviewLastRequestedAt'],
      ),
      reviewEligibleCompletedWorkouts: serializer.fromJson<int>(
        json['reviewEligibleCompletedWorkouts'],
      ),
      schemaVersion: serializer.fromJson<int>(json['schemaVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'accentKey': serializer.toJson<String>(accentKey),
      'weightUnit': serializer.toJson<String>(weightUnit),
      'onboardingComplete': serializer.toJson<bool>(onboardingComplete),
      'notificationPermissionState': serializer.toJson<String>(
        notificationPermissionState,
      ),
      'reviewLastRequestedAt': serializer.toJson<DateTime?>(
        reviewLastRequestedAt,
      ),
      'reviewEligibleCompletedWorkouts': serializer.toJson<int>(
        reviewEligibleCompletedWorkouts,
      ),
      'schemaVersion': serializer.toJson<int>(schemaVersion),
    };
  }

  UserPreference copyWith({
    int? id,
    String? themeMode,
    String? accentKey,
    String? weightUnit,
    bool? onboardingComplete,
    String? notificationPermissionState,
    Value<DateTime?> reviewLastRequestedAt = const Value.absent(),
    int? reviewEligibleCompletedWorkouts,
    int? schemaVersion,
  }) => UserPreference(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    accentKey: accentKey ?? this.accentKey,
    weightUnit: weightUnit ?? this.weightUnit,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    notificationPermissionState:
        notificationPermissionState ?? this.notificationPermissionState,
    reviewLastRequestedAt: reviewLastRequestedAt.present
        ? reviewLastRequestedAt.value
        : this.reviewLastRequestedAt,
    reviewEligibleCompletedWorkouts:
        reviewEligibleCompletedWorkouts ?? this.reviewEligibleCompletedWorkouts,
    schemaVersion: schemaVersion ?? this.schemaVersion,
  );
  UserPreference copyWithCompanion(UserPreferencesCompanion data) {
    return UserPreference(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      accentKey: data.accentKey.present ? data.accentKey.value : this.accentKey,
      weightUnit: data.weightUnit.present
          ? data.weightUnit.value
          : this.weightUnit,
      onboardingComplete: data.onboardingComplete.present
          ? data.onboardingComplete.value
          : this.onboardingComplete,
      notificationPermissionState: data.notificationPermissionState.present
          ? data.notificationPermissionState.value
          : this.notificationPermissionState,
      reviewLastRequestedAt: data.reviewLastRequestedAt.present
          ? data.reviewLastRequestedAt.value
          : this.reviewLastRequestedAt,
      reviewEligibleCompletedWorkouts:
          data.reviewEligibleCompletedWorkouts.present
          ? data.reviewEligibleCompletedWorkouts.value
          : this.reviewEligibleCompletedWorkouts,
      schemaVersion: data.schemaVersion.present
          ? data.schemaVersion.value
          : this.schemaVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreference(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentKey: $accentKey, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('notificationPermissionState: $notificationPermissionState, ')
          ..write('reviewLastRequestedAt: $reviewLastRequestedAt, ')
          ..write(
            'reviewEligibleCompletedWorkouts: $reviewEligibleCompletedWorkouts, ',
          )
          ..write('schemaVersion: $schemaVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    accentKey,
    weightUnit,
    onboardingComplete,
    notificationPermissionState,
    reviewLastRequestedAt,
    reviewEligibleCompletedWorkouts,
    schemaVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.accentKey == this.accentKey &&
          other.weightUnit == this.weightUnit &&
          other.onboardingComplete == this.onboardingComplete &&
          other.notificationPermissionState ==
              this.notificationPermissionState &&
          other.reviewLastRequestedAt == this.reviewLastRequestedAt &&
          other.reviewEligibleCompletedWorkouts ==
              this.reviewEligibleCompletedWorkouts &&
          other.schemaVersion == this.schemaVersion);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreference> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<String> accentKey;
  final Value<String> weightUnit;
  final Value<bool> onboardingComplete;
  final Value<String> notificationPermissionState;
  final Value<DateTime?> reviewLastRequestedAt;
  final Value<int> reviewEligibleCompletedWorkouts;
  final Value<int> schemaVersion;
  const UserPreferencesCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentKey = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.notificationPermissionState = const Value.absent(),
    this.reviewLastRequestedAt = const Value.absent(),
    this.reviewEligibleCompletedWorkouts = const Value.absent(),
    this.schemaVersion = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentKey = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.onboardingComplete = const Value.absent(),
    this.notificationPermissionState = const Value.absent(),
    this.reviewLastRequestedAt = const Value.absent(),
    this.reviewEligibleCompletedWorkouts = const Value.absent(),
    this.schemaVersion = const Value.absent(),
  });
  static Insertable<UserPreference> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<String>? accentKey,
    Expression<String>? weightUnit,
    Expression<bool>? onboardingComplete,
    Expression<String>? notificationPermissionState,
    Expression<DateTime>? reviewLastRequestedAt,
    Expression<int>? reviewEligibleCompletedWorkouts,
    Expression<int>? schemaVersion,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (accentKey != null) 'accent_key': accentKey,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (onboardingComplete != null) 'onboarding_complete': onboardingComplete,
      if (notificationPermissionState != null)
        'notification_permission_state': notificationPermissionState,
      if (reviewLastRequestedAt != null)
        'review_last_requested_at': reviewLastRequestedAt,
      if (reviewEligibleCompletedWorkouts != null)
        'review_eligible_completed_workouts': reviewEligibleCompletedWorkouts,
      if (schemaVersion != null) 'schema_version': schemaVersion,
    });
  }

  UserPreferencesCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<String>? accentKey,
    Value<String>? weightUnit,
    Value<bool>? onboardingComplete,
    Value<String>? notificationPermissionState,
    Value<DateTime?>? reviewLastRequestedAt,
    Value<int>? reviewEligibleCompletedWorkouts,
    Value<int>? schemaVersion,
  }) {
    return UserPreferencesCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      accentKey: accentKey ?? this.accentKey,
      weightUnit: weightUnit ?? this.weightUnit,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      notificationPermissionState:
          notificationPermissionState ?? this.notificationPermissionState,
      reviewLastRequestedAt:
          reviewLastRequestedAt ?? this.reviewLastRequestedAt,
      reviewEligibleCompletedWorkouts:
          reviewEligibleCompletedWorkouts ??
          this.reviewEligibleCompletedWorkouts,
      schemaVersion: schemaVersion ?? this.schemaVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (accentKey.present) {
      map['accent_key'] = Variable<String>(accentKey.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(weightUnit.value);
    }
    if (onboardingComplete.present) {
      map['onboarding_complete'] = Variable<bool>(onboardingComplete.value);
    }
    if (notificationPermissionState.present) {
      map['notification_permission_state'] = Variable<String>(
        notificationPermissionState.value,
      );
    }
    if (reviewLastRequestedAt.present) {
      map['review_last_requested_at'] = Variable<DateTime>(
        reviewLastRequestedAt.value,
      );
    }
    if (reviewEligibleCompletedWorkouts.present) {
      map['review_eligible_completed_workouts'] = Variable<int>(
        reviewEligibleCompletedWorkouts.value,
      );
    }
    if (schemaVersion.present) {
      map['schema_version'] = Variable<int>(schemaVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentKey: $accentKey, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('onboardingComplete: $onboardingComplete, ')
          ..write('notificationPermissionState: $notificationPermissionState, ')
          ..write('reviewLastRequestedAt: $reviewLastRequestedAt, ')
          ..write(
            'reviewEligibleCompletedWorkouts: $reviewEligibleCompletedWorkouts, ',
          )
          ..write('schemaVersion: $schemaVersion')
          ..write(')'))
        .toString();
  }
}

class $GymSchedulesTable extends GymSchedules
    with TableInfo<$GymSchedulesTable, GymSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GymSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _weekdayMeta = const VerificationMeta(
    'weekday',
  );
  @override
  late final GeneratedColumn<int> weekday = GeneratedColumn<int>(
    'weekday',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _gymHourMeta = const VerificationMeta(
    'gymHour',
  );
  @override
  late final GeneratedColumn<int> gymHour = GeneratedColumn<int>(
    'gym_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(18),
  );
  static const VerificationMeta _gymMinuteMeta = const VerificationMeta(
    'gymMinute',
  );
  @override
  late final GeneratedColumn<int> gymMinute = GeneratedColumn<int>(
    'gym_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cutoffOffsetMinutesMeta =
      const VerificationMeta('cutoffOffsetMinutes');
  @override
  late final GeneratedColumn<int> cutoffOffsetMinutes = GeneratedColumn<int>(
    'cutoff_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    weekday,
    enabled,
    gymHour,
    gymMinute,
    cutoffOffsetMinutes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gym_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<GymSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('weekday')) {
      context.handle(
        _weekdayMeta,
        weekday.isAcceptableOrUnknown(data['weekday']!, _weekdayMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('gym_hour')) {
      context.handle(
        _gymHourMeta,
        gymHour.isAcceptableOrUnknown(data['gym_hour']!, _gymHourMeta),
      );
    }
    if (data.containsKey('gym_minute')) {
      context.handle(
        _gymMinuteMeta,
        gymMinute.isAcceptableOrUnknown(data['gym_minute']!, _gymMinuteMeta),
      );
    }
    if (data.containsKey('cutoff_offset_minutes')) {
      context.handle(
        _cutoffOffsetMinutesMeta,
        cutoffOffsetMinutes.isAcceptableOrUnknown(
          data['cutoff_offset_minutes']!,
          _cutoffOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {weekday};
  @override
  GymSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GymSchedule(
      weekday: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekday'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      gymHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gym_hour'],
      )!,
      gymMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gym_minute'],
      )!,
      cutoffOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cutoff_offset_minutes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GymSchedulesTable createAlias(String alias) {
    return $GymSchedulesTable(attachedDatabase, alias);
  }
}

class GymSchedule extends DataClass implements Insertable<GymSchedule> {
  final int weekday;
  final bool enabled;
  final int gymHour;
  final int gymMinute;
  final int cutoffOffsetMinutes;
  final DateTime updatedAt;
  const GymSchedule({
    required this.weekday,
    required this.enabled,
    required this.gymHour,
    required this.gymMinute,
    required this.cutoffOffsetMinutes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['weekday'] = Variable<int>(weekday);
    map['enabled'] = Variable<bool>(enabled);
    map['gym_hour'] = Variable<int>(gymHour);
    map['gym_minute'] = Variable<int>(gymMinute);
    map['cutoff_offset_minutes'] = Variable<int>(cutoffOffsetMinutes);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GymSchedulesCompanion toCompanion(bool nullToAbsent) {
    return GymSchedulesCompanion(
      weekday: Value(weekday),
      enabled: Value(enabled),
      gymHour: Value(gymHour),
      gymMinute: Value(gymMinute),
      cutoffOffsetMinutes: Value(cutoffOffsetMinutes),
      updatedAt: Value(updatedAt),
    );
  }

  factory GymSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GymSchedule(
      weekday: serializer.fromJson<int>(json['weekday']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      gymHour: serializer.fromJson<int>(json['gymHour']),
      gymMinute: serializer.fromJson<int>(json['gymMinute']),
      cutoffOffsetMinutes: serializer.fromJson<int>(
        json['cutoffOffsetMinutes'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'weekday': serializer.toJson<int>(weekday),
      'enabled': serializer.toJson<bool>(enabled),
      'gymHour': serializer.toJson<int>(gymHour),
      'gymMinute': serializer.toJson<int>(gymMinute),
      'cutoffOffsetMinutes': serializer.toJson<int>(cutoffOffsetMinutes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GymSchedule copyWith({
    int? weekday,
    bool? enabled,
    int? gymHour,
    int? gymMinute,
    int? cutoffOffsetMinutes,
    DateTime? updatedAt,
  }) => GymSchedule(
    weekday: weekday ?? this.weekday,
    enabled: enabled ?? this.enabled,
    gymHour: gymHour ?? this.gymHour,
    gymMinute: gymMinute ?? this.gymMinute,
    cutoffOffsetMinutes: cutoffOffsetMinutes ?? this.cutoffOffsetMinutes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GymSchedule copyWithCompanion(GymSchedulesCompanion data) {
    return GymSchedule(
      weekday: data.weekday.present ? data.weekday.value : this.weekday,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      gymHour: data.gymHour.present ? data.gymHour.value : this.gymHour,
      gymMinute: data.gymMinute.present ? data.gymMinute.value : this.gymMinute,
      cutoffOffsetMinutes: data.cutoffOffsetMinutes.present
          ? data.cutoffOffsetMinutes.value
          : this.cutoffOffsetMinutes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GymSchedule(')
          ..write('weekday: $weekday, ')
          ..write('enabled: $enabled, ')
          ..write('gymHour: $gymHour, ')
          ..write('gymMinute: $gymMinute, ')
          ..write('cutoffOffsetMinutes: $cutoffOffsetMinutes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    weekday,
    enabled,
    gymHour,
    gymMinute,
    cutoffOffsetMinutes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GymSchedule &&
          other.weekday == this.weekday &&
          other.enabled == this.enabled &&
          other.gymHour == this.gymHour &&
          other.gymMinute == this.gymMinute &&
          other.cutoffOffsetMinutes == this.cutoffOffsetMinutes &&
          other.updatedAt == this.updatedAt);
}

class GymSchedulesCompanion extends UpdateCompanion<GymSchedule> {
  final Value<int> weekday;
  final Value<bool> enabled;
  final Value<int> gymHour;
  final Value<int> gymMinute;
  final Value<int> cutoffOffsetMinutes;
  final Value<DateTime> updatedAt;
  const GymSchedulesCompanion({
    this.weekday = const Value.absent(),
    this.enabled = const Value.absent(),
    this.gymHour = const Value.absent(),
    this.gymMinute = const Value.absent(),
    this.cutoffOffsetMinutes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  GymSchedulesCompanion.insert({
    this.weekday = const Value.absent(),
    this.enabled = const Value.absent(),
    this.gymHour = const Value.absent(),
    this.gymMinute = const Value.absent(),
    this.cutoffOffsetMinutes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<GymSchedule> custom({
    Expression<int>? weekday,
    Expression<bool>? enabled,
    Expression<int>? gymHour,
    Expression<int>? gymMinute,
    Expression<int>? cutoffOffsetMinutes,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (weekday != null) 'weekday': weekday,
      if (enabled != null) 'enabled': enabled,
      if (gymHour != null) 'gym_hour': gymHour,
      if (gymMinute != null) 'gym_minute': gymMinute,
      if (cutoffOffsetMinutes != null)
        'cutoff_offset_minutes': cutoffOffsetMinutes,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  GymSchedulesCompanion copyWith({
    Value<int>? weekday,
    Value<bool>? enabled,
    Value<int>? gymHour,
    Value<int>? gymMinute,
    Value<int>? cutoffOffsetMinutes,
    Value<DateTime>? updatedAt,
  }) {
    return GymSchedulesCompanion(
      weekday: weekday ?? this.weekday,
      enabled: enabled ?? this.enabled,
      gymHour: gymHour ?? this.gymHour,
      gymMinute: gymMinute ?? this.gymMinute,
      cutoffOffsetMinutes: cutoffOffsetMinutes ?? this.cutoffOffsetMinutes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (weekday.present) {
      map['weekday'] = Variable<int>(weekday.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (gymHour.present) {
      map['gym_hour'] = Variable<int>(gymHour.value);
    }
    if (gymMinute.present) {
      map['gym_minute'] = Variable<int>(gymMinute.value);
    }
    if (cutoffOffsetMinutes.present) {
      map['cutoff_offset_minutes'] = Variable<int>(cutoffOffsetMinutes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GymSchedulesCompanion(')
          ..write('weekday: $weekday, ')
          ..write('enabled: $enabled, ')
          ..write('gymHour: $gymHour, ')
          ..write('gymMinute: $gymMinute, ')
          ..write('cutoffOffsetMinutes: $cutoffOffsetMinutes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReminderOffsetsTable extends ReminderOffsets
    with TableInfo<$ReminderOffsetsTable, ReminderOffset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderOffsetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _offsetMinutesMeta = const VerificationMeta(
    'offsetMinutes',
  );
  @override
  late final GeneratedColumn<int> offsetMinutes = GeneratedColumn<int>(
    'offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, offsetMinutes, enabled, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_offsets';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderOffset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('offset_minutes')) {
      context.handle(
        _offsetMinutesMeta,
        offsetMinutes.isAcceptableOrUnknown(
          data['offset_minutes']!,
          _offsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_offsetMinutesMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderOffset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderOffset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      offsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}offset_minutes'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ReminderOffsetsTable createAlias(String alias) {
    return $ReminderOffsetsTable(attachedDatabase, alias);
  }
}

class ReminderOffset extends DataClass implements Insertable<ReminderOffset> {
  final int id;
  final int offsetMinutes;
  final bool enabled;
  final int sortOrder;
  const ReminderOffset({
    required this.id,
    required this.offsetMinutes,
    required this.enabled,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['offset_minutes'] = Variable<int>(offsetMinutes);
    map['enabled'] = Variable<bool>(enabled);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ReminderOffsetsCompanion toCompanion(bool nullToAbsent) {
    return ReminderOffsetsCompanion(
      id: Value(id),
      offsetMinutes: Value(offsetMinutes),
      enabled: Value(enabled),
      sortOrder: Value(sortOrder),
    );
  }

  factory ReminderOffset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderOffset(
      id: serializer.fromJson<int>(json['id']),
      offsetMinutes: serializer.fromJson<int>(json['offsetMinutes']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'offsetMinutes': serializer.toJson<int>(offsetMinutes),
      'enabled': serializer.toJson<bool>(enabled),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ReminderOffset copyWith({
    int? id,
    int? offsetMinutes,
    bool? enabled,
    int? sortOrder,
  }) => ReminderOffset(
    id: id ?? this.id,
    offsetMinutes: offsetMinutes ?? this.offsetMinutes,
    enabled: enabled ?? this.enabled,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ReminderOffset copyWithCompanion(ReminderOffsetsCompanion data) {
    return ReminderOffset(
      id: data.id.present ? data.id.value : this.id,
      offsetMinutes: data.offsetMinutes.present
          ? data.offsetMinutes.value
          : this.offsetMinutes,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderOffset(')
          ..write('id: $id, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, offsetMinutes, enabled, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderOffset &&
          other.id == this.id &&
          other.offsetMinutes == this.offsetMinutes &&
          other.enabled == this.enabled &&
          other.sortOrder == this.sortOrder);
}

class ReminderOffsetsCompanion extends UpdateCompanion<ReminderOffset> {
  final Value<int> id;
  final Value<int> offsetMinutes;
  final Value<bool> enabled;
  final Value<int> sortOrder;
  const ReminderOffsetsCompanion({
    this.id = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    this.enabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  ReminderOffsetsCompanion.insert({
    this.id = const Value.absent(),
    required int offsetMinutes,
    this.enabled = const Value.absent(),
    required int sortOrder,
  }) : offsetMinutes = Value(offsetMinutes),
       sortOrder = Value(sortOrder);
  static Insertable<ReminderOffset> custom({
    Expression<int>? id,
    Expression<int>? offsetMinutes,
    Expression<bool>? enabled,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (offsetMinutes != null) 'offset_minutes': offsetMinutes,
      if (enabled != null) 'enabled': enabled,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  ReminderOffsetsCompanion copyWith({
    Value<int>? id,
    Value<int>? offsetMinutes,
    Value<bool>? enabled,
    Value<int>? sortOrder,
  }) {
    return ReminderOffsetsCompanion(
      id: id ?? this.id,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (offsetMinutes.present) {
      map['offset_minutes'] = Variable<int>(offsetMinutes.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderOffsetsCompanion(')
          ..write('id: $id, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $AttendancesTable extends Attendances
    with TableInfo<$AttendancesTable, Attendance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkedInAtMeta = const VerificationMeta(
    'checkedInAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedInAt = GeneratedColumn<DateTime>(
    'checked_in_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localDate,
    status,
    checkedInAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Attendance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('checked_in_at')) {
      context.handle(
        _checkedInAtMeta,
        checkedInAt.isAcceptableOrUnknown(
          data['checked_in_at']!,
          _checkedInAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localDate};
  @override
  Attendance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Attendance(
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      checkedInAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_in_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AttendancesTable createAlias(String alias) {
    return $AttendancesTable(attachedDatabase, alias);
  }
}

class Attendance extends DataClass implements Insertable<Attendance> {
  final String localDate;
  final String status;
  final DateTime? checkedInAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Attendance({
    required this.localDate,
    required this.status,
    this.checkedInAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_date'] = Variable<String>(localDate);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || checkedInAt != null) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AttendancesCompanion toCompanion(bool nullToAbsent) {
    return AttendancesCompanion(
      localDate: Value(localDate),
      status: Value(status),
      checkedInAt: checkedInAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedInAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Attendance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Attendance(
      localDate: serializer.fromJson<String>(json['localDate']),
      status: serializer.fromJson<String>(json['status']),
      checkedInAt: serializer.fromJson<DateTime?>(json['checkedInAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localDate': serializer.toJson<String>(localDate),
      'status': serializer.toJson<String>(status),
      'checkedInAt': serializer.toJson<DateTime?>(checkedInAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Attendance copyWith({
    String? localDate,
    String? status,
    Value<DateTime?> checkedInAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Attendance(
    localDate: localDate ?? this.localDate,
    status: status ?? this.status,
    checkedInAt: checkedInAt.present ? checkedInAt.value : this.checkedInAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Attendance copyWithCompanion(AttendancesCompanion data) {
    return Attendance(
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      status: data.status.present ? data.status.value : this.status,
      checkedInAt: data.checkedInAt.present
          ? data.checkedInAt.value
          : this.checkedInAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Attendance(')
          ..write('localDate: $localDate, ')
          ..write('status: $status, ')
          ..write('checkedInAt: $checkedInAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(localDate, status, checkedInAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Attendance &&
          other.localDate == this.localDate &&
          other.status == this.status &&
          other.checkedInAt == this.checkedInAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AttendancesCompanion extends UpdateCompanion<Attendance> {
  final Value<String> localDate;
  final Value<String> status;
  final Value<DateTime?> checkedInAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AttendancesCompanion({
    this.localDate = const Value.absent(),
    this.status = const Value.absent(),
    this.checkedInAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendancesCompanion.insert({
    required String localDate,
    required String status,
    this.checkedInAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : localDate = Value(localDate),
       status = Value(status);
  static Insertable<Attendance> custom({
    Expression<String>? localDate,
    Expression<String>? status,
    Expression<DateTime>? checkedInAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localDate != null) 'local_date': localDate,
      if (status != null) 'status': status,
      if (checkedInAt != null) 'checked_in_at': checkedInAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendancesCompanion copyWith({
    Value<String>? localDate,
    Value<String>? status,
    Value<DateTime?>? checkedInAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AttendancesCompanion(
      localDate: localDate ?? this.localDate,
      status: status ?? this.status,
      checkedInAt: checkedInAt ?? this.checkedInAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (checkedInAt.present) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendancesCompanion(')
          ..write('localDate: $localDate, ')
          ..write('status: $status, ')
          ..write('checkedInAt: $checkedInAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attendanceDateMeta = const VerificationMeta(
    'attendanceDate',
  );
  @override
  late final GeneratedColumn<String> attendanceDate = GeneratedColumn<String>(
    'attendance_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    attendanceDate,
    startedAt,
    endedAt,
    status,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Workout> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('attendance_date')) {
      context.handle(
        _attendanceDateMeta,
        attendanceDate.isAcceptableOrUnknown(
          data['attendance_date']!,
          _attendanceDateMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      attendanceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attendance_date'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  final String id;
  final String? attendanceDate;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Workout({
    required this.id,
    this.attendanceDate,
    required this.startedAt,
    this.endedAt,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || attendanceDate != null) {
      map['attendance_date'] = Variable<String>(attendanceDate);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      attendanceDate: attendanceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(attendanceDate),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Workout.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<String>(json['id']),
      attendanceDate: serializer.fromJson<String?>(json['attendanceDate']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'attendanceDate': serializer.toJson<String?>(attendanceDate),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Workout copyWith({
    String? id,
    Value<String?> attendanceDate = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    String? status,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Workout(
    id: id ?? this.id,
    attendanceDate: attendanceDate.present
        ? attendanceDate.value
        : this.attendanceDate,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Workout copyWithCompanion(WorkoutsCompanion data) {
    return Workout(
      id: data.id.present ? data.id.value : this.id,
      attendanceDate: data.attendanceDate.present
          ? data.attendanceDate.value
          : this.attendanceDate,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('attendanceDate: $attendanceDate, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    attendanceDate,
    startedAt,
    endedAt,
    status,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.attendanceDate == this.attendanceDate &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<String> id;
  final Value<String?> attendanceDate;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.attendanceDate = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    required String id,
    this.attendanceDate = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required String status,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAt = Value(startedAt),
       status = Value(status);
  static Insertable<Workout> custom({
    Expression<String>? id,
    Expression<String>? attendanceDate,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (attendanceDate != null) 'attendance_date': attendanceDate,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsCompanion copyWith({
    Value<String>? id,
    Value<String?>? attendanceDate,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<String>? status,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (attendanceDate.present) {
      map['attendance_date'] = Variable<String>(attendanceDate.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('attendanceDate: $attendanceDate, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExerciseDefinitionsTable extends ExerciseDefinitions
    with TableInfo<$ExerciseDefinitionsTable, ExerciseDefinition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    isCustom,
    isFavorite,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseDefinition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseDefinition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseDefinition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExerciseDefinitionsTable createAlias(String alias) {
    return $ExerciseDefinitionsTable(attachedDatabase, alias);
  }
}

class ExerciseDefinition extends DataClass
    implements Insertable<ExerciseDefinition> {
  final String id;
  final String name;
  final String category;
  final bool isCustom;
  final bool isFavorite;
  final DateTime createdAt;
  const ExerciseDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.isCustom,
    required this.isFavorite,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['is_custom'] = Variable<bool>(isCustom);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExerciseDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseDefinitionsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      isCustom: Value(isCustom),
      isFavorite: Value(isFavorite),
      createdAt: Value(createdAt),
    );
  }

  factory ExerciseDefinition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseDefinition(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'isCustom': serializer.toJson<bool>(isCustom),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExerciseDefinition copyWith({
    String? id,
    String? name,
    String? category,
    bool? isCustom,
    bool? isFavorite,
    DateTime? createdAt,
  }) => ExerciseDefinition(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    isCustom: isCustom ?? this.isCustom,
    isFavorite: isFavorite ?? this.isFavorite,
    createdAt: createdAt ?? this.createdAt,
  );
  ExerciseDefinition copyWithCompanion(ExerciseDefinitionsCompanion data) {
    return ExerciseDefinition(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseDefinition(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, category, isCustom, isFavorite, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseDefinition &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.isCustom == this.isCustom &&
          other.isFavorite == this.isFavorite &&
          other.createdAt == this.createdAt);
}

class ExerciseDefinitionsCompanion extends UpdateCompanion<ExerciseDefinition> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<bool> isCustom;
  final Value<bool> isFavorite;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExerciseDefinitionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExerciseDefinitionsCompanion.insert({
    required String id,
    required String name,
    required String category,
    this.isCustom = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category);
  static Insertable<ExerciseDefinition> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<bool>? isCustom,
    Expression<bool>? isFavorite,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (isCustom != null) 'is_custom': isCustom,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExerciseDefinitionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<bool>? isCustom,
    Value<bool>? isFavorite,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ExerciseDefinitionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isCustom: isCustom ?? this.isCustom,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseDefinitionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('isCustom: $isCustom, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTable extends WorkoutExercises
    with TableInfo<$WorkoutExercisesTable, WorkoutExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workouts (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercise_definitions (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, workoutId, exerciseId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WorkoutExercisesTable createAlias(String alias) {
    return $WorkoutExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutExercise extends DataClass implements Insertable<WorkoutExercise> {
  final String id;
  final String workoutId;
  final String exerciseId;
  final int sortOrder;
  const WorkoutExercise({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      sortOrder: Value(sortOrder),
    );
  }

  factory WorkoutExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercise(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WorkoutExercise copyWith({
    String? id,
    String? workoutId,
    String? exerciseId,
    int? sortOrder,
  }) => WorkoutExercise(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WorkoutExercise copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExercise(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercise(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutId, exerciseId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExercise &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.sortOrder == this.sortOrder);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExercise> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<String> exerciseId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    required String id,
    required String workoutId,
    required String exerciseId,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutId = Value(workoutId),
       exerciseId = Value(exerciseId),
       sortOrder = Value(sortOrder);
  static Insertable<WorkoutExercise> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<String>? exerciseId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutId,
    Value<String>? exerciseId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workoutExerciseIdMeta = const VerificationMeta(
    'workoutExerciseId',
  );
  @override
  late final GeneratedColumn<String> workoutExerciseId =
      GeneratedColumn<String>(
        'workout_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workout_exercises (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setTypeMeta = const VerificationMeta(
    'setType',
  );
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
    'set_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('normal'),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _estimatedCaloriesMeta = const VerificationMeta(
    'estimatedCalories',
  );
  @override
  late final GeneratedColumn<int> estimatedCalories = GeneratedColumn<int>(
    'estimated_calories',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutExerciseId,
    sortOrder,
    setType,
    weightKg,
    reps,
    durationSeconds,
    distanceMeters,
    estimatedCalories,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_exercise_id')) {
      context.handle(
        _workoutExerciseIdMeta,
        workoutExerciseId.isAcceptableOrUnknown(
          data['workout_exercise_id']!,
          _workoutExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workoutExerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('set_type')) {
      context.handle(
        _setTypeMeta,
        setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta),
      );
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    }
    if (data.containsKey('estimated_calories')) {
      context.handle(
        _estimatedCaloriesMeta,
        estimatedCalories.isAcceptableOrUnknown(
          data['estimated_calories']!,
          _estimatedCaloriesMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workoutExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}workout_exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      setType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}set_type'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      ),
      estimatedCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_calories'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final String id;
  final String workoutExerciseId;
  final int sortOrder;
  final String setType;
  final double? weightKg;
  final int? reps;
  final int? durationSeconds;
  final double? distanceMeters;
  final int? estimatedCalories;
  final DateTime? completedAt;
  const WorkoutSet({
    required this.id,
    required this.workoutExerciseId,
    required this.sortOrder,
    required this.setType,
    this.weightKg,
    this.reps,
    this.durationSeconds,
    this.distanceMeters,
    this.estimatedCalories,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_exercise_id'] = Variable<String>(workoutExerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    map['set_type'] = Variable<String>(setType);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    if (!nullToAbsent || distanceMeters != null) {
      map['distance_meters'] = Variable<double>(distanceMeters);
    }
    if (!nullToAbsent || estimatedCalories != null) {
      map['estimated_calories'] = Variable<int>(estimatedCalories);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      workoutExerciseId: Value(workoutExerciseId),
      sortOrder: Value(sortOrder),
      setType: Value(setType),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
      distanceMeters: distanceMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceMeters),
      estimatedCalories: estimatedCalories == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedCalories),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<String>(json['id']),
      workoutExerciseId: serializer.fromJson<String>(json['workoutExerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      setType: serializer.fromJson<String>(json['setType']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      reps: serializer.fromJson<int?>(json['reps']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      distanceMeters: serializer.fromJson<double?>(json['distanceMeters']),
      estimatedCalories: serializer.fromJson<int?>(json['estimatedCalories']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutExerciseId': serializer.toJson<String>(workoutExerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'setType': serializer.toJson<String>(setType),
      'weightKg': serializer.toJson<double?>(weightKg),
      'reps': serializer.toJson<int?>(reps),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'distanceMeters': serializer.toJson<double?>(distanceMeters),
      'estimatedCalories': serializer.toJson<int?>(estimatedCalories),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  WorkoutSet copyWith({
    String? id,
    String? workoutExerciseId,
    int? sortOrder,
    String? setType,
    Value<double?> weightKg = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    Value<double?> distanceMeters = const Value.absent(),
    Value<int?> estimatedCalories = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => WorkoutSet(
    id: id ?? this.id,
    workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
    setType: setType ?? this.setType,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    reps: reps.present ? reps.value : this.reps,
    durationSeconds: durationSeconds.present
        ? durationSeconds.value
        : this.durationSeconds,
    distanceMeters: distanceMeters.present
        ? distanceMeters.value
        : this.distanceMeters,
    estimatedCalories: estimatedCalories.present
        ? estimatedCalories.value
        : this.estimatedCalories,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      workoutExerciseId: data.workoutExerciseId.present
          ? data.workoutExerciseId.value
          : this.workoutExerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      setType: data.setType.present ? data.setType.value : this.setType,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      estimatedCalories: data.estimatedCalories.present
          ? data.estimatedCalories.value
          : this.estimatedCalories,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('setType: $setType, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('estimatedCalories: $estimatedCalories, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workoutExerciseId,
    sortOrder,
    setType,
    weightKg,
    reps,
    durationSeconds,
    distanceMeters,
    estimatedCalories,
    completedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.workoutExerciseId == this.workoutExerciseId &&
          other.sortOrder == this.sortOrder &&
          other.setType == this.setType &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.durationSeconds == this.durationSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.estimatedCalories == this.estimatedCalories &&
          other.completedAt == this.completedAt);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<String> id;
  final Value<String> workoutExerciseId;
  final Value<int> sortOrder;
  final Value<String> setType;
  final Value<double?> weightKg;
  final Value<int?> reps;
  final Value<int?> durationSeconds;
  final Value<double?> distanceMeters;
  final Value<int?> estimatedCalories;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.workoutExerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.setType = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.estimatedCalories = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    required String id,
    required String workoutExerciseId,
    required int sortOrder,
    this.setType = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.estimatedCalories = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workoutExerciseId = Value(workoutExerciseId),
       sortOrder = Value(sortOrder);
  static Insertable<WorkoutSet> custom({
    Expression<String>? id,
    Expression<String>? workoutExerciseId,
    Expression<int>? sortOrder,
    Expression<String>? setType,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<int>? durationSeconds,
    Expression<double>? distanceMeters,
    Expression<int>? estimatedCalories,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutExerciseId != null) 'workout_exercise_id': workoutExerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (setType != null) 'set_type': setType,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (estimatedCalories != null) 'estimated_calories': estimatedCalories,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? workoutExerciseId,
    Value<int>? sortOrder,
    Value<String>? setType,
    Value<double?>? weightKg,
    Value<int?>? reps,
    Value<int?>? durationSeconds,
    Value<double?>? distanceMeters,
    Value<int?>? estimatedCalories,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      workoutExerciseId: workoutExerciseId ?? this.workoutExerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      setType: setType ?? this.setType,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutExerciseId.present) {
      map['workout_exercise_id'] = Variable<String>(workoutExerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (estimatedCalories.present) {
      map['estimated_calories'] = Variable<int>(estimatedCalories.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('workoutExerciseId: $workoutExerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('setType: $setType, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('estimatedCalories: $estimatedCalories, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementAwardsTable extends AchievementAwards
    with TableInfo<$AchievementAwardsTable, AchievementAward> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementAwardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _achievementIdMeta = const VerificationMeta(
    'achievementId',
  );
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
    'achievement_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _awardedAtMeta = const VerificationMeta(
    'awardedAt',
  );
  @override
  late final GeneratedColumn<DateTime> awardedAt = GeneratedColumn<DateTime>(
    'awarded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [achievementId, awardedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievement_awards';
  @override
  VerificationContext validateIntegrity(
    Insertable<AchievementAward> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('achievement_id')) {
      context.handle(
        _achievementIdMeta,
        achievementId.isAcceptableOrUnknown(
          data['achievement_id']!,
          _achievementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('awarded_at')) {
      context.handle(
        _awardedAtMeta,
        awardedAt.isAcceptableOrUnknown(data['awarded_at']!, _awardedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {achievementId};
  @override
  AchievementAward map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementAward(
      achievementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_id'],
      )!,
      awardedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}awarded_at'],
      )!,
    );
  }

  @override
  $AchievementAwardsTable createAlias(String alias) {
    return $AchievementAwardsTable(attachedDatabase, alias);
  }
}

class AchievementAward extends DataClass
    implements Insertable<AchievementAward> {
  final String achievementId;
  final DateTime awardedAt;
  const AchievementAward({
    required this.achievementId,
    required this.awardedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['achievement_id'] = Variable<String>(achievementId);
    map['awarded_at'] = Variable<DateTime>(awardedAt);
    return map;
  }

  AchievementAwardsCompanion toCompanion(bool nullToAbsent) {
    return AchievementAwardsCompanion(
      achievementId: Value(achievementId),
      awardedAt: Value(awardedAt),
    );
  }

  factory AchievementAward.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementAward(
      achievementId: serializer.fromJson<String>(json['achievementId']),
      awardedAt: serializer.fromJson<DateTime>(json['awardedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'achievementId': serializer.toJson<String>(achievementId),
      'awardedAt': serializer.toJson<DateTime>(awardedAt),
    };
  }

  AchievementAward copyWith({String? achievementId, DateTime? awardedAt}) =>
      AchievementAward(
        achievementId: achievementId ?? this.achievementId,
        awardedAt: awardedAt ?? this.awardedAt,
      );
  AchievementAward copyWithCompanion(AchievementAwardsCompanion data) {
    return AchievementAward(
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      awardedAt: data.awardedAt.present ? data.awardedAt.value : this.awardedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementAward(')
          ..write('achievementId: $achievementId, ')
          ..write('awardedAt: $awardedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(achievementId, awardedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementAward &&
          other.achievementId == this.achievementId &&
          other.awardedAt == this.awardedAt);
}

class AchievementAwardsCompanion extends UpdateCompanion<AchievementAward> {
  final Value<String> achievementId;
  final Value<DateTime> awardedAt;
  final Value<int> rowid;
  const AchievementAwardsCompanion({
    this.achievementId = const Value.absent(),
    this.awardedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementAwardsCompanion.insert({
    required String achievementId,
    this.awardedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : achievementId = Value(achievementId);
  static Insertable<AchievementAward> custom({
    Expression<String>? achievementId,
    Expression<DateTime>? awardedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (achievementId != null) 'achievement_id': achievementId,
      if (awardedAt != null) 'awarded_at': awardedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementAwardsCompanion copyWith({
    Value<String>? achievementId,
    Value<DateTime>? awardedAt,
    Value<int>? rowid,
  }) {
    return AchievementAwardsCompanion(
      achievementId: achievementId ?? this.achievementId,
      awardedAt: awardedAt ?? this.awardedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (awardedAt.present) {
      map['awarded_at'] = Variable<DateTime>(awardedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementAwardsCompanion(')
          ..write('achievementId: $achievementId, ')
          ..write('awardedAt: $awardedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $XpEventsTable extends XpEvents with TableInfo<$XpEventsTable, XpEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $XpEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _awardKeyMeta = const VerificationMeta(
    'awardKey',
  );
  @override
  late final GeneratedColumn<String> awardKey = GeneratedColumn<String>(
    'award_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'UNIQUE NOT NULL',
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    awardKey,
    sourceType,
    amount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'xp_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<XpEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('award_key')) {
      context.handle(
        _awardKeyMeta,
        awardKey.isAcceptableOrUnknown(data['award_key']!, _awardKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_awardKeyMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  XpEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return XpEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      awardKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}award_key'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $XpEventsTable createAlias(String alias) {
    return $XpEventsTable(attachedDatabase, alias);
  }
}

class XpEvent extends DataClass implements Insertable<XpEvent> {
  final String id;
  final String awardKey;
  final String sourceType;
  final int amount;
  final DateTime createdAt;
  const XpEvent({
    required this.id,
    required this.awardKey,
    required this.sourceType,
    required this.amount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['award_key'] = Variable<String>(awardKey);
    map['source_type'] = Variable<String>(sourceType);
    map['amount'] = Variable<int>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  XpEventsCompanion toCompanion(bool nullToAbsent) {
    return XpEventsCompanion(
      id: Value(id),
      awardKey: Value(awardKey),
      sourceType: Value(sourceType),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory XpEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return XpEvent(
      id: serializer.fromJson<String>(json['id']),
      awardKey: serializer.fromJson<String>(json['awardKey']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      amount: serializer.fromJson<int>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'awardKey': serializer.toJson<String>(awardKey),
      'sourceType': serializer.toJson<String>(sourceType),
      'amount': serializer.toJson<int>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  XpEvent copyWith({
    String? id,
    String? awardKey,
    String? sourceType,
    int? amount,
    DateTime? createdAt,
  }) => XpEvent(
    id: id ?? this.id,
    awardKey: awardKey ?? this.awardKey,
    sourceType: sourceType ?? this.sourceType,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
  );
  XpEvent copyWithCompanion(XpEventsCompanion data) {
    return XpEvent(
      id: data.id.present ? data.id.value : this.id,
      awardKey: data.awardKey.present ? data.awardKey.value : this.awardKey,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('XpEvent(')
          ..write('id: $id, ')
          ..write('awardKey: $awardKey, ')
          ..write('sourceType: $sourceType, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, awardKey, sourceType, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is XpEvent &&
          other.id == this.id &&
          other.awardKey == this.awardKey &&
          other.sourceType == this.sourceType &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class XpEventsCompanion extends UpdateCompanion<XpEvent> {
  final Value<String> id;
  final Value<String> awardKey;
  final Value<String> sourceType;
  final Value<int> amount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const XpEventsCompanion({
    this.id = const Value.absent(),
    this.awardKey = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  XpEventsCompanion.insert({
    required String id,
    required String awardKey,
    required String sourceType,
    required int amount,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       awardKey = Value(awardKey),
       sourceType = Value(sourceType),
       amount = Value(amount);
  static Insertable<XpEvent> custom({
    Expression<String>? id,
    Expression<String>? awardKey,
    Expression<String>? sourceType,
    Expression<int>? amount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (awardKey != null) 'award_key': awardKey,
      if (sourceType != null) 'source_type': sourceType,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  XpEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? awardKey,
    Value<String>? sourceType,
    Value<int>? amount,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return XpEventsCompanion(
      id: id ?? this.id,
      awardKey: awardKey ?? this.awardKey,
      sourceType: sourceType ?? this.sourceType,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (awardKey.present) {
      map['award_key'] = Variable<String>(awardKey.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('XpEventsCompanion(')
          ..write('id: $id, ')
          ..write('awardKey: $awardKey, ')
          ..write('sourceType: $sourceType, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationScheduleLogsTable extends NotificationScheduleLogs
    with TableInfo<$NotificationScheduleLogsTable, NotificationScheduleLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationScheduleLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<int> notificationId = GeneratedColumn<int>(
    'notification_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localDateMeta = const VerificationMeta(
    'localDate',
  );
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
    'local_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _offsetMinutesMeta = const VerificationMeta(
    'offsetMinutes',
  );
  @override
  late final GeneratedColumn<int> offsetMinutes = GeneratedColumn<int>(
    'offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledForMeta = const VerificationMeta(
    'scheduledFor',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledFor = GeneratedColumn<DateTime>(
    'scheduled_for',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    notificationId,
    localDate,
    offsetMinutes,
    scheduledFor,
    state,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_schedule_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationScheduleLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    }
    if (data.containsKey('local_date')) {
      context.handle(
        _localDateMeta,
        localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta),
      );
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('offset_minutes')) {
      context.handle(
        _offsetMinutesMeta,
        offsetMinutes.isAcceptableOrUnknown(
          data['offset_minutes']!,
          _offsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_offsetMinutesMeta);
    }
    if (data.containsKey('scheduled_for')) {
      context.handle(
        _scheduledForMeta,
        scheduledFor.isAcceptableOrUnknown(
          data['scheduled_for']!,
          _scheduledForMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledForMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {notificationId};
  @override
  NotificationScheduleLog map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationScheduleLog(
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}notification_id'],
      )!,
      localDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_date'],
      )!,
      offsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}offset_minutes'],
      )!,
      scheduledFor: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_for'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotificationScheduleLogsTable createAlias(String alias) {
    return $NotificationScheduleLogsTable(attachedDatabase, alias);
  }
}

class NotificationScheduleLog extends DataClass
    implements Insertable<NotificationScheduleLog> {
  final int notificationId;
  final String localDate;
  final int offsetMinutes;
  final DateTime scheduledFor;
  final String state;
  final DateTime updatedAt;
  const NotificationScheduleLog({
    required this.notificationId,
    required this.localDate,
    required this.offsetMinutes,
    required this.scheduledFor,
    required this.state,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['notification_id'] = Variable<int>(notificationId);
    map['local_date'] = Variable<String>(localDate);
    map['offset_minutes'] = Variable<int>(offsetMinutes);
    map['scheduled_for'] = Variable<DateTime>(scheduledFor);
    map['state'] = Variable<String>(state);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotificationScheduleLogsCompanion toCompanion(bool nullToAbsent) {
    return NotificationScheduleLogsCompanion(
      notificationId: Value(notificationId),
      localDate: Value(localDate),
      offsetMinutes: Value(offsetMinutes),
      scheduledFor: Value(scheduledFor),
      state: Value(state),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotificationScheduleLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationScheduleLog(
      notificationId: serializer.fromJson<int>(json['notificationId']),
      localDate: serializer.fromJson<String>(json['localDate']),
      offsetMinutes: serializer.fromJson<int>(json['offsetMinutes']),
      scheduledFor: serializer.fromJson<DateTime>(json['scheduledFor']),
      state: serializer.fromJson<String>(json['state']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'notificationId': serializer.toJson<int>(notificationId),
      'localDate': serializer.toJson<String>(localDate),
      'offsetMinutes': serializer.toJson<int>(offsetMinutes),
      'scheduledFor': serializer.toJson<DateTime>(scheduledFor),
      'state': serializer.toJson<String>(state),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NotificationScheduleLog copyWith({
    int? notificationId,
    String? localDate,
    int? offsetMinutes,
    DateTime? scheduledFor,
    String? state,
    DateTime? updatedAt,
  }) => NotificationScheduleLog(
    notificationId: notificationId ?? this.notificationId,
    localDate: localDate ?? this.localDate,
    offsetMinutes: offsetMinutes ?? this.offsetMinutes,
    scheduledFor: scheduledFor ?? this.scheduledFor,
    state: state ?? this.state,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NotificationScheduleLog copyWithCompanion(
    NotificationScheduleLogsCompanion data,
  ) {
    return NotificationScheduleLog(
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      offsetMinutes: data.offsetMinutes.present
          ? data.offsetMinutes.value
          : this.offsetMinutes,
      scheduledFor: data.scheduledFor.present
          ? data.scheduledFor.value
          : this.scheduledFor,
      state: data.state.present ? data.state.value : this.state,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationScheduleLog(')
          ..write('notificationId: $notificationId, ')
          ..write('localDate: $localDate, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('state: $state, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    notificationId,
    localDate,
    offsetMinutes,
    scheduledFor,
    state,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationScheduleLog &&
          other.notificationId == this.notificationId &&
          other.localDate == this.localDate &&
          other.offsetMinutes == this.offsetMinutes &&
          other.scheduledFor == this.scheduledFor &&
          other.state == this.state &&
          other.updatedAt == this.updatedAt);
}

class NotificationScheduleLogsCompanion
    extends UpdateCompanion<NotificationScheduleLog> {
  final Value<int> notificationId;
  final Value<String> localDate;
  final Value<int> offsetMinutes;
  final Value<DateTime> scheduledFor;
  final Value<String> state;
  final Value<DateTime> updatedAt;
  const NotificationScheduleLogsCompanion({
    this.notificationId = const Value.absent(),
    this.localDate = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    this.scheduledFor = const Value.absent(),
    this.state = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  NotificationScheduleLogsCompanion.insert({
    this.notificationId = const Value.absent(),
    required String localDate,
    required int offsetMinutes,
    required DateTime scheduledFor,
    required String state,
    this.updatedAt = const Value.absent(),
  }) : localDate = Value(localDate),
       offsetMinutes = Value(offsetMinutes),
       scheduledFor = Value(scheduledFor),
       state = Value(state);
  static Insertable<NotificationScheduleLog> custom({
    Expression<int>? notificationId,
    Expression<String>? localDate,
    Expression<int>? offsetMinutes,
    Expression<DateTime>? scheduledFor,
    Expression<String>? state,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (notificationId != null) 'notification_id': notificationId,
      if (localDate != null) 'local_date': localDate,
      if (offsetMinutes != null) 'offset_minutes': offsetMinutes,
      if (scheduledFor != null) 'scheduled_for': scheduledFor,
      if (state != null) 'state': state,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  NotificationScheduleLogsCompanion copyWith({
    Value<int>? notificationId,
    Value<String>? localDate,
    Value<int>? offsetMinutes,
    Value<DateTime>? scheduledFor,
    Value<String>? state,
    Value<DateTime>? updatedAt,
  }) {
    return NotificationScheduleLogsCompanion(
      notificationId: notificationId ?? this.notificationId,
      localDate: localDate ?? this.localDate,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      state: state ?? this.state,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (notificationId.present) {
      map['notification_id'] = Variable<int>(notificationId.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (offsetMinutes.present) {
      map['offset_minutes'] = Variable<int>(offsetMinutes.value);
    }
    if (scheduledFor.present) {
      map['scheduled_for'] = Variable<DateTime>(scheduledFor.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationScheduleLogsCompanion(')
          ..write('notificationId: $notificationId, ')
          ..write('localDate: $localDate, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('scheduledFor: $scheduledFor, ')
          ..write('state: $state, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTemplatesTable extends WorkoutTemplates
    with TableInfo<$WorkoutTemplatesTable, WorkoutTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WorkoutTemplatesTable createAlias(String alias) {
    return $WorkoutTemplatesTable(attachedDatabase, alias);
  }
}

class WorkoutTemplate extends DataClass implements Insertable<WorkoutTemplate> {
  final String id;
  final String name;
  final DateTime createdAt;
  const WorkoutTemplate({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkoutTemplatesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory WorkoutTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTemplate(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorkoutTemplate copyWith({String? id, String? name, DateTime? createdAt}) =>
      WorkoutTemplate(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  WorkoutTemplate copyWithCompanion(WorkoutTemplatesCompanion data) {
    return WorkoutTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class WorkoutTemplatesCompanion extends UpdateCompanion<WorkoutTemplate> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WorkoutTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutTemplatesCompanion.insert({
    required String id,
    required String name,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<WorkoutTemplate> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return WorkoutTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTemplateExercisesTable extends WorkoutTemplateExercises
    with TableInfo<$WorkoutTemplateExercisesTable, WorkoutTemplateExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTemplateExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_templates (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercise_definitions (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, templateId, exerciseId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_template_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutTemplateExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTemplateExercise map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTemplateExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $WorkoutTemplateExercisesTable createAlias(String alias) {
    return $WorkoutTemplateExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutTemplateExercise extends DataClass
    implements Insertable<WorkoutTemplateExercise> {
  final String id;
  final String templateId;
  final String exerciseId;
  final int sortOrder;
  const WorkoutTemplateExercise({
    required this.id,
    required this.templateId,
    required this.exerciseId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  WorkoutTemplateExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTemplateExercisesCompanion(
      id: Value(id),
      templateId: Value(templateId),
      exerciseId: Value(exerciseId),
      sortOrder: Value(sortOrder),
    );
  }

  factory WorkoutTemplateExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTemplateExercise(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  WorkoutTemplateExercise copyWith({
    String? id,
    String? templateId,
    String? exerciseId,
    int? sortOrder,
  }) => WorkoutTemplateExercise(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    exerciseId: exerciseId ?? this.exerciseId,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  WorkoutTemplateExercise copyWithCompanion(
    WorkoutTemplateExercisesCompanion data,
  ) {
    return WorkoutTemplateExercise(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplateExercise(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, templateId, exerciseId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTemplateExercise &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.exerciseId == this.exerciseId &&
          other.sortOrder == this.sortOrder);
}

class WorkoutTemplateExercisesCompanion
    extends UpdateCompanion<WorkoutTemplateExercise> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<String> exerciseId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const WorkoutTemplateExercisesCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutTemplateExercisesCompanion.insert({
    required String id,
    required String templateId,
    required String exerciseId,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       templateId = Value(templateId),
       exerciseId = Value(exerciseId),
       sortOrder = Value(sortOrder);
  static Insertable<WorkoutTemplateExercise> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<String>? exerciseId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutTemplateExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? templateId,
    Value<String>? exerciseId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return WorkoutTemplateExercisesCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      exerciseId: exerciseId ?? this.exerciseId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTemplateExercisesCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserPreferencesTable userPreferences = $UserPreferencesTable(
    this,
  );
  late final $GymSchedulesTable gymSchedules = $GymSchedulesTable(this);
  late final $ReminderOffsetsTable reminderOffsets = $ReminderOffsetsTable(
    this,
  );
  late final $AttendancesTable attendances = $AttendancesTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $ExerciseDefinitionsTable exerciseDefinitions =
      $ExerciseDefinitionsTable(this);
  late final $WorkoutExercisesTable workoutExercises = $WorkoutExercisesTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $AchievementAwardsTable achievementAwards =
      $AchievementAwardsTable(this);
  late final $XpEventsTable xpEvents = $XpEventsTable(this);
  late final $NotificationScheduleLogsTable notificationScheduleLogs =
      $NotificationScheduleLogsTable(this);
  late final $WorkoutTemplatesTable workoutTemplates = $WorkoutTemplatesTable(
    this,
  );
  late final $WorkoutTemplateExercisesTable workoutTemplateExercises =
      $WorkoutTemplateExercisesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userPreferences,
    gymSchedules,
    reminderOffsets,
    attendances,
    workouts,
    exerciseDefinitions,
    workoutExercises,
    workoutSets,
    achievementAwards,
    xpEvents,
    notificationScheduleLogs,
    workoutTemplates,
    workoutTemplateExercises,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workouts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_exercises', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_exercises',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('workout_sets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'workout_templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('workout_template_exercises', kind: UpdateKind.delete),
      ],
    ),
  ]);
}

typedef $$UserPreferencesTableCreateCompanionBuilder =
    UserPreferencesCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> accentKey,
      Value<String> weightUnit,
      Value<bool> onboardingComplete,
      Value<String> notificationPermissionState,
      Value<DateTime?> reviewLastRequestedAt,
      Value<int> reviewEligibleCompletedWorkouts,
      Value<int> schemaVersion,
    });
typedef $$UserPreferencesTableUpdateCompanionBuilder =
    UserPreferencesCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<String> accentKey,
      Value<String> weightUnit,
      Value<bool> onboardingComplete,
      Value<String> notificationPermissionState,
      Value<DateTime?> reviewLastRequestedAt,
      Value<int> reviewEligibleCompletedWorkouts,
      Value<int> schemaVersion,
    });

class $$UserPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accentKey => $composableBuilder(
    column: $table.accentKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notificationPermissionState => $composableBuilder(
    column: $table.notificationPermissionState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewLastRequestedAt => $composableBuilder(
    column: $table.reviewLastRequestedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewEligibleCompletedWorkouts => $composableBuilder(
    column: $table.reviewEligibleCompletedWorkouts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accentKey => $composableBuilder(
    column: $table.accentKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notificationPermissionState => $composableBuilder(
    column: $table.notificationPermissionState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewLastRequestedAt => $composableBuilder(
    column: $table.reviewLastRequestedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewEligibleCompletedWorkouts =>
      $composableBuilder(
        column: $table.reviewEligibleCompletedWorkouts,
        builder: (column) => ColumnOrderings(column),
      );

  ColumnOrderings<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get accentKey =>
      $composableBuilder(column: $table.accentKey, builder: (column) => column);

  GeneratedColumn<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingComplete => $composableBuilder(
    column: $table.onboardingComplete,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notificationPermissionState => $composableBuilder(
    column: $table.notificationPermissionState,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reviewLastRequestedAt => $composableBuilder(
    column: $table.reviewLastRequestedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reviewEligibleCompletedWorkouts =>
      $composableBuilder(
        column: $table.reviewEligibleCompletedWorkouts,
        builder: (column) => column,
      );

  GeneratedColumn<int> get schemaVersion => $composableBuilder(
    column: $table.schemaVersion,
    builder: (column) => column,
  );
}

class $$UserPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTable,
          UserPreference,
          $$UserPreferencesTableFilterComposer,
          $$UserPreferencesTableOrderingComposer,
          $$UserPreferencesTableAnnotationComposer,
          $$UserPreferencesTableCreateCompanionBuilder,
          $$UserPreferencesTableUpdateCompanionBuilder,
          (
            UserPreference,
            BaseReferences<
              _$AppDatabase,
              $UserPreferencesTable,
              UserPreference
            >,
          ),
          UserPreference,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> accentKey = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String> notificationPermissionState =
                    const Value.absent(),
                Value<DateTime?> reviewLastRequestedAt = const Value.absent(),
                Value<int> reviewEligibleCompletedWorkouts =
                    const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
              }) => UserPreferencesCompanion(
                id: id,
                themeMode: themeMode,
                accentKey: accentKey,
                weightUnit: weightUnit,
                onboardingComplete: onboardingComplete,
                notificationPermissionState: notificationPermissionState,
                reviewLastRequestedAt: reviewLastRequestedAt,
                reviewEligibleCompletedWorkouts:
                    reviewEligibleCompletedWorkouts,
                schemaVersion: schemaVersion,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> accentKey = const Value.absent(),
                Value<String> weightUnit = const Value.absent(),
                Value<bool> onboardingComplete = const Value.absent(),
                Value<String> notificationPermissionState =
                    const Value.absent(),
                Value<DateTime?> reviewLastRequestedAt = const Value.absent(),
                Value<int> reviewEligibleCompletedWorkouts =
                    const Value.absent(),
                Value<int> schemaVersion = const Value.absent(),
              }) => UserPreferencesCompanion.insert(
                id: id,
                themeMode: themeMode,
                accentKey: accentKey,
                weightUnit: weightUnit,
                onboardingComplete: onboardingComplete,
                notificationPermissionState: notificationPermissionState,
                reviewLastRequestedAt: reviewLastRequestedAt,
                reviewEligibleCompletedWorkouts:
                    reviewEligibleCompletedWorkouts,
                schemaVersion: schemaVersion,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTable,
      UserPreference,
      $$UserPreferencesTableFilterComposer,
      $$UserPreferencesTableOrderingComposer,
      $$UserPreferencesTableAnnotationComposer,
      $$UserPreferencesTableCreateCompanionBuilder,
      $$UserPreferencesTableUpdateCompanionBuilder,
      (
        UserPreference,
        BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreference>,
      ),
      UserPreference,
      PrefetchHooks Function()
    >;
typedef $$GymSchedulesTableCreateCompanionBuilder =
    GymSchedulesCompanion Function({
      Value<int> weekday,
      Value<bool> enabled,
      Value<int> gymHour,
      Value<int> gymMinute,
      Value<int> cutoffOffsetMinutes,
      Value<DateTime> updatedAt,
    });
typedef $$GymSchedulesTableUpdateCompanionBuilder =
    GymSchedulesCompanion Function({
      Value<int> weekday,
      Value<bool> enabled,
      Value<int> gymHour,
      Value<int> gymMinute,
      Value<int> cutoffOffsetMinutes,
      Value<DateTime> updatedAt,
    });

class $$GymSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $GymSchedulesTable> {
  $$GymSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gymHour => $composableBuilder(
    column: $table.gymHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gymMinute => $composableBuilder(
    column: $table.gymMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cutoffOffsetMinutes => $composableBuilder(
    column: $table.cutoffOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GymSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $GymSchedulesTable> {
  $$GymSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get weekday => $composableBuilder(
    column: $table.weekday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gymHour => $composableBuilder(
    column: $table.gymHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gymMinute => $composableBuilder(
    column: $table.gymMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cutoffOffsetMinutes => $composableBuilder(
    column: $table.cutoffOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GymSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GymSchedulesTable> {
  $$GymSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get weekday =>
      $composableBuilder(column: $table.weekday, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get gymHour =>
      $composableBuilder(column: $table.gymHour, builder: (column) => column);

  GeneratedColumn<int> get gymMinute =>
      $composableBuilder(column: $table.gymMinute, builder: (column) => column);

  GeneratedColumn<int> get cutoffOffsetMinutes => $composableBuilder(
    column: $table.cutoffOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GymSchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GymSchedulesTable,
          GymSchedule,
          $$GymSchedulesTableFilterComposer,
          $$GymSchedulesTableOrderingComposer,
          $$GymSchedulesTableAnnotationComposer,
          $$GymSchedulesTableCreateCompanionBuilder,
          $$GymSchedulesTableUpdateCompanionBuilder,
          (
            GymSchedule,
            BaseReferences<_$AppDatabase, $GymSchedulesTable, GymSchedule>,
          ),
          GymSchedule,
          PrefetchHooks Function()
        > {
  $$GymSchedulesTableTableManager(_$AppDatabase db, $GymSchedulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GymSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GymSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GymSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> weekday = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> gymHour = const Value.absent(),
                Value<int> gymMinute = const Value.absent(),
                Value<int> cutoffOffsetMinutes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GymSchedulesCompanion(
                weekday: weekday,
                enabled: enabled,
                gymHour: gymHour,
                gymMinute: gymMinute,
                cutoffOffsetMinutes: cutoffOffsetMinutes,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> weekday = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> gymHour = const Value.absent(),
                Value<int> gymMinute = const Value.absent(),
                Value<int> cutoffOffsetMinutes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => GymSchedulesCompanion.insert(
                weekday: weekday,
                enabled: enabled,
                gymHour: gymHour,
                gymMinute: gymMinute,
                cutoffOffsetMinutes: cutoffOffsetMinutes,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GymSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GymSchedulesTable,
      GymSchedule,
      $$GymSchedulesTableFilterComposer,
      $$GymSchedulesTableOrderingComposer,
      $$GymSchedulesTableAnnotationComposer,
      $$GymSchedulesTableCreateCompanionBuilder,
      $$GymSchedulesTableUpdateCompanionBuilder,
      (
        GymSchedule,
        BaseReferences<_$AppDatabase, $GymSchedulesTable, GymSchedule>,
      ),
      GymSchedule,
      PrefetchHooks Function()
    >;
typedef $$ReminderOffsetsTableCreateCompanionBuilder =
    ReminderOffsetsCompanion Function({
      Value<int> id,
      required int offsetMinutes,
      Value<bool> enabled,
      required int sortOrder,
    });
typedef $$ReminderOffsetsTableUpdateCompanionBuilder =
    ReminderOffsetsCompanion Function({
      Value<int> id,
      Value<int> offsetMinutes,
      Value<bool> enabled,
      Value<int> sortOrder,
    });

class $$ReminderOffsetsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderOffsetsTable> {
  $$ReminderOffsetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReminderOffsetsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderOffsetsTable> {
  $$ReminderOffsetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderOffsetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderOffsetsTable> {
  $$ReminderOffsetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$ReminderOffsetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderOffsetsTable,
          ReminderOffset,
          $$ReminderOffsetsTableFilterComposer,
          $$ReminderOffsetsTableOrderingComposer,
          $$ReminderOffsetsTableAnnotationComposer,
          $$ReminderOffsetsTableCreateCompanionBuilder,
          $$ReminderOffsetsTableUpdateCompanionBuilder,
          (
            ReminderOffset,
            BaseReferences<
              _$AppDatabase,
              $ReminderOffsetsTable,
              ReminderOffset
            >,
          ),
          ReminderOffset,
          PrefetchHooks Function()
        > {
  $$ReminderOffsetsTableTableManager(
    _$AppDatabase db,
    $ReminderOffsetsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderOffsetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderOffsetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderOffsetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> offsetMinutes = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => ReminderOffsetsCompanion(
                id: id,
                offsetMinutes: offsetMinutes,
                enabled: enabled,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int offsetMinutes,
                Value<bool> enabled = const Value.absent(),
                required int sortOrder,
              }) => ReminderOffsetsCompanion.insert(
                id: id,
                offsetMinutes: offsetMinutes,
                enabled: enabled,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderOffsetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderOffsetsTable,
      ReminderOffset,
      $$ReminderOffsetsTableFilterComposer,
      $$ReminderOffsetsTableOrderingComposer,
      $$ReminderOffsetsTableAnnotationComposer,
      $$ReminderOffsetsTableCreateCompanionBuilder,
      $$ReminderOffsetsTableUpdateCompanionBuilder,
      (
        ReminderOffset,
        BaseReferences<_$AppDatabase, $ReminderOffsetsTable, ReminderOffset>,
      ),
      ReminderOffset,
      PrefetchHooks Function()
    >;
typedef $$AttendancesTableCreateCompanionBuilder =
    AttendancesCompanion Function({
      required String localDate,
      required String status,
      Value<DateTime?> checkedInAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AttendancesTableUpdateCompanionBuilder =
    AttendancesCompanion Function({
      Value<String> localDate,
      Value<String> status,
      Value<DateTime?> checkedInAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AttendancesTableFilterComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AttendancesTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AttendancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendancesTable> {
  $$AttendancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AttendancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendancesTable,
          Attendance,
          $$AttendancesTableFilterComposer,
          $$AttendancesTableOrderingComposer,
          $$AttendancesTableAnnotationComposer,
          $$AttendancesTableCreateCompanionBuilder,
          $$AttendancesTableUpdateCompanionBuilder,
          (
            Attendance,
            BaseReferences<_$AppDatabase, $AttendancesTable, Attendance>,
          ),
          Attendance,
          PrefetchHooks Function()
        > {
  $$AttendancesTableTableManager(_$AppDatabase db, $AttendancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localDate = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> checkedInAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendancesCompanion(
                localDate: localDate,
                status: status,
                checkedInAt: checkedInAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String localDate,
                required String status,
                Value<DateTime?> checkedInAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendancesCompanion.insert(
                localDate: localDate,
                status: status,
                checkedInAt: checkedInAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AttendancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendancesTable,
      Attendance,
      $$AttendancesTableFilterComposer,
      $$AttendancesTableOrderingComposer,
      $$AttendancesTableAnnotationComposer,
      $$AttendancesTableCreateCompanionBuilder,
      $$AttendancesTableUpdateCompanionBuilder,
      (
        Attendance,
        BaseReferences<_$AppDatabase, $AttendancesTable, Attendance>,
      ),
      Attendance,
      PrefetchHooks Function()
    >;
typedef $$WorkoutsTableCreateCompanionBuilder =
    WorkoutsCompanion Function({
      required String id,
      Value<String?> attendanceDate,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required String status,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$WorkoutsTableUpdateCompanionBuilder =
    WorkoutsCompanion Function({
      Value<String> id,
      Value<String?> attendanceDate,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<String> status,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$WorkoutsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutsTable, Workout> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExercise>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'workouts__id__workout_exercises__workout_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attendanceDate => $composableBuilder(
    column: $table.attendanceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attendanceDate => $composableBuilder(
    column: $table.attendanceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get attendanceDate => $composableBuilder(
    column: $table.attendanceDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutsTable,
          Workout,
          $$WorkoutsTableFilterComposer,
          $$WorkoutsTableOrderingComposer,
          $$WorkoutsTableAnnotationComposer,
          $$WorkoutsTableCreateCompanionBuilder,
          $$WorkoutsTableUpdateCompanionBuilder,
          (Workout, $$WorkoutsTableReferences),
          Workout,
          PrefetchHooks Function({bool workoutExercisesRefs})
        > {
  $$WorkoutsTableTableManager(_$AppDatabase db, $WorkoutsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> attendanceDate = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion(
                id: id,
                attendanceDate: attendanceDate,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> attendanceDate = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required String status,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutsCompanion.insert(
                id: id,
                attendanceDate: attendanceDate,
                startedAt: startedAt,
                endedAt: endedAt,
                status: status,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutExercisesRefs) db.workoutExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutExercisesRefs)
                    await $_getPrefetchedData<
                      Workout,
                      $WorkoutsTable,
                      WorkoutExercise
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutsTableReferences
                          ._workoutExercisesRefsTable(db),
                      managerFromTypedResult: (p0) => $$WorkoutsTableReferences(
                        db,
                        table,
                        p0,
                      ).workoutExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.workoutId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutsTable,
      Workout,
      $$WorkoutsTableFilterComposer,
      $$WorkoutsTableOrderingComposer,
      $$WorkoutsTableAnnotationComposer,
      $$WorkoutsTableCreateCompanionBuilder,
      $$WorkoutsTableUpdateCompanionBuilder,
      (Workout, $$WorkoutsTableReferences),
      Workout,
      PrefetchHooks Function({bool workoutExercisesRefs})
    >;
typedef $$ExerciseDefinitionsTableCreateCompanionBuilder =
    ExerciseDefinitionsCompanion Function({
      required String id,
      required String name,
      required String category,
      Value<bool> isCustom,
      Value<bool> isFavorite,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ExerciseDefinitionsTableUpdateCompanionBuilder =
    ExerciseDefinitionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<bool> isCustom,
      Value<bool> isFavorite,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ExerciseDefinitionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExerciseDefinitionsTable,
          ExerciseDefinition
        > {
  $$ExerciseDefinitionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$WorkoutExercisesTable, List<WorkoutExercise>>
  _workoutExercisesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutExercises,
    aliasName: 'exercise_definitions__id__workout_exercises__exercise_id',
  );

  $$WorkoutExercisesTableProcessedTableManager get workoutExercisesRefs {
    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $WorkoutTemplateExercisesTable,
    List<WorkoutTemplateExercise>
  >
  _workoutTemplateExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutTemplateExercises,
        aliasName:
            'exercise_definitions__id__workout_template_exercises__exercise_id',
      );

  $$WorkoutTemplateExercisesTableProcessedTableManager
  get workoutTemplateExercisesRefs {
    final manager = $$WorkoutTemplateExercisesTableTableManager(
      $_db,
      $_db.workoutTemplateExercises,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutTemplateExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExerciseDefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseDefinitionsTable> {
  $$ExerciseDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutExercisesRefs(
    Expression<bool> Function($$WorkoutExercisesTableFilterComposer f) f,
  ) {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutTemplateExercisesRefs(
    Expression<bool> Function($$WorkoutTemplateExercisesTableFilterComposer f)
    f,
  ) {
    final $$WorkoutTemplateExercisesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutTemplateExercises,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplateExercisesTableFilterComposer(
                $db: $db,
                $table: $db.workoutTemplateExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExerciseDefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseDefinitionsTable> {
  $$ExerciseDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseDefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseDefinitionsTable> {
  $$ExerciseDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> workoutExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutExercisesTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> workoutTemplateExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutTemplateExercisesTableAnnotationComposer a)
    f,
  ) {
    final $$WorkoutTemplateExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutTemplateExercises,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplateExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutTemplateExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExerciseDefinitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseDefinitionsTable,
          ExerciseDefinition,
          $$ExerciseDefinitionsTableFilterComposer,
          $$ExerciseDefinitionsTableOrderingComposer,
          $$ExerciseDefinitionsTableAnnotationComposer,
          $$ExerciseDefinitionsTableCreateCompanionBuilder,
          $$ExerciseDefinitionsTableUpdateCompanionBuilder,
          (ExerciseDefinition, $$ExerciseDefinitionsTableReferences),
          ExerciseDefinition,
          PrefetchHooks Function({
            bool workoutExercisesRefs,
            bool workoutTemplateExercisesRefs,
          })
        > {
  $$ExerciseDefinitionsTableTableManager(
    _$AppDatabase db,
    $ExerciseDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseDefinitionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseDefinitionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ExerciseDefinitionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseDefinitionsCompanion(
                id: id,
                name: name,
                category: category,
                isCustom: isCustom,
                isFavorite: isFavorite,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                Value<bool> isCustom = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExerciseDefinitionsCompanion.insert(
                id: id,
                name: name,
                category: category,
                isCustom: isCustom,
                isFavorite: isFavorite,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExerciseDefinitionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutExercisesRefs = false,
                workoutTemplateExercisesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutExercisesRefs) db.workoutExercises,
                    if (workoutTemplateExercisesRefs)
                      db.workoutTemplateExercises,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutExercisesRefs)
                        await $_getPrefetchedData<
                          ExerciseDefinition,
                          $ExerciseDefinitionsTable,
                          WorkoutExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExerciseDefinitionsTableReferences
                              ._workoutExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExerciseDefinitionsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (workoutTemplateExercisesRefs)
                        await $_getPrefetchedData<
                          ExerciseDefinition,
                          $ExerciseDefinitionsTable,
                          WorkoutTemplateExercise
                        >(
                          currentTable: table,
                          referencedTable: $$ExerciseDefinitionsTableReferences
                              ._workoutTemplateExercisesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExerciseDefinitionsTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutTemplateExercisesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.exerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExerciseDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseDefinitionsTable,
      ExerciseDefinition,
      $$ExerciseDefinitionsTableFilterComposer,
      $$ExerciseDefinitionsTableOrderingComposer,
      $$ExerciseDefinitionsTableAnnotationComposer,
      $$ExerciseDefinitionsTableCreateCompanionBuilder,
      $$ExerciseDefinitionsTableUpdateCompanionBuilder,
      (ExerciseDefinition, $$ExerciseDefinitionsTableReferences),
      ExerciseDefinition,
      PrefetchHooks Function({
        bool workoutExercisesRefs,
        bool workoutTemplateExercisesRefs,
      })
    >;
typedef $$WorkoutExercisesTableCreateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      required String id,
      required String workoutId,
      required String exerciseId,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$WorkoutExercisesTableUpdateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<String> id,
      Value<String> workoutId,
      Value<String> exerciseId,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$WorkoutExercisesTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutExercisesTable, WorkoutExercise> {
  $$WorkoutExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutsTable _workoutIdTable(_$AppDatabase db) =>
      db.workouts.createAlias('workout_exercises__workout_id__workouts__id');

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableManager(
      $_db,
      $_db.workouts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExerciseDefinitionsTable _exerciseIdTable(_$AppDatabase db) => db
      .exerciseDefinitions
      .createAlias('workout_exercises__exercise_id__exercise_definitions__id');

  $$ExerciseDefinitionsTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExerciseDefinitionsTableTableManager(
      $_db,
      $_db.exerciseDefinitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetsTable, List<WorkoutSet>>
  _workoutSetsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSets,
    aliasName: 'workout_exercises__id__workout_sets__workout_exercise_id',
  );

  $$WorkoutSetsTableProcessedTableManager get workoutSetsRefs {
    final manager = $$WorkoutSetsTableTableManager($_db, $_db.workoutSets)
        .filter(
          (f) => f.workoutExerciseId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_workoutSetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableFilterComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciseDefinitionsTableFilterComposer get exerciseId {
    final $$ExerciseDefinitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exerciseDefinitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseDefinitionsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseDefinitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetsRefs(
    Expression<bool> Function($$WorkoutSetsTableFilterComposer f) f,
  ) {
    final $$WorkoutSetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableFilterComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableOrderingComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciseDefinitionsTableOrderingComposer get exerciseId {
    final $$ExerciseDefinitionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseId,
          referencedTable: $db.exerciseDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseDefinitionsTableOrderingComposer(
                $db: $db,
                $table: $db.exerciseDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workouts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutsTableAnnotationComposer(
            $db: $db,
            $table: $db.workouts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciseDefinitionsTableAnnotationComposer get exerciseId {
    final $$ExerciseDefinitionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseId,
          referencedTable: $db.exerciseDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseDefinitionsTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> workoutSetsRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetsTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSets,
      getReferencedColumn: (t) => t.workoutExerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetsTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExercise,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (WorkoutExercise, $$WorkoutExercisesTableReferences),
          WorkoutExercise,
          PrefetchHooks Function({
            bool workoutId,
            bool exerciseId,
            bool workoutSetsRefs,
          })
        > {
  $$WorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutId,
                required String exerciseId,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion.insert(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                workoutId = false,
                exerciseId = false,
                workoutSetsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (workoutSetsRefs) db.workoutSets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (workoutId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.workoutId,
                                    referencedTable:
                                        $$WorkoutExercisesTableReferences
                                            ._workoutIdTable(db),
                                    referencedColumn:
                                        $$WorkoutExercisesTableReferences
                                            ._workoutIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (exerciseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.exerciseId,
                                    referencedTable:
                                        $$WorkoutExercisesTableReferences
                                            ._exerciseIdTable(db),
                                    referencedColumn:
                                        $$WorkoutExercisesTableReferences
                                            ._exerciseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (workoutSetsRefs)
                        await $_getPrefetchedData<
                          WorkoutExercise,
                          $WorkoutExercisesTable,
                          WorkoutSet
                        >(
                          currentTable: table,
                          referencedTable: $$WorkoutExercisesTableReferences
                              ._workoutSetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorkoutExercisesTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.workoutExerciseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTable,
      WorkoutExercise,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (WorkoutExercise, $$WorkoutExercisesTableReferences),
      WorkoutExercise,
      PrefetchHooks Function({
        bool workoutId,
        bool exerciseId,
        bool workoutSetsRefs,
      })
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      required String id,
      required String workoutExerciseId,
      required int sortOrder,
      Value<String> setType,
      Value<double?> weightKg,
      Value<int?> reps,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<int?> estimatedCalories,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> id,
      Value<String> workoutExerciseId,
      Value<int> sortOrder,
      Value<String> setType,
      Value<double?> weightKg,
      Value<int?> reps,
      Value<int?> durationSeconds,
      Value<double?> distanceMeters,
      Value<int?> estimatedCalories,
      Value<DateTime?> completedAt,
      Value<int> rowid,
    });

final class $$WorkoutSetsTableReferences
    extends BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet> {
  $$WorkoutSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutExercisesTable _workoutExerciseIdTable(_$AppDatabase db) => db
      .workoutExercises
      .createAlias('workout_sets__workout_exercise_id__workout_exercises__id');

  $$WorkoutExercisesTableProcessedTableManager get workoutExerciseId {
    final $_column = $_itemColumn<String>('workout_exercise_id')!;

    final manager = $$WorkoutExercisesTableTableManager(
      $_db,
      $_db.workoutExercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutExerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedCalories => $composableBuilder(
    column: $table.estimatedCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutExercisesTableFilterComposer get workoutExerciseId {
    final $$WorkoutExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableFilterComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get setType => $composableBuilder(
    column: $table.setType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedCalories => $composableBuilder(
    column: $table.estimatedCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutExercisesTableOrderingComposer get workoutExerciseId {
    final $$WorkoutExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedCalories => $composableBuilder(
    column: $table.estimatedCalories,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  $$WorkoutExercisesTableAnnotationComposer get workoutExerciseId {
    final $$WorkoutExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutExerciseId,
      referencedTable: $db.workoutExercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutExercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (WorkoutSet, $$WorkoutSetsTableReferences),
          WorkoutSet,
          PrefetchHooks Function({bool workoutExerciseId})
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workoutExerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> setType = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<int?> estimatedCalories = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                workoutExerciseId: workoutExerciseId,
                sortOrder: sortOrder,
                setType: setType,
                weightKg: weightKg,
                reps: reps,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                estimatedCalories: estimatedCalories,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workoutExerciseId,
                required int sortOrder,
                Value<String> setType = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<double?> distanceMeters = const Value.absent(),
                Value<int?> estimatedCalories = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                workoutExerciseId: workoutExerciseId,
                sortOrder: sortOrder,
                setType: setType,
                weightKg: weightKg,
                reps: reps,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                estimatedCalories: estimatedCalories,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutSetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutExerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (workoutExerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.workoutExerciseId,
                                referencedTable: $$WorkoutSetsTableReferences
                                    ._workoutExerciseIdTable(db),
                                referencedColumn: $$WorkoutSetsTableReferences
                                    ._workoutExerciseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (WorkoutSet, $$WorkoutSetsTableReferences),
      WorkoutSet,
      PrefetchHooks Function({bool workoutExerciseId})
    >;
typedef $$AchievementAwardsTableCreateCompanionBuilder =
    AchievementAwardsCompanion Function({
      required String achievementId,
      Value<DateTime> awardedAt,
      Value<int> rowid,
    });
typedef $$AchievementAwardsTableUpdateCompanionBuilder =
    AchievementAwardsCompanion Function({
      Value<String> achievementId,
      Value<DateTime> awardedAt,
      Value<int> rowid,
    });

class $$AchievementAwardsTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementAwardsTable> {
  $$AchievementAwardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get awardedAt => $composableBuilder(
    column: $table.awardedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementAwardsTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementAwardsTable> {
  $$AchievementAwardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get awardedAt => $composableBuilder(
    column: $table.awardedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementAwardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementAwardsTable> {
  $$AchievementAwardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get awardedAt =>
      $composableBuilder(column: $table.awardedAt, builder: (column) => column);
}

class $$AchievementAwardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementAwardsTable,
          AchievementAward,
          $$AchievementAwardsTableFilterComposer,
          $$AchievementAwardsTableOrderingComposer,
          $$AchievementAwardsTableAnnotationComposer,
          $$AchievementAwardsTableCreateCompanionBuilder,
          $$AchievementAwardsTableUpdateCompanionBuilder,
          (
            AchievementAward,
            BaseReferences<
              _$AppDatabase,
              $AchievementAwardsTable,
              AchievementAward
            >,
          ),
          AchievementAward,
          PrefetchHooks Function()
        > {
  $$AchievementAwardsTableTableManager(
    _$AppDatabase db,
    $AchievementAwardsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementAwardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementAwardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementAwardsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> achievementId = const Value.absent(),
                Value<DateTime> awardedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementAwardsCompanion(
                achievementId: achievementId,
                awardedAt: awardedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String achievementId,
                Value<DateTime> awardedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementAwardsCompanion.insert(
                achievementId: achievementId,
                awardedAt: awardedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementAwardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementAwardsTable,
      AchievementAward,
      $$AchievementAwardsTableFilterComposer,
      $$AchievementAwardsTableOrderingComposer,
      $$AchievementAwardsTableAnnotationComposer,
      $$AchievementAwardsTableCreateCompanionBuilder,
      $$AchievementAwardsTableUpdateCompanionBuilder,
      (
        AchievementAward,
        BaseReferences<
          _$AppDatabase,
          $AchievementAwardsTable,
          AchievementAward
        >,
      ),
      AchievementAward,
      PrefetchHooks Function()
    >;
typedef $$XpEventsTableCreateCompanionBuilder =
    XpEventsCompanion Function({
      required String id,
      required String awardKey,
      required String sourceType,
      required int amount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$XpEventsTableUpdateCompanionBuilder =
    XpEventsCompanion Function({
      Value<String> id,
      Value<String> awardKey,
      Value<String> sourceType,
      Value<int> amount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$XpEventsTableFilterComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get awardKey => $composableBuilder(
    column: $table.awardKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$XpEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get awardKey => $composableBuilder(
    column: $table.awardKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$XpEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $XpEventsTable> {
  $$XpEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get awardKey =>
      $composableBuilder(column: $table.awardKey, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$XpEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $XpEventsTable,
          XpEvent,
          $$XpEventsTableFilterComposer,
          $$XpEventsTableOrderingComposer,
          $$XpEventsTableAnnotationComposer,
          $$XpEventsTableCreateCompanionBuilder,
          $$XpEventsTableUpdateCompanionBuilder,
          (XpEvent, BaseReferences<_$AppDatabase, $XpEventsTable, XpEvent>),
          XpEvent,
          PrefetchHooks Function()
        > {
  $$XpEventsTableTableManager(_$AppDatabase db, $XpEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$XpEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$XpEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$XpEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> awardKey = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => XpEventsCompanion(
                id: id,
                awardKey: awardKey,
                sourceType: sourceType,
                amount: amount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String awardKey,
                required String sourceType,
                required int amount,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => XpEventsCompanion.insert(
                id: id,
                awardKey: awardKey,
                sourceType: sourceType,
                amount: amount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$XpEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $XpEventsTable,
      XpEvent,
      $$XpEventsTableFilterComposer,
      $$XpEventsTableOrderingComposer,
      $$XpEventsTableAnnotationComposer,
      $$XpEventsTableCreateCompanionBuilder,
      $$XpEventsTableUpdateCompanionBuilder,
      (XpEvent, BaseReferences<_$AppDatabase, $XpEventsTable, XpEvent>),
      XpEvent,
      PrefetchHooks Function()
    >;
typedef $$NotificationScheduleLogsTableCreateCompanionBuilder =
    NotificationScheduleLogsCompanion Function({
      Value<int> notificationId,
      required String localDate,
      required int offsetMinutes,
      required DateTime scheduledFor,
      required String state,
      Value<DateTime> updatedAt,
    });
typedef $$NotificationScheduleLogsTableUpdateCompanionBuilder =
    NotificationScheduleLogsCompanion Function({
      Value<int> notificationId,
      Value<String> localDate,
      Value<int> offsetMinutes,
      Value<DateTime> scheduledFor,
      Value<String> state,
      Value<DateTime> updatedAt,
    });

class $$NotificationScheduleLogsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationScheduleLogsTable> {
  $$NotificationScheduleLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationScheduleLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationScheduleLogsTable> {
  $$NotificationScheduleLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDate => $composableBuilder(
    column: $table.localDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationScheduleLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationScheduleLogsTable> {
  $$NotificationScheduleLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledFor => $composableBuilder(
    column: $table.scheduledFor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotificationScheduleLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationScheduleLogsTable,
          NotificationScheduleLog,
          $$NotificationScheduleLogsTableFilterComposer,
          $$NotificationScheduleLogsTableOrderingComposer,
          $$NotificationScheduleLogsTableAnnotationComposer,
          $$NotificationScheduleLogsTableCreateCompanionBuilder,
          $$NotificationScheduleLogsTableUpdateCompanionBuilder,
          (
            NotificationScheduleLog,
            BaseReferences<
              _$AppDatabase,
              $NotificationScheduleLogsTable,
              NotificationScheduleLog
            >,
          ),
          NotificationScheduleLog,
          PrefetchHooks Function()
        > {
  $$NotificationScheduleLogsTableTableManager(
    _$AppDatabase db,
    $NotificationScheduleLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationScheduleLogsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationScheduleLogsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationScheduleLogsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> notificationId = const Value.absent(),
                Value<String> localDate = const Value.absent(),
                Value<int> offsetMinutes = const Value.absent(),
                Value<DateTime> scheduledFor = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotificationScheduleLogsCompanion(
                notificationId: notificationId,
                localDate: localDate,
                offsetMinutes: offsetMinutes,
                scheduledFor: scheduledFor,
                state: state,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> notificationId = const Value.absent(),
                required String localDate,
                required int offsetMinutes,
                required DateTime scheduledFor,
                required String state,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => NotificationScheduleLogsCompanion.insert(
                notificationId: notificationId,
                localDate: localDate,
                offsetMinutes: offsetMinutes,
                scheduledFor: scheduledFor,
                state: state,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationScheduleLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationScheduleLogsTable,
      NotificationScheduleLog,
      $$NotificationScheduleLogsTableFilterComposer,
      $$NotificationScheduleLogsTableOrderingComposer,
      $$NotificationScheduleLogsTableAnnotationComposer,
      $$NotificationScheduleLogsTableCreateCompanionBuilder,
      $$NotificationScheduleLogsTableUpdateCompanionBuilder,
      (
        NotificationScheduleLog,
        BaseReferences<
          _$AppDatabase,
          $NotificationScheduleLogsTable,
          NotificationScheduleLog
        >,
      ),
      NotificationScheduleLog,
      PrefetchHooks Function()
    >;
typedef $$WorkoutTemplatesTableCreateCompanionBuilder =
    WorkoutTemplatesCompanion Function({
      required String id,
      required String name,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$WorkoutTemplatesTableUpdateCompanionBuilder =
    WorkoutTemplatesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$WorkoutTemplatesTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutTemplatesTable, WorkoutTemplate> {
  $$WorkoutTemplatesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $WorkoutTemplateExercisesTable,
    List<WorkoutTemplateExercise>
  >
  _workoutTemplateExercisesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutTemplateExercises,
        aliasName:
            'workout_templates__id__workout_template_exercises__template_id',
      );

  $$WorkoutTemplateExercisesTableProcessedTableManager
  get workoutTemplateExercisesRefs {
    final manager = $$WorkoutTemplateExercisesTableTableManager(
      $_db,
      $_db.workoutTemplateExercises,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutTemplateExercisesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutTemplateExercisesRefs(
    Expression<bool> Function($$WorkoutTemplateExercisesTableFilterComposer f)
    f,
  ) {
    final $$WorkoutTemplateExercisesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutTemplateExercises,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplateExercisesTableFilterComposer(
                $db: $db,
                $table: $db.workoutTemplateExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTemplatesTable> {
  $$WorkoutTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> workoutTemplateExercisesRefs<T extends Object>(
    Expression<T> Function($$WorkoutTemplateExercisesTableAnnotationComposer a)
    f,
  ) {
    final $$WorkoutTemplateExercisesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutTemplateExercises,
          getReferencedColumn: (t) => t.templateId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutTemplateExercisesTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutTemplateExercises,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutTemplatesTable,
          WorkoutTemplate,
          $$WorkoutTemplatesTableFilterComposer,
          $$WorkoutTemplatesTableOrderingComposer,
          $$WorkoutTemplatesTableAnnotationComposer,
          $$WorkoutTemplatesTableCreateCompanionBuilder,
          $$WorkoutTemplatesTableUpdateCompanionBuilder,
          (WorkoutTemplate, $$WorkoutTemplatesTableReferences),
          WorkoutTemplate,
          PrefetchHooks Function({bool workoutTemplateExercisesRefs})
        > {
  $$WorkoutTemplatesTableTableManager(
    _$AppDatabase db,
    $WorkoutTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplatesCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplatesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutTemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({workoutTemplateExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutTemplateExercisesRefs) db.workoutTemplateExercises,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutTemplateExercisesRefs)
                    await $_getPrefetchedData<
                      WorkoutTemplate,
                      $WorkoutTemplatesTable,
                      WorkoutTemplateExercise
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutTemplatesTableReferences
                          ._workoutTemplateExercisesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WorkoutTemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).workoutTemplateExercisesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutTemplatesTable,
      WorkoutTemplate,
      $$WorkoutTemplatesTableFilterComposer,
      $$WorkoutTemplatesTableOrderingComposer,
      $$WorkoutTemplatesTableAnnotationComposer,
      $$WorkoutTemplatesTableCreateCompanionBuilder,
      $$WorkoutTemplatesTableUpdateCompanionBuilder,
      (WorkoutTemplate, $$WorkoutTemplatesTableReferences),
      WorkoutTemplate,
      PrefetchHooks Function({bool workoutTemplateExercisesRefs})
    >;
typedef $$WorkoutTemplateExercisesTableCreateCompanionBuilder =
    WorkoutTemplateExercisesCompanion Function({
      required String id,
      required String templateId,
      required String exerciseId,
      required int sortOrder,
      Value<int> rowid,
    });
typedef $$WorkoutTemplateExercisesTableUpdateCompanionBuilder =
    WorkoutTemplateExercisesCompanion Function({
      Value<String> id,
      Value<String> templateId,
      Value<String> exerciseId,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$WorkoutTemplateExercisesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutTemplateExercisesTable,
          WorkoutTemplateExercise
        > {
  $$WorkoutTemplateExercisesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutTemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.workoutTemplates.createAlias(
        'workout_template_exercises__template_id__workout_templates__id',
      );

  $$WorkoutTemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<String>('template_id')!;

    final manager = $$WorkoutTemplatesTableTableManager(
      $_db,
      $_db.workoutTemplates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExerciseDefinitionsTable _exerciseIdTable(_$AppDatabase db) =>
      db.exerciseDefinitions.createAlias(
        'workout_template_exercises__exercise_id__exercise_definitions__id',
      );

  $$ExerciseDefinitionsTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExerciseDefinitionsTableTableManager(
      $_db,
      $_db.exerciseDefinitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutTemplateExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTemplateExercisesTable> {
  $$WorkoutTemplateExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutTemplatesTableFilterComposer get templateId {
    final $$WorkoutTemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableFilterComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciseDefinitionsTableFilterComposer get exerciseId {
    final $$ExerciseDefinitionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exerciseDefinitions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseDefinitionsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseDefinitions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutTemplateExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTemplateExercisesTable> {
  $$WorkoutTemplateExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutTemplatesTableOrderingComposer get templateId {
    final $$WorkoutTemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciseDefinitionsTableOrderingComposer get exerciseId {
    final $$ExerciseDefinitionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseId,
          referencedTable: $db.exerciseDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseDefinitionsTableOrderingComposer(
                $db: $db,
                $table: $db.exerciseDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutTemplateExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTemplateExercisesTable> {
  $$WorkoutTemplateExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$WorkoutTemplatesTableAnnotationComposer get templateId {
    final $$WorkoutTemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.workoutTemplates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutTemplates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciseDefinitionsTableAnnotationComposer get exerciseId {
    final $$ExerciseDefinitionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseId,
          referencedTable: $db.exerciseDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExerciseDefinitionsTableAnnotationComposer(
                $db: $db,
                $table: $db.exerciseDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutTemplateExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutTemplateExercisesTable,
          WorkoutTemplateExercise,
          $$WorkoutTemplateExercisesTableFilterComposer,
          $$WorkoutTemplateExercisesTableOrderingComposer,
          $$WorkoutTemplateExercisesTableAnnotationComposer,
          $$WorkoutTemplateExercisesTableCreateCompanionBuilder,
          $$WorkoutTemplateExercisesTableUpdateCompanionBuilder,
          (WorkoutTemplateExercise, $$WorkoutTemplateExercisesTableReferences),
          WorkoutTemplateExercise,
          PrefetchHooks Function({bool templateId, bool exerciseId})
        > {
  $$WorkoutTemplateExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutTemplateExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutTemplateExercisesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WorkoutTemplateExercisesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WorkoutTemplateExercisesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplateExercisesCompanion(
                id: id,
                templateId: templateId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String templateId,
                required String exerciseId,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutTemplateExercisesCompanion.insert(
                id: id,
                templateId: templateId,
                exerciseId: exerciseId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WorkoutTemplateExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false, exerciseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (templateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateId,
                                referencedTable:
                                    $$WorkoutTemplateExercisesTableReferences
                                        ._templateIdTable(db),
                                referencedColumn:
                                    $$WorkoutTemplateExercisesTableReferences
                                        ._templateIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable:
                                    $$WorkoutTemplateExercisesTableReferences
                                        ._exerciseIdTable(db),
                                referencedColumn:
                                    $$WorkoutTemplateExercisesTableReferences
                                        ._exerciseIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutTemplateExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutTemplateExercisesTable,
      WorkoutTemplateExercise,
      $$WorkoutTemplateExercisesTableFilterComposer,
      $$WorkoutTemplateExercisesTableOrderingComposer,
      $$WorkoutTemplateExercisesTableAnnotationComposer,
      $$WorkoutTemplateExercisesTableCreateCompanionBuilder,
      $$WorkoutTemplateExercisesTableUpdateCompanionBuilder,
      (WorkoutTemplateExercise, $$WorkoutTemplateExercisesTableReferences),
      WorkoutTemplateExercise,
      PrefetchHooks Function({bool templateId, bool exerciseId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
  $$GymSchedulesTableTableManager get gymSchedules =>
      $$GymSchedulesTableTableManager(_db, _db.gymSchedules);
  $$ReminderOffsetsTableTableManager get reminderOffsets =>
      $$ReminderOffsetsTableTableManager(_db, _db.reminderOffsets);
  $$AttendancesTableTableManager get attendances =>
      $$AttendancesTableTableManager(_db, _db.attendances);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$ExerciseDefinitionsTableTableManager get exerciseDefinitions =>
      $$ExerciseDefinitionsTableTableManager(_db, _db.exerciseDefinitions);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(_db, _db.workoutExercises);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$AchievementAwardsTableTableManager get achievementAwards =>
      $$AchievementAwardsTableTableManager(_db, _db.achievementAwards);
  $$XpEventsTableTableManager get xpEvents =>
      $$XpEventsTableTableManager(_db, _db.xpEvents);
  $$NotificationScheduleLogsTableTableManager get notificationScheduleLogs =>
      $$NotificationScheduleLogsTableTableManager(
        _db,
        _db.notificationScheduleLogs,
      );
  $$WorkoutTemplatesTableTableManager get workoutTemplates =>
      $$WorkoutTemplatesTableTableManager(_db, _db.workoutTemplates);
  $$WorkoutTemplateExercisesTableTableManager get workoutTemplateExercises =>
      $$WorkoutTemplateExercisesTableTableManager(
        _db,
        _db.workoutTemplateExercises,
      );
}
