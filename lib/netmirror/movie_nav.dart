import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/SmallNativeAdService.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import 'movies_screen.dart';
import 'series_screen.dart';
import 'combined_search_screen.dart';

class Movienav extends StatefulWidget {
  const Movienav({super.key});

  @override
  State<Movienav> createState() => _MovienavState();
}

class _MovienavState extends State<Movienav> {
  late PageController _pageController;
  int _currentIndex = 0;
  var nativeAd = null;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadNativeAd();

    // Periodically check and reload ad if needed
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted && nativeAd == null) {
        _loadNativeAd();
      }
    });
  }

  void _loadNativeAd() {
    // Load native ad with a longer delay to ensure service is ready
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          nativeAd = SmallNativeAdService().getAd();
        });
      }
    });
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CombinedSearchScreen()),
    );
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PopScope(
              canPop: false,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 20,
                backgroundColor: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.exit_to_app,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: Text(
                                'Exit App',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            const Text(
                              'Are you sure you want to exit?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'You will lose your current progress',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 25),

                            // Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey[600]!,
                                      ),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Colors.red, Colors.redAccent],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        SystemNavigator.pop();
                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Exit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const WorkingNativeAdWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ) ??
        false;
  }

  List<Widget> _getPages() {
    return [
      // const AllMoviesScreen(),
      const MoviesScreen(),
      const SeriesScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _showExitDialog();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(height: 10, color: Colors.black),
              Container(
                height: 70,
                color: Colors.black,
                padding: EdgeInsets.all(10),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // All Movies Tab
                      // GestureDetector(
                      //   onTap: () {
                      //     _pageController.animateToPage(
                      //       0,
                      //       duration: const Duration(milliseconds: 300),
                      //       curve: Curves.easeInOut,
                      //     );
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       vertical: 8,
                      //       horizontal: 16,
                      //     ),
                      //     child: Text(
                      //       'All',
                      //       style: TextStyle(
                      //         color: _currentIndex == 0 ? Colors.red : Colors.white,
                      //         fontSize: 18,
                      //         fontWeight: _currentIndex == 0
                      //             ? FontWeight.bold
                      //             : FontWeight.normal,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Movies Tab
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.red,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  0,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentIndex == 0
                                      ? Colors.red
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  'Movies',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: _currentIndex == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                            // Series Tab
                            GestureDetector(
                              onTap: () {
                                _pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentIndex == 1
                                      ? Colors.red
                                      : Colors.black,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  'Series',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: _currentIndex == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      // Search Icon
                      GestureDetector(
                        onTap: _navigateToSearch,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // PageView Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: _getPages(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
