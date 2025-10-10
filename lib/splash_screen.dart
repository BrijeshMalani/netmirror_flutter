import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:netmirror_flutter/services/ad_manager.dart';
import 'package:netmirror_flutter/services/api_service.dart';
import 'package:netmirror_flutter/services/app_open_ad_manager.dart';
import 'package:netmirror_flutter/widgets/NativeAdService.dart';
import 'package:netmirror_flutter/widgets/SmallNativeAdService.dart';
import 'Utils/common.dart';
import 'netmirror/movie_nav.dart';
import 'intro/intro_flow.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppOpenAdManager _appOpenAdManager = AppOpenAdManager();

  @override
  void initState() {
    setupRemoteConfig();
    super.initState();
    // Navigate to appropriate screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _navigateToNextScreen();
    });
  }

  Future<void> setupRemoteConfig() async {
    final data = await ApiService.fetchAppData();
    print('API Response: $data');

    if (data != null) {
      if (data.rewardedFull.isNotEmpty) {
        print('Setting privacy policy: ${data.rewardedFull}');
        Common.privacy_policy = data.rewardedFull;
      }
      if (data.rewardedFull2.isNotEmpty) {
        print('Setting terms and conditions: ${data.rewardedFull2}');
        Common.terms_conditions = data.rewardedFull2;
      }
      if (data.startAppFull.isNotEmpty) {
        print('Setting playstore link: ${data.startAppFull}');
        Common.playstore_link = data.startAppFull;
      }
      if (data.gamezopId.isNotEmpty) {
        print('Interstitial show count: ${data.gamezopId}');
        Common.ads_int_open_count = int.parse(data.gamezopId);
      }
      if (data.rewardedFull1.isNotEmpty) {
        print('Ads Open Count: ${data.rewardedFull1}');
        Common.ads_open_count = data.rewardedFull1;
      }
      if (data.startAppRewarded.isNotEmpty) {
        print('Ads open area: ${data.startAppRewarded}');
        Common.adsopen = data.startAppRewarded;
      }
      if (data.fbId.isNotEmpty) {
        print('Net Mirror Key: ${data.fbId}');
        Common.netmirror_apiKey = data.fbId;
      }

      if (data.qurekaId.isNotEmpty) {
        print('qureka link: ${data.qurekaId}');
        Common.Qurekaid = data.qurekaId;
      }
      //Google ads
      if (data.admobId.isNotEmpty) {
        print('Setting banner ad ID: ${data.admobId}');
        Common.bannar_ad_id = data.admobId;
        // Common.bannar_ad_id = "ca-app-pub-3940256099942544/6300978111";
      }
      if (data.admobFull.isNotEmpty) {
        print('Setting interstitial ad ID: ${data.admobFull}');
        Common.interstitial_ad_id = data.admobFull;
        // Common.interstitial_ad_id = "ca-app-pub-3940256099942544/1033173712";
      }
      if (data.admobFull1.isNotEmpty) {
        print('Setting interstitial ad ID1: ${data.admobFull1}');
        Common.interstitial_ad_id1 = data.admobFull1;
        // Common.interstitial_ad_id1 = "ca-app-pub-3940256099942544/1033173712";
      }
      if (data.admobFull2.isNotEmpty) {
        print('Setting interstitial ad ID2: ${data.admobFull2}');
        Common.interstitial_ad_id2 = data.admobFull2;
      }
      if (data.admobNative.isNotEmpty) {
        print('Setting native ad ID: ${data.admobNative}');
        Common.native_ad_id = data.admobNative;
        // Common.native_ad_id = "ca-app-pub-3940256099942544/2247696110";
      }
      if (data.rewardedInt.isNotEmpty) {
        print('Setting app open ad ID: ${data.rewardedInt}');
        Common.app_open_ad_id = data.rewardedInt;
        // Common.app_open_ad_id = "ca-app-pub-3940256099942544/9257395921";
      }
    }

    // Initialize Mobile Ads SDK
    await MobileAds.instance.initialize();

    Common.addOnOff = true;

    if (Common.addOnOff) {
      // Initialize only the necessary ad services
      AdManager().initialize();
      SmallNativeAdService().initialize();
      NativeAdService().initialize();
      _appOpenAdManager.loadAd();
    }
  }

  void _navigateToNextScreen() async {
    final shouldShowIntro = await IntroManager.shouldShowIntro();

    if (shouldShowIntro) {
      // Show intro screens for first time users
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const IntroFlow()),
      );
    } else {
      // Go directly to main app for returning users
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Movienav()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: LinearProgressIndicator(color: Colors.red),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
