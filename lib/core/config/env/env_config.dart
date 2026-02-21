class EnvConfig {
  static const appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  static const devBypassEnabled = bool.fromEnvironment(
    'DEV_BYPASS_ENABLED',
    defaultValue: true,
  );

  static const openMeteoBaseUrl = String.fromEnvironment(
    'OPEN_METEO_BASE_URL',
    defaultValue: '',
  );
  static const aemetBaseUrl = String.fromEnvironment(
    'AEMET_BASE_URL',
    defaultValue: '',
  );
  static const aemetApiKey = String.fromEnvironment(
    'AEMET_API_KEY',
    defaultValue: '',
  );

  static const googleAuthEnabled = bool.fromEnvironment(
    'GOOGLE_AUTH_ENABLED',
    defaultValue: false,
  );

  static const appleAuthEnabled = bool.fromEnvironment(
    'APPLE_AUTH_ENABLED',
    defaultValue: false,
  );
}
