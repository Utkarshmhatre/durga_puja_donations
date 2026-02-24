import 'package:shared_preferences/shared_preferences.dart';

abstract class StorageRepository {
  static const int currentSchemaVersion = 2;
  Future<void> ensureSchemaVersion();
}

class SharedPrefsStorageRepository extends StorageRepository {
  static const String schemaVersionKey = 'storage_schema_version';

  @override
  Future<void> ensureSchemaVersion() async {
    final prefs = await SharedPreferences.getInstance();
    final existingVersion = prefs.getInt(schemaVersionKey);

    if (existingVersion == null) {
      await prefs.setInt(
          schemaVersionKey, StorageRepository.currentSchemaVersion);
      return;
    }

    if (existingVersion < StorageRepository.currentSchemaVersion) {
      await _runMigrations(
          existingVersion, StorageRepository.currentSchemaVersion, prefs);
      await prefs.setInt(
          schemaVersionKey, StorageRepository.currentSchemaVersion);
    }
  }

  Future<void> _runMigrations(
    int fromVersion,
    int toVersion,
    SharedPreferences prefs,
  ) async {
    for (int version = fromVersion + 1; version <= toVersion; version++) {
      if (version == 1) {
        continue;
      }
      if (version == 2) {
        // Schema v2: Hive migration marker — handled by HiveMigrationService
        continue;
      }
    }
  }
}
