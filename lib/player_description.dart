import 'package:flutter/material.dart';
import 'package:netmirror_flutter/widgets/native_ad_widget.dart';
import 'package:netmirror_flutter/widgets/native_banner_ad_widget.dart';
import 'Utils/common.dart';
import 'main_screen.dart';

class PlayerDescriptionScreen extends StatefulWidget {
  final int playerCount;
  final String selectedDescription;

  const PlayerDescriptionScreen({
    super.key,
    required this.playerCount,
    required this.selectedDescription,
  });

  @override
  State<PlayerDescriptionScreen> createState() =>
      _PlayerDescriptionScreenState();
}

class _PlayerDescriptionScreenState extends State<PlayerDescriptionScreen> {
  void _startGame() {
    if (Common.adsopen == "2") {
      Common.openUrl();
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MainScreen(playerCount: widget.playerCount),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF5F5F5),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Common.Qurekaid.isNotEmpty
                              ? InkWell(
                                  onTap: Common.openUrl,
                                  child: Image(
                                    image: AssetImage(
                                      "assets/images/qurekaads.png",
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image(
                                  image: AssetImage("assets/images/j1.png"),
                                  fit: BoxFit.cover,
                                ),

                          Common.native_ad_id.isNotEmpty
                              ? NativeAdWidget()
                              : Image(
                                  image: AssetImage("assets/images/j1.png"),
                                  fit: BoxFit.cover,
                                ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _startGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF1ab826),
                              foregroundColor: const Color(0xFF1E3A8A),
                              elevation: 8,
                              shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'PLAY NOW',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.selectedDescription,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Stack(
                children: [
                  Common.Qurekaid.isNotEmpty
                      ? InkWell(
                          onTap: Common.openUrl,
                          child: Image(
                            width: MediaQuery.of(context).size.width,
                            image: const AssetImage(
                              "assets/images/bannerads.png",
                            ),
                            fit: BoxFit.fill,
                          ),
                        )
                      : SizedBox(),
                  Common.native_ad_id.isNotEmpty
                      ? NativeBannerAdWidget()
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
