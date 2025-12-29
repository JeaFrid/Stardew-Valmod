import 'package:just_manager/just_manager.dart';

class GeneralSettingsUtils {
  static JM<bool> isLoading = JM(false);
  static void setLoading(bool status) {
    isLoading.set(status);
  }
}
