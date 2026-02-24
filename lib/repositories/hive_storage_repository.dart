import 'package:hive/hive.dart';
import 'storage_repository.dart';

class HiveStorageRepository extends StorageRepository {
  static const String _metaBoxName = 'app_meta';

  Box<dynamic>? _box;

  Future<Box<dynamic>> get _openBox async {
    _box ??= await Hive.openBox<dynamic>(_metaBoxName);
    return _box!;
  }

  @override
  Future<void> ensureSchemaVersion() async {
    final box = await _openBox;
    final existingVersion = box.get('schema_version') as int?;

    if (existingVersion == null) {
      await box.put('schema_version', StorageRepository.currentSchemaVersion);
      return;
    }

    if (existingVersion < StorageRepository.currentSchemaVersion) {
      // Future schema migrations for Hive go here
      await box.put('schema_version', StorageRepository.currentSchemaVersion);
    }
  }
}
