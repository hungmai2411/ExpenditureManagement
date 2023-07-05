import 'dart:io' show Platform;
import 'package:expenditure_management/setting/bloc/setting_state.dart';
import 'package:flutter/material.dart' show Locale;
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingCubit extends Cubit<SettingState> {
  int? language;
  bool isDark;

  SettingCubit({this.language, required this.isDark})
      : super(
          SettingChange(
            _getLocal(language),
            isDark,
          ),
        );

  static Locale _getLocal(int? lang) {
    if (lang == null) {
      String defaultLocale = Platform.localeName.split('_')[0];
      switch (defaultLocale) {
        case 'vi':
          return const Locale('vi');
        case 'ru':
          return const Locale('ru');
        case 'ko':
          return const Locale('ko');
        case 'ja':
          return const Locale('ja');
        default:
          return const Locale('en');
      }
    } else {
      return lang == 0 ? const Locale('vi') : const Locale('en');
    }
  }

  void toVietnamese() {
    language = 0;
    emit(SettingChange(const Locale('vi'), isDark));
  }

  void toEnglish() {
    language = 1;
    emit(SettingChange(const Locale('en'), isDark));
  }

  void toRussian() {
    language = 2;
    emit(SettingChange(const Locale('ru'), isDark));
  }

  void toKorea() {
    language = 3;
    emit(SettingChange(const Locale('ko'), isDark));
  }

  void toJapanese() {
    language = 4;
    emit(SettingChange(const Locale('ja'), isDark));
  }

  void changeTheme() {
    Locale locale = _getLocal(language);
    isDark = !isDark;
    emit(SettingChange(locale, isDark));
  }
}
