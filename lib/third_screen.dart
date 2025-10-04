import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netmirror_flutter/player_selection_screen.dart';
import 'package:netmirror_flutter/privacy_policy_screen.dart';
import 'package:netmirror_flutter/share_service.dart';
import 'package:netmirror_flutter/widgets/native_ad_widget.dart';
import 'package:netmirror_flutter/widgets/native_banner_ad_widget.dart';

import 'Utils/common.dart';
import 'feedback_service.dart';
import 'game/game_screen.dart';
import 'netmirror/movielist_screen.dart';

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showMenuPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Menu Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Menu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                // Menu Items
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Rate Us
                      _buildPopupMenuItem(
                        context,
                        icon: Icons.star,
                        title: 'Rate Us',
                        subtitle: 'Rate our app on Play Store',
                        onTap: () {
                          Navigator.of(context).pop();
                          FeedbackService.openPlayStoreFeedback();
                        },
                      ),
                      const SizedBox(height: 10),
                      // Share
                      _buildPopupMenuItem(
                        context,
                        icon: Icons.share,
                        title: 'Share',
                        subtitle: 'Share app with friends',
                        onTap: () {
                          Navigator.of(context).pop();
                          ShareService.shareAppOnSocialMedia();
                        },
                      ),
                      const SizedBox(height: 10),
                      // Privacy Policy
                      _buildPopupMenuItem(
                        context,
                        icon: Icons.privacy_tip,
                        title: 'Privacy Policy',
                        subtitle: 'View our privacy policy',
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      // Exit
                      _buildPopupMenuItem(
                        context,
                        icon: Icons.exit_to_app,
                        title: 'Exit',
                        subtitle: 'Close the application',
                        onTap: () {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Exit App'),
                                content: const Text(
                                  'Are you sure you want to exit?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      SystemNavigator.pop();
                                    },
                                    child: const Text('Exit'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    color: Colors.yellow,
                    child: Row(
                      children: [
                        const Spacer(),
                        const Text(
                          'Movies show and Game',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            _showMenuPopup(context);
                          },
                          child: const Icon(
                            Icons.settings,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ),
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
                                          "assets/images/qurekaads3.png",
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
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              if (Common.adsopen == "1" ||
                                  Common.adsopen == "2") {
                                Common.openUrl();
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const GameScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1E3A8A),
                                    Color(0xFF3B82F6),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.games,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'All Category Game',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Common.qureka_game_show.isNotEmpty
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (Common.adsopen == "1" ||
                                            Common.adsopen == "2") {
                                          Common.openUrl();
                                        }
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PlayerSelectionScreen(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 60,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF1E3A8A),
                                              Color(0xFF3B82F6),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.games,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              'Ludo Game',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )
                              : SizedBox(),
                          SizedBox(height: 10),
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
        ),
      ),
    );
  }
}
