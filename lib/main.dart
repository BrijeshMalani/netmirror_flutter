import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:netmirror_flutter/services/api_service.dart';
import 'package:netmirror_flutter/splash_screen.dart';
import 'package:provider/provider.dart';
import 'Utils/common.dart';
import 'ludo_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      print('qureka game layout: ${data.gamezopId}');
      Common.qureka_game_show = data.gamezopId;
    }
    if (data.rewardedFull1.isNotEmpty) {
      print('Ads Open Count: ${data.rewardedFull1}');
      Common.ads_open_count = data.rewardedFull1;
    }
    if (data.startAppRewarded.isNotEmpty) {
      print('Ads open area: ${data.startAppRewarded}');
      Common.adsopen = data.startAppRewarded;
    }

    if (data.qurekaId.isNotEmpty) {
      print('qureka link: ${data.qurekaId}');
      Common.Qurekaid = data.qurekaId;
    }

    if (data.admobId.isNotEmpty) {
      print('Setting banner ad ID: ${data.admobId}');
      Common.bannar_ad_id = data.admobId;
    }
    if (data.admobFull.isNotEmpty) {
      print('Setting interstitial ad ID: ${data.admobFull}');
      Common.interstitial_ad_id = data.admobFull;
    }
    if (data.admobNative.isNotEmpty) {
      print('Setting native ad ID: ${data.admobNative}');
      Common.native_ad_id = data.admobNative;
    }
    if (data.rewardedInt.isNotEmpty) {
      print('Setting app open ad ID: ${data.rewardedInt}');
      Common.app_open_ad_id = data.rewardedInt;
    }
  }

  return runApp(
    ChangeNotifierProvider(
      create: (_) => LudoProvider()..startGame(playerCount: 4),
      child: const Root(),
    ),
  );
}

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    ///Initialize images and precache it
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.wait([
        precacheImage(const AssetImage("assets/images/splash.png"), context),
        precacheImage(const AssetImage("assets/images/thankyou.gif"), context),
        precacheImage(const AssetImage("assets/images/board.png"), context),
        precacheImage(const AssetImage("assets/images/dice/1.png"), context),
        precacheImage(const AssetImage("assets/images/dice/2.png"), context),
        precacheImage(const AssetImage("assets/images/dice/3.png"), context),
        precacheImage(const AssetImage("assets/images/dice/4.png"), context),
        precacheImage(const AssetImage("assets/images/dice/5.png"), context),
        precacheImage(const AssetImage("assets/images/dice/6.png"), context),
        precacheImage(const AssetImage("assets/images/dice/draw.gif"), context),
        precacheImage(const AssetImage("assets/images/crown/1st.png"), context),
        precacheImage(const AssetImage("assets/images/crown/2nd.png"), context),
        precacheImage(const AssetImage("assets/images/crown/3rd.png"), context),
        precacheImage(const AssetImage("assets/images/bannerads.png"), context),
        precacheImage(
          const AssetImage("assets/images/letsgo.png.png"),
          context,
        ),
        precacheImage(const AssetImage("assets/images/qurekaads.png"), context),
        precacheImage(
          const AssetImage("assets/images/qurekaads2.png"),
          context,
        ),
      ]);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
