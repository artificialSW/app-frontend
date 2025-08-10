class AppAssets {
  AppAssets._(); // 인스턴스화 방지

  static const logo = 'assets/images/logo.png';
  //사용 예시: Image.asset(AppAssets.logo);

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
