import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottiePopupManager {
  static final LottiePopupManager _instance = LottiePopupManager._internal();
  factory LottiePopupManager() => _instance;
  LottiePopupManager._internal();

  OverlayEntry? _overlayEntry;

  void showPopup(BuildContext context, String lottieAssetPath) {
    final OverlayState overlayState = Overlay.of(context);
    _overlayEntry?.remove();

    _overlayEntry = OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 150,
            height: 150,
            child: Lottie.asset(
              lottieAssetPath,
              onLoaded: (composition) {},
            ),
          ),
        ),
      ),
    );

    overlayState.insert(_overlayEntry!);
  }

  void hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
