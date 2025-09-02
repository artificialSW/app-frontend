class AppAssets {
  AppAssets._(); // 인스턴스화 방지

  static const logo = 'assets/images/logo.png';
  //사용 예시: Image.asset(AppAssets.logo);
  static const logo_withTypo1 = 'assets/images/logo_withTypo1.png';
  static const logo_withTypo2 = 'assets/images/logo_withTypo2.png';

  static const appicon_whiteBackground = 'assets/images/appicon_whiteBackground.png';
  static const appicon_greenBackground = 'assets/images/appicon_greenBackground.png';


  static const icons  = _Icons();
  static const lottie = _Lottie();
}

class _Icons {
  const _Icons();

  final String home    = 'assets/icons/home.svg';
  final String chat    = 'assets/icons/chat.svg';
  final String profile = 'assets/icons/profile.svg';
}

class _Lottie {
  const _Lottie();

  final String success = 'assets/lottie/success.json';
  final String loading = 'assets/lottie/loading.json';
}
