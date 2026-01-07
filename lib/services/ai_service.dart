import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  // Note: Replace with your actual API key
  static const String _geminiApiKey = 'YOUR_GEMINI_API_KEY';
  
  // Fallback: You can use OpenAI or any other AI service
  static const String _openAiApiKey = 'YOUR_OPENAI_API_KEY';
  static const String _openAiBaseUrl = 'https://api.openai.com/v1/chat/completions';

  // Generate horoscope using AI
  static Future<String> generateHoroscope({
    required String zodiacSign,
    required String hindiName,
    String? date,
  }) async {
    try {
      // Try Gemini first
      if (_geminiApiKey != 'YOUR_GEMINI_API_KEY') {
        return await _generateWithGemini(zodiacSign, hindiName, date);
      }
      
      // Fallback to OpenAI or local generation
      return await _generateLocalHoroscope(zodiacSign, hindiName);
    } catch (e) {
      return _generateLocalHoroscope(zodiacSign, hindiName);
    }
  }

  static Future<String> _generateWithGemini(
    String zodiacSign,
    String hindiName,
    String? date,
  ) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _geminiApiKey,
    );

    final prompt = '''
आप एक अनुभवी ज्योतिषी हैं। $hindiName ($zodiacSign) राशि के लिए आज का विस्तृत होरोस्कॉप बनाएं।
${date != null ? 'तारीख: $date' : ''}

कृपया निम्नलिखित शामिल करें:
1. दैनिक भविष्यवाणी (2-3 वाक्य)
2. कैरियर और व्यापार
3. प्रेम और रिश्ते
4. स्वास्थ्य
5. भाग्यशाली संख्या, रंग और समय

उत्तर हिंदी में दें और सकारात्मक और प्रेरणादायक बनाएं।
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text;
    if (text != null && text is String) {
      return text;
    }
    return _generateLocalHoroscope(zodiacSign, hindiName);
  }

  static Future<String> _generateLocalHoroscope(
    String zodiacSign,
    String hindiName,
  ) async {
    // Local fallback horoscope templates
    final templates = {
      'Aries': '''
आज का दिन आपके लिए बहुत शुभ है। कार्यक्षेत्र में नई संभावनाएं दिखाई देंगी। 
प्रेम जीवन में सुखद बदलाव आएंगे। स्वास्थ्य अच्छा रहेगा। 
भाग्यशाली संख्या: 9, रंग: लाल, समय: सुबह 9-11 बजे।
''',
      'Taurus': '''
आज आपको धैर्य रखने की आवश्यकता है। वित्तीय मामलों में सावधानी बरतें। 
रिश्तों में संवाद महत्वपूर्ण होगा। स्वास्थ्य का ध्यान रखें।
भाग्यशाली संख्या: 6, रंग: हरा, समय: दोपहर 2-4 बजे।
''',
      'Gemini': '''
आज का दिन आपके लिए रचनात्मक है। नए विचारों पर काम करें। 
सामाजिक गतिविधियों में भाग लें। स्वास्थ्य सामान्य रहेगा।
भाग्यशाली संख्या: 5, रंग: पीला, समय: शाम 5-7 बजे।
''',
      'Cancer': '''
आज पारिवारिक मामलों पर ध्यान दें। भावनात्मक संतुलन बनाए रखें।
कार्यक्षेत्र में सहयोग मिलेगा। स्वास्थ्य अच्छा रहेगा।
भाग्यशाली संख्या: 2, रंग: सफेद, समय: रात 8-10 बजे।
''',
      'Leo': '''
आज आपका दिन चमकदार रहेगा। नेतृत्व क्षमता का प्रदर्शन करें।
प्रेम जीवन में खुशियां मिलेंगी। स्वास्थ्य उत्तम रहेगा।
भाग्यशाली संख्या: 1, रंग: सुनहरा, समय: सुबह 7-9 बजे।
''',
      'Virgo': '''
आज विस्तार पर ध्यान दें। छोटी-छोटी बातों को नजरअंदाज न करें।
स्वास्थ्य का विशेष ध्यान रखें। कार्यक्षेत्र में सफलता मिलेगी।
भाग्यशाली संख्या: 5, रंग: नीला, समय: दोपहर 12-2 बजे।
''',
      'Libra': '''
आज संतुलन बनाए रखें। निर्णय लेने में जल्दबाजी न करें।
रिश्तों में सामंजस्य बढ़ेगा। स्वास्थ्य अच्छा रहेगा।
भाग्यशाली संख्या: 6, रंग: गुलाबी, समय: शाम 4-6 बजे।
''',
      'Scorpio': '''
आज गहरी सोच की आवश्यकता है। रहस्यमयी ऊर्जा का उपयोग करें।
वित्तीय मामलों में सावधानी बरतें। स्वास्थ्य सामान्य रहेगा।
भाग्यशाली संख्या: 8, रंग: काला, समय: रात 9-11 बजे।
''',
      'Sagittarius': '''
आज यात्रा और साहसिक कार्यों के लिए अच्छा दिन है।
नए अनुभवों से सीखें। स्वास्थ्य उत्तम रहेगा।
भाग्यशाली संख्या: 3, रंग: नारंगी, समय: सुबह 10-12 बजे।
''',
      'Capricorn': '''
