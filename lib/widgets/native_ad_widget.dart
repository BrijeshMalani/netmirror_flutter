import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../Utils/common.dart';

class NativeAdWidget extends StatefulWidget {
  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget>
    with WidgetsBindingObserver {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;
  int _retryCount = 0;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadNativeAd();
    _startPeriodicRefresh();
  }

  void _loadNativeAd() {
    _nativeAd?.dispose();
    _nativeAd = NativeAd(
      adUnitId: Common.native_ad_id,
      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          _retryCount = 0;
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('NativeAd load failed: $error');
          ad.dispose();
          if (!mounted) return;

          // Check for rate limiting error (code 1)
          if (error.code == 1) {
            // Wait longer for rate limiting
            final int delayMs = 30000; // 30 seconds
            Future.delayed(Duration(milliseconds: delayMs), () {
              if (mounted && !_isAdLoaded) {
                _loadNativeAd();
              }
            });
          } else {
            // Exponential backoff for other errors
            if (_retryCount < 3) {
              final int delayMs =
                  (1 << _retryCount) * 5000; // Start with 5s, then 10s, 20s
              _retryCount++;
              Future.delayed(Duration(milliseconds: delayMs), () {
                if (mounted && !_isAdLoaded) {
                  _loadNativeAd();
                }
              });
            }
          }
        },
      ),
    )..load();
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 120), (_) {
      if (!mounted) return;
      _loadNativeAd();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadNativeAd();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return _isAdLoaded && _nativeAd != null
        ? Container(
            width: width,
            height: 270,
            alignment: Alignment.center,
            child: AdWidget(ad: _nativeAd!),
          )
        : SizedBox();
  }
}
