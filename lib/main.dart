import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Required for MobileAds init

import 'app/data/repositories/favorites_repository.dart';
import 'app/data/services/ads_service.dart';
import 'app/data/services/app_config.dart';
import 'app/data/services/app_update_service.dart';
import 'app/data/services/custom_banner_service.dart';
import 'app/data/services/install_source_service.dart';
import 'app/data/services/watch_history.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Storage ────────────────────────────────
  await GetStorage.init();

  // ── Firebase ───────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (err, stack) {
    FirebaseCrashlytics.instance.recordError(err, stack, fatal: true);
    return true;
  };

  // ── Initialize Mobile Ads SDK (Required before AdsService init) ──
  await MobileAds.instance.initialize();

  // ── App services ───────────────────────────
  await AppConfigStore.instance.init();
  InstallSourceService.instance.init();
  CustomBannerService.instance.init();
  WatchHistory.instance.init();
  FavoritesRepo.i.init();

  // Initialize AdsService (which will now load App Open & Interstitial ads)
  AdsService.instance.init();

  AppUpdateService.instance.checkOnce();

  runApp(const App());
}

// Changed to StatefulWidget to listen to lifecycle events
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Show App Open Ad when the app is resumed
    if (state == AppLifecycleState.resumed) {
      AdsService.instance.showAppOpenIfReady();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      builder: (_, __) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerUp: (_) => AdsService.instance.onUserTap(),
        child: GetMaterialApp(
          title: 'Super Tv',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          initialRoute: Routes.LAUNCHER,
          getPages: AppPages.pages,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
        ),
      ),
    );
  }
}