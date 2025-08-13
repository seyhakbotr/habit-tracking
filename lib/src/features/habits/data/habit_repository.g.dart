// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$habitsRepositoryHash() => r'77662ad44af7067dcc4c8686df4d7c45d49c18ef';

/// See also [habitsRepository].
@ProviderFor(habitsRepository)
final habitsRepositoryProvider = Provider<HabitsRepository>.internal(
  habitsRepository,
  name: r'habitsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$habitsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HabitsRepositoryRef = ProviderRef<HabitsRepository>;
String _$habitsQueryHash() => r'25fb684c78c0758814c7b6a961975433d1809236';

/// See also [habitsQuery].
@ProviderFor(habitsQuery)
final habitsQueryProvider = AutoDisposeProvider<Query<Habit>>.internal(
  habitsQuery,
  name: r'habitsQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$habitsQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HabitsQueryRef = AutoDisposeProviderRef<Query<Habit>>;
String _$habitStreamHash() => r'43c7482b4e57f05cf1d7a4dc9db67020169513f5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [habitStream].
@ProviderFor(habitStream)
const habitStreamProvider = HabitStreamFamily();

/// See also [habitStream].
class HabitStreamFamily extends Family<AsyncValue<Habit>> {
  /// See also [habitStream].
  const HabitStreamFamily();

  /// See also [habitStream].
  HabitStreamProvider call(
    String habitId,
  ) {
    return HabitStreamProvider(
      habitId,
    );
  }

  @override
  HabitStreamProvider getProviderOverride(
    covariant HabitStreamProvider provider,
  ) {
    return call(
      provider.habitId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'habitStreamProvider';
}

/// See also [habitStream].
class HabitStreamProvider extends AutoDisposeStreamProvider<Habit> {
  /// See also [habitStream].
  HabitStreamProvider(
    String habitId,
  ) : this._internal(
          (ref) => habitStream(
            ref as HabitStreamRef,
            habitId,
          ),
          from: habitStreamProvider,
          name: r'habitStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$habitStreamHash,
          dependencies: HabitStreamFamily._dependencies,
          allTransitiveDependencies:
              HabitStreamFamily._allTransitiveDependencies,
          habitId: habitId,
        );

  HabitStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.habitId,
  }) : super.internal();

  final String habitId;

  @override
  Override overrideWith(
    Stream<Habit> Function(HabitStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HabitStreamProvider._internal(
        (ref) => create(ref as HabitStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        habitId: habitId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Habit> createElement() {
    return _HabitStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HabitStreamProvider && other.habitId == habitId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, habitId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HabitStreamRef on AutoDisposeStreamProviderRef<Habit> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _HabitStreamProviderElement
    extends AutoDisposeStreamProviderElement<Habit> with HabitStreamRef {
  _HabitStreamProviderElement(super.provider);

  @override
  String get habitId => (origin as HabitStreamProvider).habitId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
