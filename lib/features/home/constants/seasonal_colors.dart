import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

/// 계절별 색상을 관리하는 유틸리티 클래스
class SeasonalColors {
  /// 현재 계절에 따른 배경 그라데이션 색상 반환
  static List<Color> getBackgroundColors() {
    final month = DateTime.now().month;
    
    if (month >= 3 && month <= 5) {
      // 봄 (3-5월)
      return [AppColors.plumu_spring_bg_start, AppColors.plumu_spring_bg_middle, AppColors.plumu_spring_bg_end];
    } else if (month >= 6 && month <= 8) {
      // 여름 (6-8월)
      return [AppColors.plumu_summer_bg_start, AppColors.plumu_summer_bg_middle, AppColors.plumu_summer_bg_end];
    } else if (month >= 9 && month <= 11) {
      // 가을 (9-11월)
      return [AppColors.plumu_fall_bg_start, AppColors.plumu_fall_bg_middle, AppColors.plumu_fall_bg_end];
    } else {
      // 겨울 (12-2월)
      return [AppColors.plumu_winter_bg_start, AppColors.plumu_winter_bg_middle, AppColors.plumu_winter_bg_end];
    }
  }

  /// 현재 계절에 따른 캘린더 원 색상 반환
  static Color getCalendarColor() {
    final month = DateTime.now().month;
    
    if (month >= 3 && month <= 5) {
      return AppColors.plumu_spring_calendar_circle;
    } else if (month >= 6 && month <= 8) {
      return AppColors.plumu_summer_calendar_circle;
    } else if (month >= 9 && month <= 11) {
      return AppColors.plumu_fall_calendar_circle;
    } else {
      return AppColors.plumu_winter_calendar_circle;
    }
  }

  /// 현재 계절에 따른 바 그라데이션 색상 반환
  static List<Color> getBarColors() {
    final month = DateTime.now().month;
    
    if (month >= 3 && month <= 5) {
      return [AppColors.plumu_spring_bar_start, AppColors.plumu_spring_bar_end];
    } else if (month >= 6 && month <= 8) {
      return [AppColors.plumu_summer_bar_start, AppColors.plumu_summer_bar_end];
    } else if (month >= 9 && month <= 11) {
      return [AppColors.plumu_fall_bar_start, AppColors.plumu_fall_bar_end];
    } else {
      return [AppColors.plumu_winter_bar_start, AppColors.plumu_winter_bar_end];
    }
  }

}

