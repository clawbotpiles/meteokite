class FeatureFlags {
  const FeatureFlags({
    required this.socialEnabled,
    required this.tournamentsEnabled,
    required this.backendSyncEnabled,
  });

  final bool socialEnabled;
  final bool tournamentsEnabled;
  final bool backendSyncEnabled;

  static const localDefault = FeatureFlags(
    socialEnabled: false,
    tournamentsEnabled: false,
    backendSyncEnabled: false,
  );
}
