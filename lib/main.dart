import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:netmirror_flutter/services/app_open_ad_manager.dart';
import 'package:netmirror_flutter/splash_screen.dart';
import 'package:netmirror_flutter/widgets/SmallNativeAdService.dart';
import 'Utils/common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Mobile Ads
  await MobileAds.instance.initialize();

  // Configure test device for development
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      testDeviceIds: [
        'A69FFF02F5AF526F6B14615EAAEF3FB9',
      ], // Your device ID from logs
    ),
  );

  return runApp(const Root());
}

class Root extends StatefulWidget with WidgetsBindingObserver {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // Initialize native ad service
    SmallNativeAdService().initialize();

    ///Initialize images and precache it
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.wait([
        precacheImage(const AssetImage("assets/images/n1.jpeg"), context),
        precacheImage(const AssetImage("assets/images/n2.jpeg"), context),
        precacheImage(const AssetImage("assets/images/n3.jpeg"), context),
        precacheImage(const AssetImage("assets/images/n4.jpeg"), context),
        precacheImage(const AssetImage("assets/images/splash.png"), context),
        precacheImage(
          const AssetImage("assets/images/qurekaads2.png"),
          context,
        ),
      ]);
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App is going to background
      Common.isAppInBackground = true;
    } else if (state == AppLifecycleState.resumed) {
      // App is resuming from background
      if (Common.addOnOff && Common.isAppInBackground) {
        if (!_recentlyShownInterstitial()) {
          _appOpenAdManager.showAdIfAvailable();
        }
      }
      // Reset background flag after handling resume
      Common.isAppInBackground = false;
    }
  }

  bool _recentlyShownInterstitial() {
    // Check if recently opened flag is true
    if (Common.recentlyOpened) {
      return true;
    }

    // Check if interstitial ad was shown within the last 15 seconds
    if (Common.lastInterstitialAdTime != null) {
      final timeSinceLastAd = DateTime.now().difference(
        Common.lastInterstitialAdTime!,
      );
      if (timeSinceLastAd.inSeconds < 15) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
