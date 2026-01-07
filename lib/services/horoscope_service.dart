import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/horoscope_model.dart';
import '../utils/zodiac_data.dart';
import 'ai_service.dart';

class HoroscopeService {
  static final HoroscopeService _instance = HoroscopeService._internal();
  factory HoroscopeService() => _instance;
  HoroscopeService._internal();

  // Cache for horoscopes
  final Map<String, HoroscopeModel> _cache = {};

  // Get daily horoscope
  Future<HoroscopeModel> getDailyHoroscope(String zodiacSign) async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final cacheKey = '$zodiacSign-$today';

    // Check cache
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      // Get zodiac sign data
      final signData = ZodiacData.getZodiacSign(zodiacSign);
      if (signData == null) {
        throw Exception('Invalid zodiac sign');
      }

      // Generate horoscope using AI
      final horoscopeText = await AIService.generateHoroscope(
        zodiacSign: signData.name,
        hindiName: signData.hindiName,
        date: today,
      );

      // Extract lucky numbers, colors, etc. from text or generate separately
      final luckyNumber = _extractLuckyNumber(horoscopeText) ?? 
          _generateLuckyNumber(signData.name);
      final luckyColor = _extractLuckyColor(horoscopeText) ?? 
          _generateLuckyColor(signData.name);
      final luckyTime = _extractLuckyTime(horoscopeText) ?? 
          _generateLuckyTime();
      final mood = _extractMood(horoscopeText) ?? 'सकारात्मक';
      final compatibility = _generateCompatibility(signData.name);

      final horoscope = HoroscopeModel(
        sign: signData.hindiName,
        date: today,
        horoscope: horoscopeText,
        luckyNumber: luckyNumber,
        luckyColor: luckyColor,
        luckyTime: luckyTime,
        mood: mood,
        compatibility: compatibility,
      );

      // Cache the result
      _cache[cacheKey] = horoscope;
      return horoscope;
    } catch (e) {
      // Return default horoscope on error
      return _getDefaultHoroscope(zodiacSign);
    }
  }

  // Get horoscope for all signs
  Future<List<HoroscopeModel>> getAllHoroscopes() async {
    final List<HoroscopeModel> horoscopes = [];
    
    for (final sign in ZodiacData.zodiacSigns) {
      try {
        final horoscope = await getDailyHoroscope(sign.name);
        horoscopes.add(horoscope);
      } catch (e) {
        // Continue with other signs
      }
    }
    
    return horoscopes;
  }

  // Helper methods
  String? _extractLuckyNumber(String text) {
    final regex = RegExp(r'संख्या[:\s]*(\d+)');
    final match = regex.firstMatch(text);
    return match?.group(1);
  }

  String? _extractLuckyColor(String text) {
    final colors = ['लाल', 'हरा', 'पीला', 'नीला', 'सफेद', 'काला', 'गुलाबी', 
                    'सुनहरा', 'नारंगी', 'भूरा', 'समुद्री नीला'];
    for (final color in colors) {
      if (text.contains(color)) {
        return color;
      }
    }
    return null;
  }

  String? _extractLuckyTime(String text) {
    final regex = RegExp(r'समय[:\s]*([\d-]+)');
    final match = regex.firstMatch(text);
    return match?.group(1);
  }

  String? _extractMood(String text) {
    if (text.contains('शुभ') || text.contains('अच्छा') || text.contains('उत्तम')) {
      return 'सकारात्मक';
    } else if (text.contains('सामान्य')) {
      return 'सामान्य';
    }
    return null;
  }

  String _generateLuckyNumber(String sign) {
    final numbers = {
      'Aries': '9',
      'Taurus': '6',
      'Gemini': '5',
      'Cancer': '2',
      'Leo': '1',
      'Virgo': '5',
      'Libra': '6',
      'Scorpio': '8',
      'Sagittarius': '3',
      'Capricorn': '4',
      'Aquarius': '11',
      'Pisces': '7',
    };
    return numbers[sign] ?? '7';
  }

  String _generateLuckyColor(String sign) {
    final colors = {
      'Aries': 'लाल',
      'Taurus': 'हरा',
      'Gemini': 'पीला',
      'Cancer': 'सफेद',
      'Leo': 'सुनहरा',
      'Virgo': 'नीला',
      'Libra': 'गुलाबी',
      'Scorpio': 'काला',
      'Sagittarius': 'नारंगी',
      'Capricorn': 'भूरा',
      'Aquarius': 'नीला',
      'Pisces': 'समुद्री नीला',
    };
    return colors[sign] ?? 'सफेद';
  }

  String _generateLuckyTime() {
    final times = [
      'सुबह 7-9 बजे',
      'सुबह 9-11 बजे',
      'दोपहर 12-2 बजे',
      'शाम 4-6 बजे',
      'शाम 6-8 बजे',
      'रात 8-10 बजे',
    ];
    return times[DateTime.now().hour % times.length];
  }

  String _generateCompatibility(String sign) {
    final compatibilities = {
      'Aries': 'Leo, Sagittarius',
      'Taurus': 'Virgo, Capricorn',
      'Gemini': 'Libra, Aquarius',
      'Cancer': 'Scorpio, Pisces',
      'Leo': 'Aries, Sagittarius',
      'Virgo': 'Taurus, Capricorn',
      'Libra': 'Gemini, Aquarius',
      'Scorpio': 'Cancer, Pisces',
      'Sagittarius': 'Aries, Leo',
      'Capricorn': 'Taurus, Virgo',
      'Aquarius': 'Gemini, Libra',
      'Pisces': 'Cancer, Scorpio',
    };
    return compatibilities[sign] ?? 'सभी राशियां';
  }

  HoroscopeModel _getDefaultHoroscope(String zodiacSign) {
    final signData = ZodiacData.getZodiacSign(zodiacSign);
    return HoroscopeModel(
      sign: signData?.hindiName ?? zodiacSign,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      horoscope: 'आज का दिन सामान्य रहेगा। सकारात्मक सोच बनाए रखें और कड़ी मेहनत करें।',
      luckyNumber: _generateLuckyNumber(zodiacSign),
      luckyColor: _generateLuckyColor(zodiacSign),
      luckyTime: _generateLuckyTime(),
      mood: 'सकारात्मक',
      compatibility: _generateCompatibility(zodiacSign),
    );
  }
}

