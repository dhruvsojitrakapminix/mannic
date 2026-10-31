/// Detects whether BitTV is currently set as the device's default launcher.
/// Stub implementation — returns `false` until a native channel is added.
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