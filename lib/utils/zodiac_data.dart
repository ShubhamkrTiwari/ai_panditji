import 'package:flutter/material.dart';
import '../models/horoscope_model.dart';

class ZodiacData {
  static final List<ZodiacSign> zodiacSigns = [
    ZodiacSign(
      name: 'Aries',
      hindiName: 'मेष',
      symbol: '♈',
      dateRange: '21 मार्च - 19 अप्रैल',
      element: 'अग्नि',
      planet: 'मंगल',
      color: 0xFFFF6B6B,
    ),
    ZodiacSign(
      name: 'Taurus',
      hindiName: 'वृषभ',
      symbol: '♉',
      dateRange: '20 अप्रैल - 20 मई',
      element: 'पृथ्वी',
      planet: 'शुक्र',
      color: 0xFFFFD93D,
    ),
    ZodiacSign(
      name: 'Gemini',
      hindiName: 'मिथुन',
      symbol: '♊',
      dateRange: '21 मई - 20 जून',
      element: 'वायु',
      planet: 'बुध',
      color: 0xFF6BCF7F,
    ),
    ZodiacSign(
      name: 'Cancer',
      hindiName: 'कर्क',
      symbol: '♋',
      dateRange: '21 जून - 22 जुलाई',
      element: 'जल',
      planet: 'चंद्रमा',
      color: 0xFF4ECDC4,
    ),
    ZodiacSign(
      name: 'Leo',
      hindiName: 'सिंह',
      symbol: '♌',
      dateRange: '23 जुलाई - 22 अगस्त',
      element: 'अग्नि',
      planet: 'सूर्य',
      color: 0xFFFFB347,
    ),
    ZodiacSign(
      name: 'Virgo',
      hindiName: 'कन्या',
      symbol: '♍',
      dateRange: '23 अगस्त - 22 सितंबर',
      element: 'पृथ्वी',
      planet: 'बुध',
      color: 0xFF95E1D3,
    ),
    ZodiacSign(
      name: 'Libra',
      hindiName: 'तुला',
      symbol: '♎',
      dateRange: '23 सितंबर - 22 अक्टूबर',
      element: 'वायु',
      planet: 'शुक्र',
      color: 0xFFF38181,
    ),
    ZodiacSign(
      name: 'Scorpio',
      hindiName: 'वृश्चिक',
      symbol: '♏',
      dateRange: '23 अक्टूबर - 21 नवंबर',
      element: 'जल',
      planet: 'मंगल',
      color: 0xFFAA96DA,
    ),
    ZodiacSign(
      name: 'Sagittarius',
      hindiName: 'धनु',
      symbol: '♐',
      dateRange: '22 नवंबर - 21 दिसंबर',
      element: 'अग्नि',
      planet: 'बृहस्पति',
      color: 0xFFFF8C42,
    ),
    ZodiacSign(
      name: 'Capricorn',
      hindiName: 'मकर',
      symbol: '♑',
      dateRange: '22 दिसंबर - 19 जनवरी',
      element: 'पृथ्वी',
      planet: 'शनि',
      color: 0xFF6C5CE7,
    ),
    ZodiacSign(
      name: 'Aquarius',
      hindiName: 'कुंभ',
      symbol: '♒',
      dateRange: '20 जनवरी - 18 फरवरी',
      element: 'वायु',
      planet: 'शनि',
      color: 0xFF74B9FF,
    ),
    ZodiacSign(
      name: 'Pisces',
      hindiName: 'मीन',
      symbol: '♓',
      dateRange: '19 फरवरी - 20 मार्च',
      element: 'जल',
      planet: 'बृहस्पति',
      color: 0xFFA29BFE,
    ),
  ];

  static ZodiacSign? getZodiacSign(String name) {
    try {
      return zodiacSigns.firstWhere(
        (sign) => sign.name.toLowerCase() == name.toLowerCase() ||
            sign.hindiName == name,
      );
    } catch (e) {
      return null;
    }
  }

  static ZodiacSign? getZodiacByDate(DateTime date) {
    final month = date.month;
    final day = date.day;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return zodiacSigns[0]; // Aries
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return zodiacSigns[1]; // Taurus
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return zodiacSigns[2]; // Gemini
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return zodiacSigns[3]; // Cancer
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return zodiacSigns[4]; // Leo
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return zodiacSigns[5]; // Virgo
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return zodiacSigns[6]; // Libra
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return zodiacSigns[7]; // Scorpio
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return zodiacSigns[8]; // Sagittarius
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return zodiacSigns[9]; // Capricorn
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return zodiacSigns[10]; // Aquarius
    } else {
      return zodiacSigns[11]; // Pisces
    }
  }
}