आज मेहनत का फल मिलेगा। लक्ष्यों पर केंद्रित रहें।
वित्तीय स्थिति में सुधार होगा। स्वास्थ्य अच्छा रहेगा।
भाग्यशाली संख्या: 4, रंग: भूरा, समय: दोपहर 1-3 बजे।
''',
      'Aquarius': '''
आज नवाचार और मौलिकता पर ध्यान दें। नए विचारों को आगे बढ़ाएं।
सामाजिक कार्यों में भाग लें। स्वास्थ्य सामान्य रहेगा।
भाग्यशाली संख्या: 11, रंग: नीला, समय: शाम 6-8 बजे।
''',
      'Pisces': '''
आज भावनात्मक संवेदनशीलता बढ़ेगी। कलात्मक कार्यों में रुचि लें।
आध्यात्मिक गतिविधियों में भाग लें। स्वास्थ्य अच्छा रहेगा।
भाग्यशाली संख्या: 7, रंग: समुद्री नीला, समय: रात 7-9 बजे।
''',
    };

    return templates[zodiacSign] ?? 'आज का दिन सामान्य रहेगा। सकारात्मक सोच बनाए रखें।';
  }

  // Chat with AI Pandit Ji
  static Future<String> chatWithAI(String userMessage) async {
    try {
      if (_geminiApiKey != 'YOUR_GEMINI_API_KEY') {
        return await _chatWithGemini(userMessage);
      }
      return await _chatLocalResponse(userMessage);
    } catch (e) {
      return _chatLocalResponse(userMessage);
    }
  }

  static Future<String> _chatWithGemini(String userMessage) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _geminiApiKey,
    );

    final prompt = '''
आप एक अनुभवी ज्योतिषी और आध्यात्मिक गुरु हैं। आपका नाम पंडित जी है।
आप हिंदी में बात करते हैं और ज्योतिष, वास्तु, रत्न, मंत्र, और आध्यात्मिकता के बारे में ज्ञान देते हैं।

उपयोगकर्ता का प्रश्न: $userMessage

कृपया उपयोगी, सकारात्मक और आध्यात्मिक जवाब दें।
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text;
    if (text != null && text is String) {
      return text;
    }
    return _chatLocalResponse(userMessage);
  }

  static Future<String> _chatLocalResponse(String userMessage) async {
    // Simple keyword-based responses
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('नमस्ते') || lowerMessage.contains('hello')) {
      return 'नमस्ते! मैं पंडित जी हूं। आपकी कैसे सहायता कर सकता हूं?';
    } else if (lowerMessage.contains('होरोस्कॉप') || lowerMessage.contains('horoscope')) {
      return 'होरोस्कॉप के लिए कृपया अपनी राशि चुनें। मैं आपको दैनिक, साप्ताहिक और मासिक भविष्यवाणी दे सकता हूं।';
    } else if (lowerMessage.contains('कुंडली') || lowerMessage.contains('kundli')) {
      return 'कुंडली बनाने के लिए आपको जन्म तिथि, समय और स्थान की आवश्यकता होगी। कृपया ये जानकारी प्रदान करें।';
    } else if (lowerMessage.contains('मिलान') || lowerMessage.contains('compatibility')) {
      return 'राशि मिलान के लिए दोनों व्यक्तियों की राशि जानना आवश्यक है। कृपया राशियां बताएं।';
    } else {
      return 'धन्यवाद! आपके प्रश्न के लिए, कृपया होरोस्कॉप, कुंडली, या राशि मिलान सेक्शन में जाएं। मैं आपकी और सहायता कर सकता हूं।';
    }
  }

  // Generate compatibility analysis
  static Future<String> generateCompatibility(
    String sign1,
    String sign2,
  ) async {
    try {
      if (_geminiApiKey != 'YOUR_GEMINI_API_KEY') {
        return await _generateCompatibilityWithGemini(sign1, sign2);
      }
      return _generateLocalCompatibility(sign1, sign2);
    } catch (e) {
      return _generateLocalCompatibility(sign1, sign2);
    }
  }

  static Future<String> _generateCompatibilityWithGemini(
    String sign1,
    String sign2,
  ) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _geminiApiKey,
    );

    final prompt = '''
$sign1 और $sign2 राशि की जोड़ी की विस्तृत राशि मिलान रिपोर्ट बनाएं।
कृपया निम्नलिखित शामिल करें:
1. समग्र मिलान प्रतिशत
2. प्रेम और रिश्ते
3. विवाह संगतता
4. व्यापार साझेदारी
5. सुझाव और उपाय

उत्तर हिंदी में दें।
''';

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text;
    if (text != null && text is String) {
      return text;
    }
    return _generateLocalCompatibility(sign1, sign2);
  }

  static String _generateLocalCompatibility(String sign1, String sign2) {
    return '''
$sign1 और $sign2 राशि की मिलान रिपोर्ट:

समग्र मिलान: 75%
प्रेम संगतता: अच्छी
विवाह संगतता: मध्यम
व्यापार साझेदारी: उत्तम

सुझाव: दोनों राशियों के बीच संवाद और समझदारी बनाए रखें। 
किसी भी मतभेद को बातचीत से सुलझाएं।
''';
  }
}

