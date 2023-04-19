import 'dart:io';

class AdHelper {
  
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3752987861100198/1712094426';
    } else if (Platform.isIOS) {
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3752987861100198/5391710325';
    } else if (Platform.isIOS) {
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3752987861100198/5674803434';
    } else if (Platform.isIOS) {
    }
    throw UnsupportedError("Unsupported platform");
  }
}