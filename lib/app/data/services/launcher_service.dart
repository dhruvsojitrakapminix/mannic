
class LauncherService {
  LauncherService._();
  static final LauncherService instance = LauncherService._();

  Future<bool> isDefaultLauncher() async {
    // TODO: plug a MethodChannel to Android LauncherManager.
    return false;
  }

  Future<void> requestDefaultLauncher() async {
    // TODO: open system Settings → Default Home App.
  }
}