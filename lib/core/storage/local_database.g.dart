// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $AuthSessionsTable extends AuthSessions
    with TableInfo<$AuthSessionsTable, AuthSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAuthenticatedMeta = const VerificationMeta(
    'isAuthenticated',
  );
  @override
  late final GeneratedColumn<bool> isAuthenticated = GeneratedColumn<bool>(
    'is_authenticated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_authenticated" IN (0, 1))',
    ),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, isAuthenticated, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_authenticated')) {
      context.handle(
        _isAuthenticatedMeta,
        isAuthenticated.isAcceptableOrUnknown(
          data['is_authenticated']!,
          _isAuthenticatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isAuthenticatedMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      isAuthenticated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_authenticated'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AuthSessionsTable createAlias(String alias) {
    return $AuthSessionsTable(attachedDatabase, alias);
  }
}

class AuthSession extends DataClass implements Insertable<AuthSession> {
  final int id;
  final bool isAuthenticated;
  final DateTime updatedAt;
  const AuthSession({
    required this.id,
    required this.isAuthenticated,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_authenticated'] = Variable<bool>(isAuthenticated);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AuthSessionsCompanion toCompanion(bool nullToAbsent) {
    return AuthSessionsCompanion(
      id: Value(id),
      isAuthenticated: Value(isAuthenticated),
      updatedAt: Value(updatedAt),
    );
  }

  factory AuthSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthSession(
      id: serializer.fromJson<int>(json['id']),
      isAuthenticated: serializer.fromJson<bool>(json['isAuthenticated']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isAuthenticated': serializer.toJson<bool>(isAuthenticated),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AuthSession copyWith({int? id, bool? isAuthenticated, DateTime? updatedAt}) =>
      AuthSession(
        id: id ?? this.id,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AuthSession copyWithCompanion(AuthSessionsCompanion data) {
    return AuthSession(
      id: data.id.present ? data.id.value : this.id,
      isAuthenticated: data.isAuthenticated.present
          ? data.isAuthenticated.value
          : this.isAuthenticated,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthSession(')
          ..write('id: $id, ')
          ..write('isAuthenticated: $isAuthenticated, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, isAuthenticated, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthSession &&
          other.id == this.id &&
          other.isAuthenticated == this.isAuthenticated &&
          other.updatedAt == this.updatedAt);
}

class AuthSessionsCompanion extends UpdateCompanion<AuthSession> {
  final Value<int> id;
  final Value<bool> isAuthenticated;
  final Value<DateTime> updatedAt;
  const AuthSessionsCompanion({
    this.id = const Value.absent(),
    this.isAuthenticated = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AuthSessionsCompanion.insert({
    this.id = const Value.absent(),
    required bool isAuthenticated,
    required DateTime updatedAt,
  }) : isAuthenticated = Value(isAuthenticated),
       updatedAt = Value(updatedAt);
  static Insertable<AuthSession> custom({
    Expression<int>? id,
    Expression<bool>? isAuthenticated,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isAuthenticated != null) 'is_authenticated': isAuthenticated,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AuthSessionsCompanion copyWith({
    Value<int>? id,
    Value<bool>? isAuthenticated,
    Value<DateTime>? updatedAt,
  }) {
    return AuthSessionsCompanion(
      id: id ?? this.id,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isAuthenticated.present) {
      map['is_authenticated'] = Variable<bool>(isAuthenticated.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthSessionsCompanion(')
          ..write('id: $id, ')
          ..write('isAuthenticated: $isAuthenticated, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredDisciplineMeta =
      const VerificationMeta('preferredDiscipline');
  @override
  late final GeneratedColumn<String> preferredDiscipline =
      GeneratedColumn<String>(
        'preferred_discipline',
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
    email,
    displayName,
    preferredDiscipline,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('preferred_discipline')) {
      context.handle(
        _preferredDisciplineMeta,
        preferredDiscipline.isAcceptableOrUnknown(
          data['preferred_discipline']!,
          _preferredDisciplineMeta,
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      preferredDiscipline: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_discipline'],
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
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String? email;
  final String? displayName;
  final String? preferredDiscipline;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({
    required this.id,
    this.email,
    this.displayName,
    this.preferredDiscipline,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || preferredDiscipline != null) {
      map['preferred_discipline'] = Variable<String>(preferredDiscipline);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      preferredDiscipline: preferredDiscipline == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredDiscipline),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String?>(json['email']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      preferredDiscipline: serializer.fromJson<String?>(
        json['preferredDiscipline'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String?>(email),
      'displayName': serializer.toJson<String?>(displayName),
      'preferredDiscipline': serializer.toJson<String?>(preferredDiscipline),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith({
    int? id,
    Value<String?> email = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    Value<String?> preferredDiscipline = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    email: email.present ? email.value : this.email,
    displayName: displayName.present ? displayName.value : this.displayName,
    preferredDiscipline: preferredDiscipline.present
        ? preferredDiscipline.value
        : this.preferredDiscipline,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      preferredDiscipline: data.preferredDiscipline.present
          ? data.preferredDiscipline.value
          : this.preferredDiscipline,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('preferredDiscipline: $preferredDiscipline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    displayName,
    preferredDiscipline,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.preferredDiscipline == this.preferredDiscipline &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String?> email;
  final Value<String?> displayName;
  final Value<String?> preferredDiscipline;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.preferredDiscipline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.preferredDiscipline = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? preferredDiscipline,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (preferredDiscipline != null)
        'preferred_discipline': preferredDiscipline,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String?>? email,
    Value<String?>? displayName,
    Value<String?>? preferredDiscipline,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      preferredDiscipline: preferredDiscipline ?? this.preferredDiscipline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (preferredDiscipline.present) {
      map['preferred_discipline'] = Variable<String>(preferredDiscipline.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('preferredDiscipline: $preferredDiscipline, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WindAlertsTable extends WindAlerts
    with TableInfo<$WindAlertsTable, WindAlert> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WindAlertsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _minSpeedKnMeta = const VerificationMeta(
    'minSpeedKn',
  );
  @override
  late final GeneratedColumn<double> minSpeedKn = GeneratedColumn<double>(
    'min_speed_kn',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxSpeedKnMeta = const VerificationMeta(
    'maxSpeedKn',
  );
  @override
  late final GeneratedColumn<double> maxSpeedKn = GeneratedColumn<double>(
    'max_speed_kn',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMinDegMeta = const VerificationMeta(
    'directionMinDeg',
  );
  @override
  late final GeneratedColumn<int> directionMinDeg = GeneratedColumn<int>(
    'direction_min_deg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMaxDegMeta = const VerificationMeta(
    'directionMaxDeg',
  );
  @override
  late final GeneratedColumn<int> directionMaxDeg = GeneratedColumn<int>(
    'direction_max_deg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startHourMeta = const VerificationMeta(
    'startHour',
  );
  @override
  late final GeneratedColumn<int> startHour = GeneratedColumn<int>(
    'start_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endHourMeta = const VerificationMeta(
    'endHour',
  );
  @override
  late final GeneratedColumn<int> endHour = GeneratedColumn<int>(
    'end_hour',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    minSpeedKn,
    maxSpeedKn,
    directionMinDeg,
    directionMaxDeg,
    startHour,
    endHour,
    enabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wind_alerts';
  @override
  VerificationContext validateIntegrity(
    Insertable<WindAlert> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('min_speed_kn')) {
      context.handle(
        _minSpeedKnMeta,
        minSpeedKn.isAcceptableOrUnknown(
          data['min_speed_kn']!,
          _minSpeedKnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minSpeedKnMeta);
    }
    if (data.containsKey('max_speed_kn')) {
      context.handle(
        _maxSpeedKnMeta,
        maxSpeedKn.isAcceptableOrUnknown(
          data['max_speed_kn']!,
          _maxSpeedKnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxSpeedKnMeta);
    }
    if (data.containsKey('direction_min_deg')) {
      context.handle(
        _directionMinDegMeta,
        directionMinDeg.isAcceptableOrUnknown(
          data['direction_min_deg']!,
          _directionMinDegMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_directionMinDegMeta);
    }
    if (data.containsKey('direction_max_deg')) {
      context.handle(
        _directionMaxDegMeta,
        directionMaxDeg.isAcceptableOrUnknown(
          data['direction_max_deg']!,
          _directionMaxDegMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_directionMaxDegMeta);
    }
    if (data.containsKey('start_hour')) {
      context.handle(
        _startHourMeta,
        startHour.isAcceptableOrUnknown(data['start_hour']!, _startHourMeta),
      );
    } else if (isInserting) {
      context.missing(_startHourMeta);
    }
    if (data.containsKey('end_hour')) {
      context.handle(
        _endHourMeta,
        endHour.isAcceptableOrUnknown(data['end_hour']!, _endHourMeta),
      );
    } else if (isInserting) {
      context.missing(_endHourMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WindAlert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WindAlert(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      minSpeedKn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_speed_kn'],
      )!,
      maxSpeedKn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed_kn'],
      )!,
      directionMinDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}direction_min_deg'],
      )!,
      directionMaxDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}direction_max_deg'],
      )!,
      startHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_hour'],
      )!,
      endHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_hour'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
    );
  }

  @override
  $WindAlertsTable createAlias(String alias) {
    return $WindAlertsTable(attachedDatabase, alias);
  }
}

class WindAlert extends DataClass implements Insertable<WindAlert> {
  final int id;
  final int userId;
  final double minSpeedKn;
  final double maxSpeedKn;
  final int directionMinDeg;
  final int directionMaxDeg;
  final int startHour;
  final int endHour;
  final bool enabled;
  const WindAlert({
    required this.id,
    required this.userId,
    required this.minSpeedKn,
    required this.maxSpeedKn,
    required this.directionMinDeg,
    required this.directionMaxDeg,
    required this.startHour,
    required this.endHour,
    required this.enabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['min_speed_kn'] = Variable<double>(minSpeedKn);
    map['max_speed_kn'] = Variable<double>(maxSpeedKn);
    map['direction_min_deg'] = Variable<int>(directionMinDeg);
    map['direction_max_deg'] = Variable<int>(directionMaxDeg);
    map['start_hour'] = Variable<int>(startHour);
    map['end_hour'] = Variable<int>(endHour);
    map['enabled'] = Variable<bool>(enabled);
    return map;
  }

  WindAlertsCompanion toCompanion(bool nullToAbsent) {
    return WindAlertsCompanion(
      id: Value(id),
      userId: Value(userId),
      minSpeedKn: Value(minSpeedKn),
      maxSpeedKn: Value(maxSpeedKn),
      directionMinDeg: Value(directionMinDeg),
      directionMaxDeg: Value(directionMaxDeg),
      startHour: Value(startHour),
      endHour: Value(endHour),
      enabled: Value(enabled),
    );
  }

  factory WindAlert.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WindAlert(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      minSpeedKn: serializer.fromJson<double>(json['minSpeedKn']),
      maxSpeedKn: serializer.fromJson<double>(json['maxSpeedKn']),
      directionMinDeg: serializer.fromJson<int>(json['directionMinDeg']),
      directionMaxDeg: serializer.fromJson<int>(json['directionMaxDeg']),
      startHour: serializer.fromJson<int>(json['startHour']),
      endHour: serializer.fromJson<int>(json['endHour']),
      enabled: serializer.fromJson<bool>(json['enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'minSpeedKn': serializer.toJson<double>(minSpeedKn),
      'maxSpeedKn': serializer.toJson<double>(maxSpeedKn),
      'directionMinDeg': serializer.toJson<int>(directionMinDeg),
      'directionMaxDeg': serializer.toJson<int>(directionMaxDeg),
      'startHour': serializer.toJson<int>(startHour),
      'endHour': serializer.toJson<int>(endHour),
      'enabled': serializer.toJson<bool>(enabled),
    };
  }

  WindAlert copyWith({
    int? id,
    int? userId,
    double? minSpeedKn,
    double? maxSpeedKn,
    int? directionMinDeg,
    int? directionMaxDeg,
    int? startHour,
    int? endHour,
    bool? enabled,
  }) => WindAlert(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    minSpeedKn: minSpeedKn ?? this.minSpeedKn,
    maxSpeedKn: maxSpeedKn ?? this.maxSpeedKn,
    directionMinDeg: directionMinDeg ?? this.directionMinDeg,
    directionMaxDeg: directionMaxDeg ?? this.directionMaxDeg,
    startHour: startHour ?? this.startHour,
    endHour: endHour ?? this.endHour,
    enabled: enabled ?? this.enabled,
  );
  WindAlert copyWithCompanion(WindAlertsCompanion data) {
    return WindAlert(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      minSpeedKn: data.minSpeedKn.present
          ? data.minSpeedKn.value
          : this.minSpeedKn,
      maxSpeedKn: data.maxSpeedKn.present
          ? data.maxSpeedKn.value
          : this.maxSpeedKn,
      directionMinDeg: data.directionMinDeg.present
          ? data.directionMinDeg.value
          : this.directionMinDeg,
      directionMaxDeg: data.directionMaxDeg.present
          ? data.directionMaxDeg.value
          : this.directionMaxDeg,
      startHour: data.startHour.present ? data.startHour.value : this.startHour,
      endHour: data.endHour.present ? data.endHour.value : this.endHour,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WindAlert(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('minSpeedKn: $minSpeedKn, ')
          ..write('maxSpeedKn: $maxSpeedKn, ')
          ..write('directionMinDeg: $directionMinDeg, ')
          ..write('directionMaxDeg: $directionMaxDeg, ')
          ..write('startHour: $startHour, ')
          ..write('endHour: $endHour, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    minSpeedKn,
    maxSpeedKn,
    directionMinDeg,
    directionMaxDeg,
    startHour,
    endHour,
    enabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WindAlert &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.minSpeedKn == this.minSpeedKn &&
          other.maxSpeedKn == this.maxSpeedKn &&
          other.directionMinDeg == this.directionMinDeg &&
          other.directionMaxDeg == this.directionMaxDeg &&
          other.startHour == this.startHour &&
          other.endHour == this.endHour &&
          other.enabled == this.enabled);
}

class WindAlertsCompanion extends UpdateCompanion<WindAlert> {
  final Value<int> id;
  final Value<int> userId;
  final Value<double> minSpeedKn;
  final Value<double> maxSpeedKn;
  final Value<int> directionMinDeg;
  final Value<int> directionMaxDeg;
  final Value<int> startHour;
  final Value<int> endHour;
  final Value<bool> enabled;
  const WindAlertsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.minSpeedKn = const Value.absent(),
    this.maxSpeedKn = const Value.absent(),
    this.directionMinDeg = const Value.absent(),
    this.directionMaxDeg = const Value.absent(),
    this.startHour = const Value.absent(),
    this.endHour = const Value.absent(),
    this.enabled = const Value.absent(),
  });
  WindAlertsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required double minSpeedKn,
    required double maxSpeedKn,
    required int directionMinDeg,
    required int directionMaxDeg,
    required int startHour,
    required int endHour,
    this.enabled = const Value.absent(),
  }) : minSpeedKn = Value(minSpeedKn),
       maxSpeedKn = Value(maxSpeedKn),
       directionMinDeg = Value(directionMinDeg),
       directionMaxDeg = Value(directionMaxDeg),
       startHour = Value(startHour),
       endHour = Value(endHour);
  static Insertable<WindAlert> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<double>? minSpeedKn,
    Expression<double>? maxSpeedKn,
    Expression<int>? directionMinDeg,
    Expression<int>? directionMaxDeg,
    Expression<int>? startHour,
    Expression<int>? endHour,
    Expression<bool>? enabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (minSpeedKn != null) 'min_speed_kn': minSpeedKn,
      if (maxSpeedKn != null) 'max_speed_kn': maxSpeedKn,
      if (directionMinDeg != null) 'direction_min_deg': directionMinDeg,
      if (directionMaxDeg != null) 'direction_max_deg': directionMaxDeg,
      if (startHour != null) 'start_hour': startHour,
      if (endHour != null) 'end_hour': endHour,
      if (enabled != null) 'enabled': enabled,
    });
  }

  WindAlertsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<double>? minSpeedKn,
    Value<double>? maxSpeedKn,
    Value<int>? directionMinDeg,
    Value<int>? directionMaxDeg,
    Value<int>? startHour,
    Value<int>? endHour,
    Value<bool>? enabled,
  }) {
    return WindAlertsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      minSpeedKn: minSpeedKn ?? this.minSpeedKn,
      maxSpeedKn: maxSpeedKn ?? this.maxSpeedKn,
      directionMinDeg: directionMinDeg ?? this.directionMinDeg,
      directionMaxDeg: directionMaxDeg ?? this.directionMaxDeg,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (minSpeedKn.present) {
      map['min_speed_kn'] = Variable<double>(minSpeedKn.value);
    }
    if (maxSpeedKn.present) {
      map['max_speed_kn'] = Variable<double>(maxSpeedKn.value);
    }
    if (directionMinDeg.present) {
      map['direction_min_deg'] = Variable<int>(directionMinDeg.value);
    }
    if (directionMaxDeg.present) {
      map['direction_max_deg'] = Variable<int>(directionMaxDeg.value);
    }
    if (startHour.present) {
      map['start_hour'] = Variable<int>(startHour.value);
    }
    if (endHour.present) {
      map['end_hour'] = Variable<int>(endHour.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WindAlertsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('minSpeedKn: $minSpeedKn, ')
          ..write('maxSpeedKn: $maxSpeedKn, ')
          ..write('directionMinDeg: $directionMinDeg, ')
          ..write('directionMaxDeg: $directionMaxDeg, ')
          ..write('startHour: $startHour, ')
          ..write('endHour: $endHour, ')
          ..write('enabled: $enabled')
          ..write(')'))
        .toString();
  }
}

class $StationsTable extends Stations with TableInfo<$StationsTable, Station> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _provinceMeta = const VerificationMeta(
    'province',
  );
  @override
  late final GeneratedColumn<String> province = GeneratedColumn<String>(
    'province',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    province,
    latitude,
    longitude,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Station> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('province')) {
      context.handle(
        _provinceMeta,
        province.isAcceptableOrUnknown(data['province']!, _provinceMeta),
      );
    } else if (isInserting) {
      context.missing(_provinceMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Station map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Station(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      province: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}province'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
    );
  }

  @override
  $StationsTable createAlias(String alias) {
    return $StationsTable(attachedDatabase, alias);
  }
}

class Station extends DataClass implements Insertable<Station> {
  final int id;
  final String name;
  final String province;
  final double latitude;
  final double longitude;
  const Station({
    required this.id,
    required this.name,
    required this.province,
    required this.latitude,
    required this.longitude,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['province'] = Variable<String>(province);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    return map;
  }

  StationsCompanion toCompanion(bool nullToAbsent) {
    return StationsCompanion(
      id: Value(id),
      name: Value(name),
      province: Value(province),
      latitude: Value(latitude),
      longitude: Value(longitude),
    );
  }

  factory Station.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Station(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      province: serializer.fromJson<String>(json['province']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'province': serializer.toJson<String>(province),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
    };
  }

  Station copyWith({
    int? id,
    String? name,
    String? province,
    double? latitude,
    double? longitude,
  }) => Station(
    id: id ?? this.id,
    name: name ?? this.name,
    province: province ?? this.province,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
  );
  Station copyWithCompanion(StationsCompanion data) {
    return Station(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      province: data.province.present ? data.province.value : this.province,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Station(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('province: $province, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, province, latitude, longitude);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Station &&
          other.id == this.id &&
          other.name == this.name &&
          other.province == this.province &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude);
}

class StationsCompanion extends UpdateCompanion<Station> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> province;
  final Value<double> latitude;
  final Value<double> longitude;
  const StationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.province = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
  });
  StationsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String province,
    required double latitude,
    required double longitude,
  }) : name = Value(name),
       province = Value(province),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<Station> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? province,
    Expression<double>? latitude,
    Expression<double>? longitude,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (province != null) 'province': province,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    });
  }

  StationsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? province,
    Value<double>? latitude,
    Value<double>? longitude,
  }) {
    return StationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      province: province ?? this.province,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (province.present) {
      map['province'] = Variable<String>(province.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('province: $province, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude')
          ..write(')'))
        .toString();
  }
}

class $StationReadingsTable extends StationReadings
    with TableInfo<$StationReadingsTable, StationReading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StationReadingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _stationIdMeta = const VerificationMeta(
    'stationId',
  );
  @override
  late final GeneratedColumn<int> stationId = GeneratedColumn<int>(
    'station_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedKnMeta = const VerificationMeta(
    'speedKn',
  );
  @override
  late final GeneratedColumn<double> speedKn = GeneratedColumn<double>(
    'speed_kn',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gustKnMeta = const VerificationMeta('gustKn');
  @override
  late final GeneratedColumn<double> gustKn = GeneratedColumn<double>(
    'gust_kn',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionDegMeta = const VerificationMeta(
    'directionDeg',
  );
  @override
  late final GeneratedColumn<int> directionDeg = GeneratedColumn<int>(
    'direction_deg',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stationId,
    timestamp,
    speedKn,
    gustKn,
    directionDeg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'station_readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<StationReading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('station_id')) {
      context.handle(
        _stationIdMeta,
        stationId.isAcceptableOrUnknown(data['station_id']!, _stationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stationIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('speed_kn')) {
      context.handle(
        _speedKnMeta,
        speedKn.isAcceptableOrUnknown(data['speed_kn']!, _speedKnMeta),
      );
    } else if (isInserting) {
      context.missing(_speedKnMeta);
    }
    if (data.containsKey('gust_kn')) {
      context.handle(
        _gustKnMeta,
        gustKn.isAcceptableOrUnknown(data['gust_kn']!, _gustKnMeta),
      );
    } else if (isInserting) {
      context.missing(_gustKnMeta);
    }
    if (data.containsKey('direction_deg')) {
      context.handle(
        _directionDegMeta,
        directionDeg.isAcceptableOrUnknown(
          data['direction_deg']!,
          _directionDegMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_directionDegMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StationReading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StationReading(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      stationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}station_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      speedKn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_kn'],
      )!,
      gustKn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}gust_kn'],
      )!,
      directionDeg: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}direction_deg'],
      )!,
    );
  }

  @override
  $StationReadingsTable createAlias(String alias) {
    return $StationReadingsTable(attachedDatabase, alias);
  }
}

class StationReading extends DataClass implements Insertable<StationReading> {
  final int id;
  final int stationId;
  final DateTime timestamp;
  final double speedKn;
  final double gustKn;
  final int directionDeg;
  const StationReading({
    required this.id,
    required this.stationId,
    required this.timestamp,
    required this.speedKn,
    required this.gustKn,
    required this.directionDeg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['station_id'] = Variable<int>(stationId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['speed_kn'] = Variable<double>(speedKn);
    map['gust_kn'] = Variable<double>(gustKn);
    map['direction_deg'] = Variable<int>(directionDeg);
    return map;
  }

  StationReadingsCompanion toCompanion(bool nullToAbsent) {
    return StationReadingsCompanion(
      id: Value(id),
      stationId: Value(stationId),
      timestamp: Value(timestamp),
      speedKn: Value(speedKn),
      gustKn: Value(gustKn),
      directionDeg: Value(directionDeg),
    );
  }

  factory StationReading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StationReading(
      id: serializer.fromJson<int>(json['id']),
      stationId: serializer.fromJson<int>(json['stationId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      speedKn: serializer.fromJson<double>(json['speedKn']),
      gustKn: serializer.fromJson<double>(json['gustKn']),
      directionDeg: serializer.fromJson<int>(json['directionDeg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'stationId': serializer.toJson<int>(stationId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'speedKn': serializer.toJson<double>(speedKn),
      'gustKn': serializer.toJson<double>(gustKn),
      'directionDeg': serializer.toJson<int>(directionDeg),
    };
  }

  StationReading copyWith({
    int? id,
    int? stationId,
    DateTime? timestamp,
    double? speedKn,
    double? gustKn,
    int? directionDeg,
  }) => StationReading(
    id: id ?? this.id,
    stationId: stationId ?? this.stationId,
    timestamp: timestamp ?? this.timestamp,
    speedKn: speedKn ?? this.speedKn,
    gustKn: gustKn ?? this.gustKn,
    directionDeg: directionDeg ?? this.directionDeg,
  );
  StationReading copyWithCompanion(StationReadingsCompanion data) {
    return StationReading(
      id: data.id.present ? data.id.value : this.id,
      stationId: data.stationId.present ? data.stationId.value : this.stationId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      speedKn: data.speedKn.present ? data.speedKn.value : this.speedKn,
      gustKn: data.gustKn.present ? data.gustKn.value : this.gustKn,
      directionDeg: data.directionDeg.present
          ? data.directionDeg.value
          : this.directionDeg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StationReading(')
          ..write('id: $id, ')
          ..write('stationId: $stationId, ')
          ..write('timestamp: $timestamp, ')
          ..write('speedKn: $speedKn, ')
          ..write('gustKn: $gustKn, ')
          ..write('directionDeg: $directionDeg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, stationId, timestamp, speedKn, gustKn, directionDeg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StationReading &&
          other.id == this.id &&
          other.stationId == this.stationId &&
          other.timestamp == this.timestamp &&
          other.speedKn == this.speedKn &&
          other.gustKn == this.gustKn &&
          other.directionDeg == this.directionDeg);
}

class StationReadingsCompanion extends UpdateCompanion<StationReading> {
  final Value<int> id;
  final Value<int> stationId;
  final Value<DateTime> timestamp;
  final Value<double> speedKn;
  final Value<double> gustKn;
  final Value<int> directionDeg;
  const StationReadingsCompanion({
    this.id = const Value.absent(),
    this.stationId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.speedKn = const Value.absent(),
    this.gustKn = const Value.absent(),
    this.directionDeg = const Value.absent(),
  });
  StationReadingsCompanion.insert({
    this.id = const Value.absent(),
    required int stationId,
    required DateTime timestamp,
    required double speedKn,
    required double gustKn,
    required int directionDeg,
  }) : stationId = Value(stationId),
       timestamp = Value(timestamp),
       speedKn = Value(speedKn),
       gustKn = Value(gustKn),
       directionDeg = Value(directionDeg);
  static Insertable<StationReading> custom({
    Expression<int>? id,
    Expression<int>? stationId,
    Expression<DateTime>? timestamp,
    Expression<double>? speedKn,
    Expression<double>? gustKn,
    Expression<int>? directionDeg,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stationId != null) 'station_id': stationId,
      if (timestamp != null) 'timestamp': timestamp,
      if (speedKn != null) 'speed_kn': speedKn,
      if (gustKn != null) 'gust_kn': gustKn,
      if (directionDeg != null) 'direction_deg': directionDeg,
    });
  }

  StationReadingsCompanion copyWith({
    Value<int>? id,
    Value<int>? stationId,
    Value<DateTime>? timestamp,
    Value<double>? speedKn,
    Value<double>? gustKn,
    Value<int>? directionDeg,
  }) {
    return StationReadingsCompanion(
      id: id ?? this.id,
      stationId: stationId ?? this.stationId,
      timestamp: timestamp ?? this.timestamp,
      speedKn: speedKn ?? this.speedKn,
      gustKn: gustKn ?? this.gustKn,
      directionDeg: directionDeg ?? this.directionDeg,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (stationId.present) {
      map['station_id'] = Variable<int>(stationId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (speedKn.present) {
      map['speed_kn'] = Variable<double>(speedKn.value);
    }
    if (gustKn.present) {
      map['gust_kn'] = Variable<double>(gustKn.value);
    }
    if (directionDeg.present) {
      map['direction_deg'] = Variable<int>(directionDeg.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StationReadingsCompanion(')
          ..write('id: $id, ')
          ..write('stationId: $stationId, ')
          ..write('timestamp: $timestamp, ')
          ..write('speedKn: $speedKn, ')
          ..write('gustKn: $gustKn, ')
          ..write('directionDeg: $directionDeg')
          ..write(')'))
        .toString();
  }
}

class $RideSessionsTable extends RideSessions
    with TableInfo<$RideSessionsTable, RideSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RideSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _spotNameMeta = const VerificationMeta(
    'spotName',
  );
  @override
  late final GeneratedColumn<String> spotName = GeneratedColumn<String>(
    'spot_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceKmMeta = const VerificationMeta(
    'distanceKm',
  );
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avgSpeedKnMeta = const VerificationMeta(
    'avgSpeedKn',
  );
  @override
  late final GeneratedColumn<double> avgSpeedKn = GeneratedColumn<double>(
    'avg_speed_kn',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxSpeedKnMeta = const VerificationMeta(
    'maxSpeedKn',
  );
  @override
  late final GeneratedColumn<double> maxSpeedKn = GeneratedColumn<double>(
    'max_speed_kn',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    spotName,
    startedAt,
    endedAt,
    durationMinutes,
    distanceKm,
    avgSpeedKn,
    maxSpeedKn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ride_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RideSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('spot_name')) {
      context.handle(
        _spotNameMeta,
        spotName.isAcceptableOrUnknown(data['spot_name']!, _spotNameMeta),
      );
    } else if (isInserting) {
      context.missing(_spotNameMeta);
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
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('distance_km')) {
      context.handle(
        _distanceKmMeta,
        distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta),
      );
    } else if (isInserting) {
      context.missing(_distanceKmMeta);
    }
    if (data.containsKey('avg_speed_kn')) {
      context.handle(
        _avgSpeedKnMeta,
        avgSpeedKn.isAcceptableOrUnknown(
          data['avg_speed_kn']!,
          _avgSpeedKnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_avgSpeedKnMeta);
    }
    if (data.containsKey('max_speed_kn')) {
      context.handle(
        _maxSpeedKnMeta,
        maxSpeedKn.isAcceptableOrUnknown(
          data['max_speed_kn']!,
          _maxSpeedKnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxSpeedKnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RideSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RideSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      spotName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}spot_name'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      distanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_km'],
      )!,
      avgSpeedKn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_speed_kn'],
      )!,
      maxSpeedKn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_speed_kn'],
      )!,
    );
  }

  @override
  $RideSessionsTable createAlias(String alias) {
    return $RideSessionsTable(attachedDatabase, alias);
  }
}

class RideSession extends DataClass implements Insertable<RideSession> {
  final int id;
  final int userId;
  final String spotName;
  final DateTime startedAt;
  final DateTime endedAt;
  final int durationMinutes;
  final double distanceKm;
  final double avgSpeedKn;
  final double maxSpeedKn;
  const RideSession({
    required this.id,
    required this.userId,
    required this.spotName,
    required this.startedAt,
    required this.endedAt,
    required this.durationMinutes,
    required this.distanceKm,
    required this.avgSpeedKn,
    required this.maxSpeedKn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['spot_name'] = Variable<String>(spotName);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['distance_km'] = Variable<double>(distanceKm);
    map['avg_speed_kn'] = Variable<double>(avgSpeedKn);
    map['max_speed_kn'] = Variable<double>(maxSpeedKn);
    return map;
  }

  RideSessionsCompanion toCompanion(bool nullToAbsent) {
    return RideSessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      spotName: Value(spotName),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      durationMinutes: Value(durationMinutes),
      distanceKm: Value(distanceKm),
      avgSpeedKn: Value(avgSpeedKn),
      maxSpeedKn: Value(maxSpeedKn),
    );
  }

  factory RideSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RideSession(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      spotName: serializer.fromJson<String>(json['spotName']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      distanceKm: serializer.fromJson<double>(json['distanceKm']),
      avgSpeedKn: serializer.fromJson<double>(json['avgSpeedKn']),
      maxSpeedKn: serializer.fromJson<double>(json['maxSpeedKn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'spotName': serializer.toJson<String>(spotName),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'distanceKm': serializer.toJson<double>(distanceKm),
      'avgSpeedKn': serializer.toJson<double>(avgSpeedKn),
      'maxSpeedKn': serializer.toJson<double>(maxSpeedKn),
    };
  }

  RideSession copyWith({
    int? id,
    int? userId,
    String? spotName,
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationMinutes,
    double? distanceKm,
    double? avgSpeedKn,
    double? maxSpeedKn,
  }) => RideSession(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    spotName: spotName ?? this.spotName,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    distanceKm: distanceKm ?? this.distanceKm,
    avgSpeedKn: avgSpeedKn ?? this.avgSpeedKn,
    maxSpeedKn: maxSpeedKn ?? this.maxSpeedKn,
  );
  RideSession copyWithCompanion(RideSessionsCompanion data) {
    return RideSession(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      spotName: data.spotName.present ? data.spotName.value : this.spotName,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      distanceKm: data.distanceKm.present
          ? data.distanceKm.value
          : this.distanceKm,
      avgSpeedKn: data.avgSpeedKn.present
          ? data.avgSpeedKn.value
          : this.avgSpeedKn,
      maxSpeedKn: data.maxSpeedKn.present
          ? data.maxSpeedKn.value
          : this.maxSpeedKn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RideSession(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('spotName: $spotName, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('avgSpeedKn: $avgSpeedKn, ')
          ..write('maxSpeedKn: $maxSpeedKn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    spotName,
    startedAt,
    endedAt,
    durationMinutes,
    distanceKm,
    avgSpeedKn,
    maxSpeedKn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RideSession &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.spotName == this.spotName &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationMinutes == this.durationMinutes &&
          other.distanceKm == this.distanceKm &&
          other.avgSpeedKn == this.avgSpeedKn &&
          other.maxSpeedKn == this.maxSpeedKn);
}

class RideSessionsCompanion extends UpdateCompanion<RideSession> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> spotName;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> durationMinutes;
  final Value<double> distanceKm;
  final Value<double> avgSpeedKn;
  final Value<double> maxSpeedKn;
  const RideSessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.spotName = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.avgSpeedKn = const Value.absent(),
    this.maxSpeedKn = const Value.absent(),
  });
  RideSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String spotName,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationMinutes,
    required double distanceKm,
    required double avgSpeedKn,
    required double maxSpeedKn,
  }) : spotName = Value(spotName),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       durationMinutes = Value(durationMinutes),
       distanceKm = Value(distanceKm),
       avgSpeedKn = Value(avgSpeedKn),
       maxSpeedKn = Value(maxSpeedKn);
  static Insertable<RideSession> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? spotName,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationMinutes,
    Expression<double>? distanceKm,
    Expression<double>? avgSpeedKn,
    Expression<double>? maxSpeedKn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (spotName != null) 'spot_name': spotName,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (avgSpeedKn != null) 'avg_speed_kn': avgSpeedKn,
      if (maxSpeedKn != null) 'max_speed_kn': maxSpeedKn,
    });
  }

  RideSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? spotName,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? durationMinutes,
    Value<double>? distanceKm,
    Value<double>? avgSpeedKn,
    Value<double>? maxSpeedKn,
  }) {
    return RideSessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spotName: spotName ?? this.spotName,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      distanceKm: distanceKm ?? this.distanceKm,
      avgSpeedKn: avgSpeedKn ?? this.avgSpeedKn,
      maxSpeedKn: maxSpeedKn ?? this.maxSpeedKn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (spotName.present) {
      map['spot_name'] = Variable<String>(spotName.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (avgSpeedKn.present) {
      map['avg_speed_kn'] = Variable<double>(avgSpeedKn.value);
    }
    if (maxSpeedKn.present) {
      map['max_speed_kn'] = Variable<double>(maxSpeedKn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RideSessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('spotName: $spotName, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('avgSpeedKn: $avgSpeedKn, ')
          ..write('maxSpeedKn: $maxSpeedKn')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $AuthSessionsTable authSessions = $AuthSessionsTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $WindAlertsTable windAlerts = $WindAlertsTable(this);
  late final $StationsTable stations = $StationsTable(this);
  late final $StationReadingsTable stationReadings = $StationReadingsTable(
    this,
  );
  late final $RideSessionsTable rideSessions = $RideSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    authSessions,
    users,
    windAlerts,
    stations,
    stationReadings,
    rideSessions,
  ];
}

typedef $$AuthSessionsTableCreateCompanionBuilder =
    AuthSessionsCompanion Function({
      Value<int> id,
      required bool isAuthenticated,
      required DateTime updatedAt,
    });
typedef $$AuthSessionsTableUpdateCompanionBuilder =
    AuthSessionsCompanion Function({
      Value<int> id,
      Value<bool> isAuthenticated,
      Value<DateTime> updatedAt,
    });

class $$AuthSessionsTableFilterComposer
    extends Composer<_$LocalDatabase, $AuthSessionsTable> {
  $$AuthSessionsTableFilterComposer({
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

  ColumnFilters<bool> get isAuthenticated => $composableBuilder(
    column: $table.isAuthenticated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuthSessionsTableOrderingComposer
    extends Composer<_$LocalDatabase, $AuthSessionsTable> {
  $$AuthSessionsTableOrderingComposer({
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

  ColumnOrderings<bool> get isAuthenticated => $composableBuilder(
    column: $table.isAuthenticated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthSessionsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $AuthSessionsTable> {
  $$AuthSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isAuthenticated => $composableBuilder(
    column: $table.isAuthenticated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AuthSessionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $AuthSessionsTable,
          AuthSession,
          $$AuthSessionsTableFilterComposer,
          $$AuthSessionsTableOrderingComposer,
          $$AuthSessionsTableAnnotationComposer,
          $$AuthSessionsTableCreateCompanionBuilder,
          $$AuthSessionsTableUpdateCompanionBuilder,
          (
            AuthSession,
            BaseReferences<_$LocalDatabase, $AuthSessionsTable, AuthSession>,
          ),
          AuthSession,
          PrefetchHooks Function()
        > {
  $$AuthSessionsTableTableManager(_$LocalDatabase db, $AuthSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> isAuthenticated = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AuthSessionsCompanion(
                id: id,
                isAuthenticated: isAuthenticated,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required bool isAuthenticated,
                required DateTime updatedAt,
              }) => AuthSessionsCompanion.insert(
                id: id,
                isAuthenticated: isAuthenticated,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $AuthSessionsTable,
      AuthSession,
      $$AuthSessionsTableFilterComposer,
      $$AuthSessionsTableOrderingComposer,
      $$AuthSessionsTableAnnotationComposer,
      $$AuthSessionsTableCreateCompanionBuilder,
      $$AuthSessionsTableUpdateCompanionBuilder,
      (
        AuthSession,
        BaseReferences<_$LocalDatabase, $AuthSessionsTable, AuthSession>,
      ),
      AuthSession,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String?> email,
      Value<String?> displayName,
      Value<String?> preferredDiscipline,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String?> email,
      Value<String?> displayName,
      Value<String?> preferredDiscipline,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$UsersTableFilterComposer
    extends Composer<_$LocalDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredDiscipline => $composableBuilder(
    column: $table.preferredDiscipline,
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

class $$UsersTableOrderingComposer
    extends Composer<_$LocalDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredDiscipline => $composableBuilder(
    column: $table.preferredDiscipline,
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

class $$UsersTableAnnotationComposer
    extends Composer<_$LocalDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preferredDiscipline => $composableBuilder(
    column: $table.preferredDiscipline,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$LocalDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$LocalDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> preferredDiscipline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                displayName: displayName,
                preferredDiscipline: preferredDiscipline,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> preferredDiscipline = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                displayName: displayName,
                preferredDiscipline: preferredDiscipline,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$LocalDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$WindAlertsTableCreateCompanionBuilder =
    WindAlertsCompanion Function({
      Value<int> id,
      Value<int> userId,
      required double minSpeedKn,
      required double maxSpeedKn,
      required int directionMinDeg,
      required int directionMaxDeg,
      required int startHour,
      required int endHour,
      Value<bool> enabled,
    });
typedef $$WindAlertsTableUpdateCompanionBuilder =
    WindAlertsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<double> minSpeedKn,
      Value<double> maxSpeedKn,
      Value<int> directionMinDeg,
      Value<int> directionMaxDeg,
      Value<int> startHour,
      Value<int> endHour,
      Value<bool> enabled,
    });

class $$WindAlertsTableFilterComposer
    extends Composer<_$LocalDatabase, $WindAlertsTable> {
  $$WindAlertsTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minSpeedKn => $composableBuilder(
    column: $table.minSpeedKn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeedKn => $composableBuilder(
    column: $table.maxSpeedKn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get directionMinDeg => $composableBuilder(
    column: $table.directionMinDeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get directionMaxDeg => $composableBuilder(
    column: $table.directionMaxDeg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endHour => $composableBuilder(
    column: $table.endHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WindAlertsTableOrderingComposer
    extends Composer<_$LocalDatabase, $WindAlertsTable> {
  $$WindAlertsTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minSpeedKn => $composableBuilder(
    column: $table.minSpeedKn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeedKn => $composableBuilder(
    column: $table.maxSpeedKn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get directionMinDeg => $composableBuilder(
    column: $table.directionMinDeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get directionMaxDeg => $composableBuilder(
    column: $table.directionMaxDeg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startHour => $composableBuilder(
    column: $table.startHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endHour => $composableBuilder(
    column: $table.endHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WindAlertsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $WindAlertsTable> {
  $$WindAlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<double> get minSpeedKn => $composableBuilder(
    column: $table.minSpeedKn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeedKn => $composableBuilder(
    column: $table.maxSpeedKn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get directionMinDeg => $composableBuilder(
    column: $table.directionMinDeg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get directionMaxDeg => $composableBuilder(
    column: $table.directionMaxDeg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startHour =>
      $composableBuilder(column: $table.startHour, builder: (column) => column);

  GeneratedColumn<int> get endHour =>
      $composableBuilder(column: $table.endHour, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);
}

class $$WindAlertsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $WindAlertsTable,
          WindAlert,
          $$WindAlertsTableFilterComposer,
          $$WindAlertsTableOrderingComposer,
          $$WindAlertsTableAnnotationComposer,
          $$WindAlertsTableCreateCompanionBuilder,
          $$WindAlertsTableUpdateCompanionBuilder,
          (
            WindAlert,
            BaseReferences<_$LocalDatabase, $WindAlertsTable, WindAlert>,
          ),
          WindAlert,
          PrefetchHooks Function()
        > {
  $$WindAlertsTableTableManager(_$LocalDatabase db, $WindAlertsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WindAlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WindAlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WindAlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<double> minSpeedKn = const Value.absent(),
                Value<double> maxSpeedKn = const Value.absent(),
                Value<int> directionMinDeg = const Value.absent(),
                Value<int> directionMaxDeg = const Value.absent(),
                Value<int> startHour = const Value.absent(),
                Value<int> endHour = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
              }) => WindAlertsCompanion(
                id: id,
                userId: userId,
                minSpeedKn: minSpeedKn,
                maxSpeedKn: maxSpeedKn,
                directionMinDeg: directionMinDeg,
                directionMaxDeg: directionMaxDeg,
                startHour: startHour,
                endHour: endHour,
                enabled: enabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                required double minSpeedKn,
                required double maxSpeedKn,
                required int directionMinDeg,
                required int directionMaxDeg,
                required int startHour,
                required int endHour,
                Value<bool> enabled = const Value.absent(),
              }) => WindAlertsCompanion.insert(
                id: id,
                userId: userId,
                minSpeedKn: minSpeedKn,
                maxSpeedKn: maxSpeedKn,
                directionMinDeg: directionMinDeg,
                directionMaxDeg: directionMaxDeg,
                startHour: startHour,
                endHour: endHour,
                enabled: enabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WindAlertsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $WindAlertsTable,
      WindAlert,
      $$WindAlertsTableFilterComposer,
      $$WindAlertsTableOrderingComposer,
      $$WindAlertsTableAnnotationComposer,
      $$WindAlertsTableCreateCompanionBuilder,
      $$WindAlertsTableUpdateCompanionBuilder,
      (WindAlert, BaseReferences<_$LocalDatabase, $WindAlertsTable, WindAlert>),
      WindAlert,
      PrefetchHooks Function()
    >;
typedef $$StationsTableCreateCompanionBuilder =
    StationsCompanion Function({
      Value<int> id,
      required String name,
      required String province,
      required double latitude,
      required double longitude,
    });
typedef $$StationsTableUpdateCompanionBuilder =
    StationsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> province,
      Value<double> latitude,
      Value<double> longitude,
    });

class $$StationsTableFilterComposer
    extends Composer<_$LocalDatabase, $StationsTable> {
  $$StationsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get province => $composableBuilder(
    column: $table.province,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StationsTableOrderingComposer
    extends Composer<_$LocalDatabase, $StationsTable> {
  $$StationsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get province => $composableBuilder(
    column: $table.province,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StationsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $StationsTable> {
  $$StationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get province =>
      $composableBuilder(column: $table.province, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);
}

class $$StationsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $StationsTable,
          Station,
          $$StationsTableFilterComposer,
          $$StationsTableOrderingComposer,
          $$StationsTableAnnotationComposer,
          $$StationsTableCreateCompanionBuilder,
          $$StationsTableUpdateCompanionBuilder,
          (Station, BaseReferences<_$LocalDatabase, $StationsTable, Station>),
          Station,
          PrefetchHooks Function()
        > {
  $$StationsTableTableManager(_$LocalDatabase db, $StationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> province = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
              }) => StationsCompanion(
                id: id,
                name: name,
                province: province,
                latitude: latitude,
                longitude: longitude,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String province,
                required double latitude,
                required double longitude,
              }) => StationsCompanion.insert(
                id: id,
                name: name,
                province: province,
                latitude: latitude,
                longitude: longitude,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StationsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $StationsTable,
      Station,
      $$StationsTableFilterComposer,
      $$StationsTableOrderingComposer,
      $$StationsTableAnnotationComposer,
      $$StationsTableCreateCompanionBuilder,
      $$StationsTableUpdateCompanionBuilder,
      (Station, BaseReferences<_$LocalDatabase, $StationsTable, Station>),
      Station,
      PrefetchHooks Function()
    >;
typedef $$StationReadingsTableCreateCompanionBuilder =
    StationReadingsCompanion Function({
      Value<int> id,
      required int stationId,
      required DateTime timestamp,
      required double speedKn,
      required double gustKn,
      required int directionDeg,
    });
typedef $$StationReadingsTableUpdateCompanionBuilder =
    StationReadingsCompanion Function({
      Value<int> id,
      Value<int> stationId,
      Value<DateTime> timestamp,
      Value<double> speedKn,
      Value<double> gustKn,
      Value<int> directionDeg,
    });

class $$StationReadingsTableFilterComposer
    extends Composer<_$LocalDatabase, $StationReadingsTable> {
  $$StationReadingsTableFilterComposer({
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

  ColumnFilters<int> get stationId => $composableBuilder(
    column: $table.stationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedKn => $composableBuilder(
    column: $table.speedKn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get gustKn => $composableBuilder(
    column: $table.gustKn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get directionDeg => $composableBuilder(
    column: $table.directionDeg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StationReadingsTableOrderingComposer
    extends Composer<_$LocalDatabase, $StationReadingsTable> {
  $$StationReadingsTableOrderingComposer({
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

  ColumnOrderings<int> get stationId => $composableBuilder(
    column: $table.stationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedKn => $composableBuilder(
    column: $table.speedKn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get gustKn => $composableBuilder(
    column: $table.gustKn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get directionDeg => $composableBuilder(
    column: $table.directionDeg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StationReadingsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $StationReadingsTable> {
  $$StationReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stationId =>
      $composableBuilder(column: $table.stationId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get speedKn =>
      $composableBuilder(column: $table.speedKn, builder: (column) => column);

  GeneratedColumn<double> get gustKn =>
      $composableBuilder(column: $table.gustKn, builder: (column) => column);

  GeneratedColumn<int> get directionDeg => $composableBuilder(
    column: $table.directionDeg,
    builder: (column) => column,
  );
}

class $$StationReadingsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $StationReadingsTable,
          StationReading,
          $$StationReadingsTableFilterComposer,
          $$StationReadingsTableOrderingComposer,
          $$StationReadingsTableAnnotationComposer,
          $$StationReadingsTableCreateCompanionBuilder,
          $$StationReadingsTableUpdateCompanionBuilder,
          (
            StationReading,
            BaseReferences<
              _$LocalDatabase,
              $StationReadingsTable,
              StationReading
            >,
          ),
          StationReading,
          PrefetchHooks Function()
        > {
  $$StationReadingsTableTableManager(
    _$LocalDatabase db,
    $StationReadingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StationReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StationReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StationReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> stationId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> speedKn = const Value.absent(),
                Value<double> gustKn = const Value.absent(),
                Value<int> directionDeg = const Value.absent(),
              }) => StationReadingsCompanion(
                id: id,
                stationId: stationId,
                timestamp: timestamp,
                speedKn: speedKn,
                gustKn: gustKn,
                directionDeg: directionDeg,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int stationId,
                required DateTime timestamp,
                required double speedKn,
                required double gustKn,
                required int directionDeg,
              }) => StationReadingsCompanion.insert(
                id: id,
                stationId: stationId,
                timestamp: timestamp,
                speedKn: speedKn,
                gustKn: gustKn,
                directionDeg: directionDeg,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StationReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $StationReadingsTable,
      StationReading,
      $$StationReadingsTableFilterComposer,
      $$StationReadingsTableOrderingComposer,
      $$StationReadingsTableAnnotationComposer,
      $$StationReadingsTableCreateCompanionBuilder,
      $$StationReadingsTableUpdateCompanionBuilder,
      (
        StationReading,
        BaseReferences<_$LocalDatabase, $StationReadingsTable, StationReading>,
      ),
      StationReading,
      PrefetchHooks Function()
    >;
typedef $$RideSessionsTableCreateCompanionBuilder =
    RideSessionsCompanion Function({
      Value<int> id,
      Value<int> userId,
      required String spotName,
      required DateTime startedAt,
      required DateTime endedAt,
      required int durationMinutes,
      required double distanceKm,
      required double avgSpeedKn,
      required double maxSpeedKn,
    });
typedef $$RideSessionsTableUpdateCompanionBuilder =
    RideSessionsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> spotName,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> durationMinutes,
      Value<double> distanceKm,
      Value<double> avgSpeedKn,
      Value<double> maxSpeedKn,
    });

class $$RideSessionsTableFilterComposer
    extends Composer<_$LocalDatabase, $RideSessionsTable> {
  $$RideSessionsTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get spotName => $composableBuilder(
    column: $table.spotName,
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

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgSpeedKn => $composableBuilder(
    column: $table.avgSpeedKn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxSpeedKn => $composableBuilder(
    column: $table.maxSpeedKn,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RideSessionsTableOrderingComposer
    extends Composer<_$LocalDatabase, $RideSessionsTable> {
  $$RideSessionsTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get spotName => $composableBuilder(
    column: $table.spotName,
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

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgSpeedKn => $composableBuilder(
    column: $table.avgSpeedKn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxSpeedKn => $composableBuilder(
    column: $table.maxSpeedKn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RideSessionsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $RideSessionsTable> {
  $$RideSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get spotName =>
      $composableBuilder(column: $table.spotName, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgSpeedKn => $composableBuilder(
    column: $table.avgSpeedKn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxSpeedKn => $composableBuilder(
    column: $table.maxSpeedKn,
    builder: (column) => column,
  );
}

class $$RideSessionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $RideSessionsTable,
          RideSession,
          $$RideSessionsTableFilterComposer,
          $$RideSessionsTableOrderingComposer,
          $$RideSessionsTableAnnotationComposer,
          $$RideSessionsTableCreateCompanionBuilder,
          $$RideSessionsTableUpdateCompanionBuilder,
          (
            RideSession,
            BaseReferences<_$LocalDatabase, $RideSessionsTable, RideSession>,
          ),
          RideSession,
          PrefetchHooks Function()
        > {
  $$RideSessionsTableTableManager(_$LocalDatabase db, $RideSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RideSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RideSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RideSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> spotName = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<double> distanceKm = const Value.absent(),
                Value<double> avgSpeedKn = const Value.absent(),
                Value<double> maxSpeedKn = const Value.absent(),
              }) => RideSessionsCompanion(
                id: id,
                userId: userId,
                spotName: spotName,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMinutes: durationMinutes,
                distanceKm: distanceKm,
                avgSpeedKn: avgSpeedKn,
                maxSpeedKn: maxSpeedKn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                required String spotName,
                required DateTime startedAt,
                required DateTime endedAt,
                required int durationMinutes,
                required double distanceKm,
                required double avgSpeedKn,
                required double maxSpeedKn,
              }) => RideSessionsCompanion.insert(
                id: id,
                userId: userId,
                spotName: spotName,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMinutes: durationMinutes,
                distanceKm: distanceKm,
                avgSpeedKn: avgSpeedKn,
                maxSpeedKn: maxSpeedKn,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RideSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $RideSessionsTable,
      RideSession,
      $$RideSessionsTableFilterComposer,
      $$RideSessionsTableOrderingComposer,
      $$RideSessionsTableAnnotationComposer,
      $$RideSessionsTableCreateCompanionBuilder,
      $$RideSessionsTableUpdateCompanionBuilder,
      (
        RideSession,
        BaseReferences<_$LocalDatabase, $RideSessionsTable, RideSession>,
      ),
      RideSession,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$AuthSessionsTableTableManager get authSessions =>
      $$AuthSessionsTableTableManager(_db, _db.authSessions);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$WindAlertsTableTableManager get windAlerts =>
      $$WindAlertsTableTableManager(_db, _db.windAlerts);
  $$StationsTableTableManager get stations =>
      $$StationsTableTableManager(_db, _db.stations);
  $$StationReadingsTableTableManager get stationReadings =>
      $$StationReadingsTableTableManager(_db, _db.stationReadings);
  $$RideSessionsTableTableManager get rideSessions =>
      $$RideSessionsTableTableManager(_db, _db.rideSessions);
}
