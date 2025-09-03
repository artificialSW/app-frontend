import 'package:flutter/material.dart';

//하면서 그때그때 추가하기

class AppTextStyles {
  static const plumu = TextStyle(fontSize: 18.95, fontFamily: 'plumu', height: 1.2);

  static const pretendard_bold = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w700);
  ///사용 예시: Text() 안에 "style: AppTextStyles.pretendard_bold.copyWith(fontSize: 20)" 삽입하기
  static const pretendard_medium = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500);
  static const pretendard_regular = TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w400);
}