import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_app/features/shared/infrastructure/services/key_value_storage_service.dart';

class KeyValueStorageServiceImpl implements KeyValueStorageService {
  Future<SharedPreferences> getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPreferences();

    switch (T) {
      case String:
        return prefs.getString(key) as T?;
      case int:
        return prefs.getInt(key) as T?;
      case double:
        return prefs.getDouble(key) as T?;
      case bool:
        return prefs.getBool(key) as T?;
      default:
        throw UnsupportedError('Unsupported type: ${T.toString()}');
    }
  }

  @override
  Future<bool> removeKeyValue(String key) async {
    final prefs = await getSharedPreferences();
    return prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPreferences();

    switch (T) {
      case String:
        await prefs.setString(key, value as String);
        break;
      case int:
        await prefs.setInt(key, value as int);
        break;
      case double:
        await prefs.setDouble(key, value as double);
        break;
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      default:
        throw UnsupportedError('Unsupported type: ${T.toString()}');
    }

    return;
  }
}
