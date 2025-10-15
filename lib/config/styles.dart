import 'package:flutter/material.dart';
import 'package:webinar/common/data/app_language.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/locator.dart';

TextStyle style48Bold() {
  return TextStyle(
    fontFamily: !locator<AppLanguage>().isRtl() ? 'Urbanist-Bold' : 'Urbanist-Bold',
    color: grey33,
    fontSize: 48
  );
}

TextStyle style48Regular() {
  return TextStyle(
      fontFamily: !locator<AppLanguage>().isRtl() ? 'Urbanist-Regular' : 'Urbanist-Regular',
      color: grey33,
      fontSize: 48
  );
}
TextStyle style24Bold() => style48Bold().copyWith(fontSize: 24);
TextStyle style22Bold() => style48Bold().copyWith(fontSize: 22);
TextStyle style20Bold() => style48Bold().copyWith(fontSize: 20);
TextStyle style18Bold() => style48Bold().copyWith(fontSize: 18);
TextStyle style16Bold() => style48Bold().copyWith(fontSize: 16);
TextStyle style14Bold() => style48Bold().copyWith(fontSize: 14);
TextStyle style12Bold() => style48Bold().copyWith(fontSize: 12);

TextStyle style20Regular() => style48Regular().copyWith(fontSize: 18);

TextStyle style16Regular() {
  return TextStyle(
    fontFamily: !locator<AppLanguage>().isRtl() ? 'Urbanist-Regular' : 'Urbanist-Regular',
    color: grey33,
    fontSize: 16
  );
}
TextStyle style14Regular() => style16Regular().copyWith(fontSize: 14);
TextStyle style12Regular() => style16Regular().copyWith(fontSize: 12);
TextStyle style10Regular() => style16Regular().copyWith(fontSize: 10);

TextStyle style20Medium() => style48Bold().copyWith(fontSize: 20, fontWeight: FontWeight.w500);
TextStyle style18Medium() => style48Bold().copyWith(fontSize: 18, fontWeight: FontWeight.w500);
TextStyle style16Medium() => style48Bold().copyWith(fontSize: 16, fontWeight: FontWeight.w500);
TextStyle style14Medium() => style48Bold().copyWith(fontSize: 14, fontWeight: FontWeight.w500);
TextStyle style12Medium() => style48Bold().copyWith(fontSize: 12, fontWeight: FontWeight.w500);


