class HoroscopeModel {
  final String sign;
  final String date;
  final String horoscope;
  final String luckyNumber;
  final String luckyColor;
  final String luckyTime;
  final String mood;
  final String compatibility;

  HoroscopeModel({
    required this.sign,
    required this.date,
    required this.horoscope,
    required this.luckyNumber,
    required this.luckyColor,
    required this.luckyTime,
    required this.mood,
    required this.compatibility,
  });

  factory HoroscopeModel.fromJson(Map<String, dynamic> json) {
    return HoroscopeModel(
      sign: json['sign'] ?? '',
      date: json['date'] ?? '',
      horoscope: json['horoscope'] ?? '',
      luckyNumber: json['luckyNumber'] ?? '',
      luckyColor: json['luckyColor'] ?? '',
      luckyTime: json['luckyTime'] ?? '',
      mood: json['mood'] ?? '',
      compatibility: json['compatibility'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sign': sign,
      'date': date,
      'horoscope': horoscope,
      'luckyNumber': luckyNumber,
      'luckyColor': luckyColor,
      'luckyTime': luckyTime,
      'mood': mood,
      'compatibility': compatibility,
    };
  }
}

class ZodiacSign {
  final String name;
  final String hindiName;
  final String symbol;
  final String dateRange;
  final String element;
  final String planet;
  final int color;
  final String? imageUrl;

  ZodiacSign({
    required this.name,
    required this.hindiName,
    required this.symbol,
    required this.dateRange,
    required this.element,
    required this.planet,
    required this.color,
    this.imageUrl,
  });
}

class BirthChart {
  final String name;
  final DateTime birthDate;
  final String birthTime;
  final String birthPlace;
  final String zodiacSign;
  final String moonSign;
  final String risingSign;

  BirthChart({
    required this.name,
    required this.birthDate,
    required this.birthTime,
    required this.birthPlace,
    required this.zodiacSign,
    required this.moonSign,
    required this.risingSign,
  });
}

