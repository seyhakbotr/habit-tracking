// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entries_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$entriesRepositoryHash() => r'17cd56c685d800f8456e9f526108ae479eb0aec2';

/// See also [entriesRepository].
@ProviderFor(entriesRepository)
final entriesRepositoryProvider =
    AutoDisposeProvider<EntriesRepository>.internal(
  entriesRepository,
  name: r'entriesRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$entriesRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EntriesRepositoryRef = AutoDisposeProviderRef<EntriesRepository>;
String _$habitEntriesQueryHash() => r'947499982e2b1fe73200d2badade56c128d1e0a0';

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

/// See also [habitEntriesQuery].
@ProviderFor(habitEntriesQuery)
const habitEntriesQueryProvider = HabitEntriesQueryFamily();

/// See also [habitEntriesQuery].
class HabitEntriesQueryFamily extends Family<Query<Entry>> {
  /// See also [habitEntriesQuery].
  const HabitEntriesQueryFamily();

  /// See also [habitEntriesQuery].
  HabitEntriesQueryProvider call(
    String habitId,
  ) {
    return HabitEntriesQueryProvider(
      habitId,
    );
  }

  @override
  HabitEntriesQueryProvider getProviderOverride(
    covariant HabitEntriesQueryProvider provider,
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
  String? get name => r'habitEntriesQueryProvider';
}

/// See also [habitEntriesQuery].
class HabitEntriesQueryProvider extends AutoDisposeProvider<Query<Entry>> {
  /// See also [habitEntriesQuery].
  HabitEntriesQueryProvider(
    String habitId,
  ) : this._internal(
          (ref) => habitEntriesQuery(
            ref as HabitEntriesQueryRef,
            habitId,
          ),
          from: habitEntriesQueryProvider,
          name: r'habitEntriesQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$habitEntriesQueryHash,
          dependencies: HabitEntriesQueryFamily._dependencies,
          allTransitiveDependencies:
              HabitEntriesQueryFamily._allTransitiveDependencies,
          habitId: habitId,
        );

  HabitEntriesQueryProvider._internal(
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
    Query<Entry> Function(HabitEntriesQueryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HabitEntriesQueryProvider._internal(
        (ref) => create(ref as HabitEntriesQueryRef),
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
  AutoDisposeProviderElement<Query<Entry>> createElement() {
    return _HabitEntriesQueryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HabitEntriesQueryProvider && other.habitId == habitId;
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
mixin HabitEntriesQueryRef on AutoDisposeProviderRef<Query<Entry>> {
  /// The parameter `habitId` of this provider.
  String get habitId;
}

class _HabitEntriesQueryProviderElement
    extends AutoDisposeProviderElement<Query<Entry>> with HabitEntriesQueryRef {
  _HabitEntriesQueryProviderElement(super.provider);

  @override
  String get habitId => (origin as HabitEntriesQueryProvider).habitId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
