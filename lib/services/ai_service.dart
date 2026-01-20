import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';

class AIService with ChangeNotifier {
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
  static Future<String> chatWithAI(String userMessage, {List<String>? conversationHistory}) async {
    try {
      if (_geminiApiKey != 'YOUR_GEMINI_API_KEY') {
        return await _chatWithGemini(userMessage, conversationHistory);
      }
      return await _chatLocalResponse(userMessage, conversationHistory);
    } catch (e) {
      return _chatLocalResponse(userMessage, conversationHistory);
    }
  }

  // Detect language from user message
  static String _detectLanguage(String message) {
    // Check for Hindi characters (Devanagari script)
    final hindiPattern = RegExp(r'[\u0900-\u097F]');
    if (hindiPattern.hasMatch(message)) {
      return 'hindi';
    }
    
    // Check for English (most common)
    final englishPattern = RegExp(r'[a-zA-Z]');
    if (englishPattern.hasMatch(message)) {
      return 'english';
    }
    
    // Default to Hindi
    return 'hindi';
  }

  static Future<String> _chatWithGemini(String userMessage, List<String>? conversationHistory) async {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _geminiApiKey,
    );

    // Detect user's language
    final userLanguage = _detectLanguage(userMessage);
    
    String context = '';
    if (conversationHistory != null && conversationHistory.isNotEmpty) {
      final contextLabel = userLanguage == 'hindi' ? 'पिछली बातचीत:' : 'Previous conversation:';
      context = '\n\n$contextLabel\n';
      for (int i = 0; i < conversationHistory.length && i < 4; i++) {
        context += '${conversationHistory[i]}\n';
      }
    }

    // Create language-appropriate prompt
    String prompt;
    if (userLanguage == 'hindi') {
      prompt = '''
आप एक अनुभवी ज्योतिषी और आध्यात्मिक गुरु हैं। आपका नाम पंडित जी है।
आप ज्योतिष, वास्तु, रत्न, मंत्र, दोष विश्लेषण, और आध्यात्मिकता के बारे में विस्तृत ज्ञान देते हैं।

**महत्वपूर्ण निर्देश:**
1. उपयोगकर्ता जिस भाषा में प्रश्न पूछे, उसी भाषा में जवाब दें
2. हर प्रश्न का विस्तृत और सटीक जवाब दें
3. पिछली बातचीत का संदर्भ रखें
4. सामान्य जवाब न दें, specific और helpful जवाब दें
5. उदाहरण और व्यावहारिक सुझाव दें
6. सकारात्मक और प्रेरणादायक रहें

$context

उपयोगकर्ता का प्रश्न: $userMessage

कृपया इस प्रश्न का विस्तृत, सटीक और उपयोगी जवाब दें। उपयोगकर्ता की भाषा में ही जवाब दें। सामान्य जवाब न दें।
''';
    } else {
      prompt = '''
You are an experienced astrologer and spiritual guru. Your name is Pandit Ji.
You provide detailed knowledge about astrology, Vastu, gemstones, mantras, dosha analysis, and spirituality.

**Important Instructions:**
1. Respond in the SAME LANGUAGE as the user's question
2. Provide detailed and accurate answers to every question
3. Keep context from previous conversation
4. Don't give generic answers, give specific and helpful answers
5. Provide examples and practical suggestions
6. Be positive and inspiring

$context

User's question: $userMessage

Please provide a detailed, accurate and useful answer to this question. Respond in the SAME LANGUAGE as the user's question. Don't give generic answers.
''';
    }

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text;
    if (text != null && text is String) {
      return text;
    }
    return _chatLocalResponse(userMessage, conversationHistory);
  }

  static Future<String> _chatLocalResponse(String userMessage, List<String>? conversationHistory) async {
    // Detect user's language
    final userLanguage = _detectLanguage(userMessage);
    final lowerMessage = userMessage.toLowerCase().trim();
    final originalMessage = userMessage.trim();
    
    // Extract specific information from the question
    String? extractedRashi;
    
    // Try to extract rashi name from message
    final rashiNames = ['मेष', 'वृषभ', 'मिथुन', 'कर्क', 'सिंह', 'कन्या', 
                        'तुला', 'वृश्चिक', 'धनु', 'मकर', 'कुंभ', 'मीन',
                        'aries', 'taurus', 'gemini', 'cancer', 'leo', 'virgo',
                        'libra', 'scorpio', 'sagittarius', 'capricorn', 'aquarius', 'pisces'];
    
    for (final rashi in rashiNames) {
      if (lowerMessage.contains(rashi.toLowerCase())) {
        extractedRashi = rashi;
        break;
      }
    }
    
    // Detect question type (both Hindi and English)
    final isQuestion = originalMessage.contains('?') || 
                       originalMessage.contains('क्या') ||
                       originalMessage.contains('कैसे') ||
                       originalMessage.contains('कब') ||
                       originalMessage.contains('क्यों') ||
                       originalMessage.contains('कौन') ||
                       lowerMessage.contains('what') ||
                       lowerMessage.contains('how') ||
                       lowerMessage.contains('when') ||
                       lowerMessage.contains('why') ||
                       lowerMessage.contains('who');
    
    // Greetings - respond in user's language
    if (lowerMessage.contains('नमस्ते') || lowerMessage.contains('hello') || 
        lowerMessage.contains('hi') || lowerMessage.contains('namaste')) {
      if (userLanguage == 'hindi') {
        return 'नमस्ते! मैं AI पंडित जी हूं। मैं ज्योतिष, वास्तु, रत्न, मंत्र, दोष विश्लेषण, और आध्यात्मिकता के बारे में आपकी सहायता कर सकता हूं। आप क्या जानना चाहते हैं?';
      } else {
        return 'Hello! I am AI Pandit Ji. I can help you with astrology, Vastu, gemstones, mantras, dosha analysis, and spirituality. What would you like to know?';
      }
    }
    
    // Horoscope questions
    if (lowerMessage.contains('होरोस्कॉप') || lowerMessage.contains('horoscope') ||
        lowerMessage.contains('भविष्यवाणी') || lowerMessage.contains('prediction')) {
      if (userLanguage == 'hindi') {
        return '''होरोस्कॉप आपके जीवन की दिशा और संभावनाओं को दर्शाता है। 

दैनिक होरोस्कॉप आपको बताता है कि आज का दिन आपके लिए कैसा रहेगा - कार्यक्षेत्र, प्रेम जीवन, स्वास्थ्य और वित्तीय स्थिति के बारे में।

साप्ताहिक होरोस्कॉप पूरे सप्ताह की योजना बनाने में मदद करता है।

मासिक होरोस्कॉप महीने भर की प्रमुख घटनाओं और अवसरों के बारे में बताता है।

अपनी राशि के अनुसार होरोस्कॉप देखने के लिए होम स्क्रीन पर अपनी राशि चुनें।''';
      } else {
        return '''Horoscope shows the direction and possibilities of your life.

Daily horoscope tells you how your day will be - about career, love life, health and financial situation.

Weekly horoscope helps in planning the whole week.

Monthly horoscope tells about major events and opportunities throughout the month.

To see horoscope according to your zodiac sign, choose your sign on the home screen.''';
      }
    }
    
    // Kundli questions
    if (lowerMessage.contains('कुंडली') || lowerMessage.contains('kundli') ||
        lowerMessage.contains('जन्म पत्रिका') || lowerMessage.contains('birth chart')) {
      if (userLanguage == 'hindi') {
        return '''कुंडली या जन्म पत्रिका आपके जन्म के समय आकाश में ग्रहों की स्थिति का चित्र है।

कुंडली से आप जान सकते हैं:
• आपकी राशि, नक्षत्र और लग्न
• ग्रहों की स्थिति और उनका प्रभाव
• जीवन के विभिन्न क्षेत्रों में संभावनाएं
• शुभ और अशुभ समय
• उपाय और सुझाव

कुंडली बनाने के लिए आपको जन्म तिथि, जन्म समय और जन्म स्थान की आवश्यकता होती है। 
होम स्क्रीन पर "कुंडली" सेक्शन में जाकर अपनी कुंडली बना सकते हैं।''';
      } else {
        return '''Kundli or birth chart is a picture of the position of planets in the sky at the time of your birth.

From kundli you can know:
• Your zodiac sign, nakshatra and ascendant
• Position of planets and their effects
• Possibilities in different areas of life
• Auspicious and inauspicious times
• Remedies and suggestions

To create kundli, you need birth date, birth time and birth place.
You can create your kundli by going to the "Kundli" section on the home screen.''';
      }
    }
    
    // Compatibility/Matching
    if (lowerMessage.contains('मिलान') || lowerMessage.contains('compatibility') ||
        lowerMessage.contains('संगतता') || lowerMessage.contains('match')) {
      if (userLanguage == 'hindi') {
        return '''राशि मिलान दो व्यक्तियों की राशियों की संगतता जांचता है।

मिलान में देखा जाता है:
• गुण मिलान (36 गुणों का मिलान)
• प्रेम और रिश्ते की संगतता
• विवाह संगतता
• व्यापारिक साझेदारी
• मंगल दोष और अन्य दोष

अच्छा मिलान (30+ गुण) शुभ माना जाता है। 
राशि मिलान के लिए होम स्क्रीन पर "मिलान" सेक्शन में जाएं और दोनों राशियां चुनें।''';
      } else {
        return '''Zodiac matching checks the compatibility of two people's zodiac signs.

Matching looks at:
• Gun Milan (matching of 36 points)
• Love and relationship compatibility
• Marriage compatibility
• Business partnership
• Mangal dosha and other doshas

Good matching (30+ points) is considered auspicious.
For zodiac matching, go to the "Matching" section on the home screen and choose both signs.''';
      }
    }
    
    // Dosha questions
    if (lowerMessage.contains('दोष') || lowerMessage.contains('dosha') ||
        lowerMessage.contains('कालसर्प') || lowerMessage.contains('मंगल') ||
        lowerMessage.contains('पितृ') || lowerMessage.contains('साढ़े साती')) {
      if (userLanguage == 'hindi') {
        return '''दोष ज्योतिष में ग्रहों की अशुभ स्थिति को कहते हैं।

मुख्य दोष:
1. **कालसर्प दोष**: जब सभी ग्रह राहु-केतु के बीच होते हैं
2. **मंगल दोष**: मंगल ग्रह की अशुभ स्थिति
3. **पितृ दोष**: पूर्वजों की असंतुष्टि
4. **साढ़े साती**: शनि का चंद्रमा पर प्रभाव

दोषों के उपाय:
• संबंधित मंत्र का जाप
• दान-पुण्य
• रत्न धारण करना
• पूजा-पाठ
• विशेषज्ञ से सलाह

विस्तृत दोष विश्लेषण के लिए होम स्क्रीन पर "दोष विश्लेषण" सेक्शन देखें।''';
      } else {
        return '''Dosha in astrology refers to inauspicious positions of planets.

Main doshas:
1. **Kalsarpa Dosha**: When all planets are between Rahu-Ketu
2. **Mangal Dosha**: Inauspicious position of Mars planet
3. **Pitra Dosha**: Dissatisfaction of ancestors
4. **Sade Sati**: Saturn's effect on Moon

Remedies for doshas:
• Chant related mantras
• Charity and good deeds
• Wear gemstones
• Worship and prayers
• Consult an expert

For detailed dosha analysis, see the "Dosha Analysis" section on the home screen.''';
      }
    }
    
    // Numerology
    if (lowerMessage.contains('अंक') || lowerMessage.contains('numerology') ||
        lowerMessage.contains('संख्या') || lowerMessage.contains('number')) {
      if (userLanguage == 'hindi') {
        return '''अंक ज्योतिष या न्यूमेरोलॉजी में संख्याओं का महत्व होता है।

मुख्य अंक:
• **जीवन पथ अंक**: जन्म तिथि से निकाला जाता है
• **भाग्य अंक**: नाम से निकाला जाता है
• **सोल अंक**: जन्म तारीख का योग

प्रत्येक अंक (1-9) का अपना अर्थ होता है:
1: नेतृत्व, 2: सहयोग, 3: रचनात्मकता, 4: स्थिरता, 5: स्वतंत्रता
6: परिवार, 7: आध्यात्मिकता, 8: सफलता, 9: मानवता

अपना अंक जानने के लिए होम स्क्रीन पर "अंक ज्योतिष" सेक्शन देखें।''';
      } else {
        return '''Numerology or number astrology has importance of numbers.

Main numbers:
• **Life Path Number**: Calculated from birth date
• **Destiny Number**: Calculated from name
• **Soul Number**: Sum of birth date

Each number (1-9) has its own meaning:
1: Leadership, 2: Cooperation, 3: Creativity, 4: Stability, 5: Freedom
6: Family, 7: Spirituality, 8: Success, 9: Humanity

To know your number, see the "Numerology" section on the home screen.''';
      }
    }
    
    // Gemstone questions
    if (lowerMessage.contains('रत्न') || lowerMessage.contains('gemstone') ||
        lowerMessage.contains('मणि') || lowerMessage.contains('stone')) {
      if (userLanguage == 'hindi') {
        return '''रत्न ग्रहों के प्रभाव को बढ़ाने या कम करने के लिए धारण किए जाते हैं।

मुख्य रत्न:
• **माणिक्य**: सूर्य के लिए (रविवार)
• **मोती**: चंद्रमा के लिए (सोमवार)
• **मूंगा**: मंगल के लिए (मंगलवार)
• **पन्ना**: बुध के लिए (बुधवार)
• **पुखराज**: बृहस्पति के लिए (गुरुवार)
• **हीरा**: शुक्र के लिए (शुक्रवार)
• **नीलम**: शनि के लिए (शनिवार)

रत्न धारण करने से पहले:
• अपनी कुंडली देखें
• विशेषज्ञ से सलाह लें
• शुभ मुहूर्त में धारण करें
• उचित धातु में जड़वाएं

किसी भी रत्न को बिना सलाह के न धारण करें।''';
      } else {
        return '''Gemstones are worn to increase or decrease the effects of planets.

Main gemstones:
• **Ruby**: For Sun (Sunday)
• **Pearl**: For Moon (Monday)
• **Coral**: For Mars (Tuesday)
• **Emerald**: For Mercury (Wednesday)
• **Yellow Sapphire**: For Jupiter (Thursday)
• **Diamond**: For Venus (Friday)
• **Blue Sapphire**: For Saturn (Saturday)

Before wearing gemstones:
• Check your kundli
• Consult an expert
• Wear at auspicious time
• Set in appropriate metal

Do not wear any gemstone without consultation.''';
      }
    }
    
    // Vastu questions
    if (lowerMessage.contains('वास्तु') || lowerMessage.contains('vastu') ||
        lowerMessage.contains('घर') || lowerMessage.contains('home')) {
      if (userLanguage == 'hindi') {
        return '''वास्तु शास्त्र घर और कार्यस्थल की ऊर्जा को सुधारने की विद्या है।

मुख्य वास्तु सिद्धांत:
• **मुख्य द्वार**: पूर्व या उत्तर दिशा में होना चाहिए
• **रसोई**: दक्षिण-पूर्व में होनी चाहिए
• **शयन कक्ष**: दक्षिण-पश्चिम में होना चाहिए
• **पूजा स्थल**: उत्तर-पूर्व में होना चाहिए
• **टॉयलेट**: दक्षिण-पश्चिम में होना चाहिए

वास्तु उपाय:
• मुख्य द्वार पर स्वस्तिक लगाएं
• तुलसी का पौधा लगाएं
• नकारात्मक ऊर्जा वाली चीजें हटाएं
• मिरर का सही स्थान पर उपयोग करें

वास्तु सुधार से सुख, समृद्धि और शांति मिलती है।''';
      } else {
        return '''Vastu Shastra is the science of improving energy of home and workplace.

Main Vastu principles:
• **Main Door**: Should be in East or North direction
• **Kitchen**: Should be in Southeast
• **Bedroom**: Should be in Southwest
• **Prayer Place**: Should be in Northeast
• **Toilet**: Should be in Southwest

Vastu remedies:
• Put Swastik on main door
• Plant Tulsi
• Remove negative energy items
• Use mirror at correct place

Vastu improvement brings happiness, prosperity and peace.''';
      }
    }
    
    // Mantra questions
    if (lowerMessage.contains('मंत्र') || lowerMessage.contains('mantra') ||
        lowerMessage.contains('जाप') || lowerMessage.contains('chant')) {
      if (userLanguage == 'hindi') {
        return '''मंत्र जाप आध्यात्मिक शक्ति बढ़ाने का साधन है।

मुख्य मंत्र:
• **ॐ नमः शिवाय**: शिव जी का मंत्र
• **ॐ नमो भगवते वासुदेवाय**: विष्णु जी का मंत्र
• **ॐ गं गणपतये नमः**: गणेश जी का मंत्र
• **ॐ श्री महालक्ष्म्यै नमः**: लक्ष्मी जी का मंत्र
• **गायत्री मंत्र**: सर्वश्रेष्ठ मंत्र

मंत्र जाप के नियम:
• सुबह स्नान के बाद जाप करें
• शांत स्थान पर बैठें
• माला से जाप करें (108 बार)
• नियमित रूप से जाप करें
• सकारात्मक सोच रखें

मंत्र जाप से मन शांत होता है और सकारात्मक ऊर्जा मिलती है।''';
      } else {
        return '''Mantra chanting is a means to increase spiritual power.

Main mantras:
• **Om Namah Shivaya**: Lord Shiva's mantra
• **Om Namo Bhagavate Vasudevaya**: Lord Vishnu's mantra
• **Om Gam Ganapataye Namah**: Lord Ganesha's mantra
• **Om Shri Mahalakshmyai Namah**: Goddess Lakshmi's mantra
• **Gayatri Mantra**: Best mantra

Rules for mantra chanting:
• Chant after morning bath
• Sit in a quiet place
• Chant with mala (108 times)
• Chant regularly
• Keep positive thoughts

Mantra chanting calms the mind and brings positive energy.''';
      }
    }
    
    // Career/Job questions
    if (lowerMessage.contains('करियर') || lowerMessage.contains('career') ||
        lowerMessage.contains('नौकरी') || lowerMessage.contains('job') ||
        lowerMessage.contains('व्यापार') || lowerMessage.contains('business')) {
      if (userLanguage == 'hindi') {
        return '''ज्योतिष के अनुसार करियर और व्यापार में सफलता के लिए:

**शुभ ग्रह:**
• बृहस्पति: ज्ञान और विवेक
• शुक्र: कला और सौंदर्य
• बुध: व्यापार और संचार
• सूर्य: नेतृत्व और सरकारी नौकरी

**उपाय:**
• अपने ग्रह के अनुसार कार्य करें
• शुभ मुहूर्त में नया काम शुरू करें
• संबंधित रत्न धारण करें
• नियमित पूजा करें

**सुझाव:**
• अपनी कुंडली देखकर सही क्षेत्र चुनें
• ग्रहों की स्थिति के अनुसार समय चुनें
• सकारात्मक सोच रखें

अपनी राशि के अनुसार करियर गाइडेंस के लिए होरोस्कॉप देखें।''';
      } else {
        return '''According to astrology, for success in career and business:

**Auspicious Planets:**
• Jupiter: Knowledge and wisdom
• Venus: Art and beauty
• Mercury: Business and communication
• Sun: Leadership and government job

**Remedies:**
• Work according to your planets
• Start new work at auspicious time
• Wear related gemstones
• Do regular worship

**Suggestions:**
• Choose right field by seeing your kundli
• Choose time according to planet positions
• Keep positive thoughts

See horoscope for career guidance according to your zodiac sign.''';
      }
    }
    
    // Love/Relationship questions
    if (lowerMessage.contains('प्रेम') || lowerMessage.contains('love') ||
        lowerMessage.contains('रिश्ता') || lowerMessage.contains('relationship') ||
        lowerMessage.contains('विवाह') || lowerMessage.contains('marriage')) {
      if (userLanguage == 'hindi') {
        return '''प्रेम और रिश्तों में ज्योतिष की भूमिका:

**राशि अनुसार प्रेम:**
• अग्नि राशि (मेष, सिंह, धनु): जुनूनी और उत्साही
• पृथ्वी राशि (वृषभ, कन्या, मकर): स्थिर और भरोसेमंद
• वायु राशि (मिथुन, तुला, कुंभ): बौद्धिक और संवादप्रिय
• जल राशि (कर्क, वृश्चिक, मीन): भावनात्मक और संवेदनशील

**विवाह के लिए:**
• राशि मिलान जरूरी है
• मंगल दोष की जांच करें
• गुण मिलान देखें (कम से कम 18 गुण)
• शुभ मुहूर्त में विवाह करें

**उपाय:**
• शुक्र ग्रह की पूजा करें
• प्रेम मंत्र का जाप करें
• गुलाबी रंग का उपयोग करें

रिश्तों की संगतता जानने के लिए "मिलान" सेक्शन देखें।''';
      } else {
        return '''Role of astrology in love and relationships:

**Love according to zodiac:**
• Fire signs (Aries, Leo, Sagittarius): Passionate and enthusiastic
• Earth signs (Taurus, Virgo, Capricorn): Stable and trustworthy
• Air signs (Gemini, Libra, Aquarius): Intellectual and communicative
• Water signs (Cancer, Scorpio, Pisces): Emotional and sensitive

**For marriage:**
• Zodiac matching is necessary
• Check for Mangal dosha
• See gun milan (at least 18 points)
• Marry at auspicious time

**Remedies:**
• Worship Venus planet
• Chant love mantras
• Use pink color

See "Matching" section to know relationship compatibility.''';
      }
    }
    
    // Health questions
    if (lowerMessage.contains('स्वास्थ्य') || lowerMessage.contains('health') ||
        lowerMessage.contains('बीमारी') || lowerMessage.contains('disease')) {
      if (userLanguage == 'hindi') {
        return '''ज्योतिष के अनुसार स्वास्थ्य:

**ग्रह और स्वास्थ्य:**
• सूर्य: हृदय, आंखें
• चंद्रमा: मन, रक्त
• मंगल: रक्त, मांसपेशियां
• बुध: तंत्रिका तंत्र
• बृहस्पति: यकृत, पाचन
• शुक्र: गुर्दे, प्रजनन
• शनि: हड्डियां, जोड़

**स्वास्थ्य उपाय:**
• नियमित व्यायाम करें
• संतुलित आहार लें
• योग और ध्यान करें
• शुभ मुहूर्त में उपचार शुरू करें
• संबंधित ग्रह की पूजा करें

**सुझाव:**
• अपनी कुंडली में स्वास्थ्य भाव देखें
• ग्रहों की स्थिति के अनुसार सावधानी बरतें
• नियमित चेकअप करवाएं

स्वास्थ्य संबंधी विस्तृत जानकारी के लिए अपनी कुंडली देखें।''';
      } else {
        return '''Health according to astrology:

**Planets and Health:**
• Sun: Heart, eyes
• Moon: Mind, blood
• Mars: Blood, muscles
• Mercury: Nervous system
• Jupiter: Liver, digestion
• Venus: Kidneys, reproduction
• Saturn: Bones, joints

**Health Remedies:**
• Do regular exercise
• Take balanced diet
• Do yoga and meditation
• Start treatment at auspicious time
• Worship related planet

**Suggestions:**
• See health house in your kundli
• Be careful according to planet positions
• Do regular checkups

See your kundli for detailed health information.''';
      }
    }
    
    // General astrology questions
    if (lowerMessage.contains('ज्योतिष') || lowerMessage.contains('astrology') ||
        lowerMessage.contains('ग्रह') || lowerMessage.contains('planet')) {
      if (userLanguage == 'hindi') {
        return '''ज्योतिष विद्या ग्रहों और नक्षत्रों के प्रभाव का अध्ययन है।

**9 मुख्य ग्रह:**
1. सूर्य - नेतृत्व, आत्मा
2. चंद्रमा - मन, भावनाएं
3. मंगल - ऊर्जा, साहस
4. बुध - बुद्धि, संचार
5. बृहस्पति - ज्ञान, भाग्य
6. शुक्र - प्रेम, सौंदर्य
7. शनि - कर्म, अनुशासन
8. राहु - इच्छाएं, भ्रम
9. केतु - आध्यात्मिकता, मोक्ष

**12 राशियां:**
अग्नि: मेष, सिंह, धनु
पृथ्वी: वृषभ, कन्या, मकर
वायु: मिथुन, तुला, कुंभ
जल: कर्क, वृश्चिक, मीन

ज्योतिष से आप अपने भविष्य, करियर, प्रेम जीवन और स्वास्थ्य के बारे में जान सकते हैं।''';
      } else {
        return '''Astrology is the study of effects of planets and constellations.

**9 Main Planets:**
1. Sun - Leadership, soul
2. Moon - Mind, emotions
3. Mars - Energy, courage
4. Mercury - Intelligence, communication
5. Jupiter - Knowledge, fortune
6. Venus - Love, beauty
7. Saturn - Karma, discipline
8. Rahu - Desires, illusion
9. Ketu - Spirituality, liberation

**12 Zodiac Signs:**
Fire: Aries, Leo, Sagittarius
Earth: Taurus, Virgo, Capricorn
Air: Gemini, Libra, Aquarius
Water: Cancer, Scorpio, Pisces

Through astrology you can know about your future, career, love life and health.''';
      }
    }
    
    // Smart response based on question analysis
    if (isQuestion) {
      // Generate dynamic response based on question content
      String response = _generateSmartResponse(originalMessage, lowerMessage, extractedRashi, userLanguage);
      if (response.isNotEmpty) {
        return response;
      }
    }
    
    // If rashi is mentioned, provide rashi-specific answer
    if (extractedRashi != null) {
      return _getRashiSpecificResponse(extractedRashi, lowerMessage, userLanguage);
    }
    
    // Default response - analyze and provide helpful information
    return _generateContextualResponse(originalMessage, lowerMessage, userLanguage);
  }
  
  static String _generateSmartResponse(String originalMessage, String lowerMessage, String? rashi, String language) {
    // Analyze specific questions and provide targeted answers
    
    // Today's horoscope question
    if ((lowerMessage.contains('आज') || lowerMessage.contains('today')) && 
        (lowerMessage.contains('दिन') || lowerMessage.contains('day') || lowerMessage.contains('होरोस्कॉप') || lowerMessage.contains('horoscope'))) {
      if (rashi != null) {
        if (language == 'hindi') {
          return '${rashi} राशि के लिए आज का दिन सामान्य से अच्छा रहेगा। कार्यक्षेत्र में सफलता मिलेगी। प्रेम जीवन में सुखद बदलाव आ सकते हैं। स्वास्थ्य अच्छा रहेगा। भाग्यशाली संख्या: 7, रंग: नीला।';
        } else {
          return 'Today will be better than normal for ${rashi} sign. Success in career. Pleasant changes in love life. Health will be good. Lucky number: 7, Color: Blue.';
        }
      }
      if (language == 'hindi') {
        return 'आज का दिन आपके लिए शुभ रहेगा। सकारात्मक सोच बनाए रखें। कार्यक्षेत्र में नई संभावनाएं दिखाई दे सकती हैं। अपनी राशि बताएं तो मैं आपको विस्तृत भविष्यवाणी दे सकता हूं।';
      } else {
        return 'Today will be auspicious for you. Keep positive thoughts. New opportunities may appear in career. Tell me your zodiac sign and I can give you detailed predictions.';
      }
    }
    
    // Career question
    if (lowerMessage.contains('करियर') || lowerMessage.contains('नौकरी') || 
        lowerMessage.contains('व्यापार') || lowerMessage.contains('job') || 
        lowerMessage.contains('business') || lowerMessage.contains('career')) {
      if (language == 'hindi') {
        return 'करियर में सफलता के लिए बृहस्पति और शुक्र ग्रह महत्वपूर्ण हैं। अपनी कुंडली में दशम भाव (करियर भाव) देखें। शुभ मुहूर्त में नया काम शुरू करें। पीले रंग का उपयोग करें और बृहस्पति मंत्र का जाप करें।';
      } else {
        return 'For career success, Jupiter and Venus planets are important. Check the 10th house (career house) in your kundli. Start new work at auspicious time. Use yellow color and chant Jupiter mantras.';
      }
    }
    
    // Love/Marriage question
    if (lowerMessage.contains('प्रेम') || lowerMessage.contains('विवाह') || 
        lowerMessage.contains('शादी') || lowerMessage.contains('love') || 
        lowerMessage.contains('marriage')) {
      if (language == 'hindi') {
        return 'प्रेम और विवाह के लिए शुक्र ग्रह महत्वपूर्ण है। शुक्रवार को शुक्र ग्रह की पूजा करें। गुलाबी या सफेद रंग का उपयोग करें। राशि मिलान जरूरी है - कम से कम 18 गुण होने चाहिए। मंगल दोष की जांच करवाएं।';
      } else {
        return 'Venus planet is important for love and marriage. Worship Venus on Friday. Use pink or white color. Zodiac matching is necessary - at least 18 points should match. Check for Mangal dosha.';
      }
    }
    
    // Health question
    if (lowerMessage.contains('स्वास्थ्य') || lowerMessage.contains('बीमारी') || 
        lowerMessage.contains('health') || lowerMessage.contains('disease')) {
      if (language == 'hindi') {
        return 'स्वास्थ्य के लिए चंद्रमा और मंगल ग्रह महत्वपूर्ण हैं। नियमित व्यायाम और योग करें। संतुलित आहार लें। अपनी कुंडली में छठे भाव (स्वास्थ्य भाव) देखें। शनिवार को हनुमान जी की पूजा करें।';
      } else {
        return 'Moon and Mars planets are important for health. Do regular exercise and yoga. Take balanced diet. Check the 6th house (health house) in your kundli. Worship Hanuman ji on Saturday.';
      }
    }
    
    // Money/Finance question
    if (lowerMessage.contains('पैसा') || lowerMessage.contains('धन') || 
        lowerMessage.contains('वित्त') || lowerMessage.contains('money') || 
        lowerMessage.contains('wealth') || lowerMessage.contains('finance')) {
      if (language == 'hindi') {
        return 'धन के लिए बृहस्पति और शुक्र ग्रह महत्वपूर्ण हैं। गुरुवार को लक्ष्मी जी की पूजा करें। पीले या सफेद रंग का उपयोग करें। दक्षिण-पूर्व दिशा में तिजोरी रखें। नियमित दान करें।';
      } else {
        return 'Jupiter and Venus planets are important for wealth. Worship Lakshmi ji on Thursday. Use yellow or white color. Keep safe in southeast direction. Do regular charity.';
      }
    }
    
    return '';
  }
  
  static String _getRashiSpecificResponse(String rashi, String lowerMessage, String language) {
    final rashiInfoHindi = {
      'मेष': 'मेष राशि अग्नि तत्व की है। मंगल ग्रह इसका स्वामी है। आप साहसी, उत्साही और नेतृत्व करने वाले हैं।',
      'वृषभ': 'वृषभ राशि पृथ्वी तत्व की है। शुक्र ग्रह इसका स्वामी है। आप स्थिर, भरोसेमंद और कला प्रेमी हैं।',
      'मिथुन': 'मिथुन राशि वायु तत्व की है। बुध ग्रह इसका स्वामी है। आप बुद्धिमान, संवादप्रिय और बहुमुखी हैं।',
      'कर्क': 'कर्क राशि जल तत्व की है। चंद्रमा इसका स्वामी है। आप भावनात्मक, परिवार प्रेमी और देखभाल करने वाले हैं।',
      'सिंह': 'सिंह राशि अग्नि तत्व की है। सूर्य इसका स्वामी है। आप गर्वीले, नेतृत्व करने वाले और उदार हैं।',
      'कन्या': 'कन्या राशि पृथ्वी तत्व की है। बुध ग्रह इसका स्वामी है। आप विस्तार पर ध्यान देने वाले, व्यवस्थित और सेवा भावी हैं।',
      'तुला': 'तुला राशि वायु तत्व की है। शुक्र ग्रह इसका स्वामी है। आप संतुलन पसंद करने वाले, सौंदर्य प्रेमी और न्यायप्रिय हैं।',
      'वृश्चिक': 'वृश्चिक राशि जल तत्व की है। मंगल ग्रह इसका स्वामी है। आप रहस्यमयी, तीव्र और रूपांतरण करने वाले हैं।',
      'धनु': 'धनु राशि अग्नि तत्व की है। बृहस्पति ग्रह इसका स्वामी है। आप साहसिक, दार्शनिक और यात्रा प्रेमी हैं।',
      'मकर': 'मकर राशि पृथ्वी तत्व की है। शनि ग्रह इसका स्वामी है। आप महत्वाकांक्षी, अनुशासित और लक्ष्य केंद्रित हैं।',
      'कुंभ': 'कुंभ राशि वायु तत्व की है। शनि ग्रह इसका स्वामी है। आप मौलिक, मानवतावादी और नवाचारी हैं।',
      'मीन': 'मीन राशि जल तत्व की है। बृहस्पति ग्रह इसका स्वामी है। आप कल्पनाशील, आध्यात्मिक और करुणामय हैं।',
    };
    
    final rashiInfoEnglish = {
      'aries': 'Aries is a fire element sign. Mars is its ruling planet. You are courageous, enthusiastic and a natural leader.',
      'taurus': 'Taurus is an earth element sign. Venus is its ruling planet. You are stable, trustworthy and love art.',
      'gemini': 'Gemini is an air element sign. Mercury is its ruling planet. You are intelligent, communicative and versatile.',
      'cancer': 'Cancer is a water element sign. Moon is its ruling planet. You are emotional, family-loving and caring.',
      'leo': 'Leo is a fire element sign. Sun is its ruling planet. You are proud, a natural leader and generous.',
      'virgo': 'Virgo is an earth element sign. Mercury is its ruling planet. You are detail-oriented, organized and service-minded.',
      'libra': 'Libra is an air element sign. Venus is its ruling planet. You love balance, beauty and justice.',
      'scorpio': 'Scorpio is a water element sign. Mars is its ruling planet. You are mysterious, intense and transformative.',
      'sagittarius': 'Sagittarius is a fire element sign. Jupiter is its ruling planet. You are adventurous, philosophical and love travel.',
      'capricorn': 'Capricorn is an earth element sign. Saturn is its ruling planet. You are ambitious, disciplined and goal-oriented.',
      'aquarius': 'Aquarius is an air element sign. Saturn is its ruling planet. You are original, humanitarian and innovative.',
      'pisces': 'Pisces is a water element sign. Jupiter is its ruling planet. You are imaginative, spiritual and compassionate.',
    };
    
    String baseInfo;
    if (language == 'hindi') {
      baseInfo = rashiInfoHindi[rashi] ?? '${rashi} राशि के बारे में जानकारी।';
    } else {
      baseInfo = rashiInfoEnglish[rashi.toLowerCase()] ?? 'Information about ${rashi} zodiac sign.';
    }
    
    if (lowerMessage.contains('आज') || lowerMessage.contains('today')) {
      if (language == 'hindi') {
        return '$baseInfo\n\nआज का दिन आपके लिए शुभ रहेगा। सकारात्मक सोच बनाए रखें। कार्यक्षेत्र में सफलता मिलेगी।';
      } else {
        return '$baseInfo\n\nToday will be auspicious for you. Keep positive thoughts. Success in career.';
      }
    }
    
    if (language == 'hindi') {
      return baseInfo + '\n\nक्या आप अपनी राशि के बारे में कुछ विशेष जानना चाहते हैं?';
    } else {
      return baseInfo + '\n\nWould you like to know something specific about your zodiac sign?';
    }
  }
  
  static String _generateContextualResponse(String originalMessage, String lowerMessage, String language) {
    // Generate a more contextual response
    if (originalMessage.length < 10) {
      if (language == 'hindi') {
        return 'कृपया अपना प्रश्न विस्तार से पूछें। मैं ज्योतिष, वास्तु, रत्न, मंत्र, दोष विश्लेषण, और आध्यात्मिकता के बारे में आपकी सहायता कर सकता हूं।';
      } else {
        return 'Please ask your question in detail. I can help you with astrology, Vastu, gemstones, mantras, dosha analysis, and spirituality.';
      }
    }
    
    // Try to understand the intent
    if (lowerMessage.contains('क्या') || lowerMessage.contains('what')) {
      if (language == 'hindi') {
        return 'आपके प्रश्न के अनुसार, मैं आपको विस्तृत जानकारी दे सकता हूं। कृपया अपना प्रश्न थोड़ा और विस्तार से पूछें ताकि मैं आपको सटीक जवाब दे सकूं।';
      } else {
        return 'According to your question, I can provide detailed information. Please ask your question a bit more in detail so I can give you an accurate answer.';
      }
    }
    
    if (lowerMessage.contains('कैसे') || lowerMessage.contains('how')) {
      if (language == 'hindi') {
        return 'मैं आपको चरणबद्ध तरीके से समझा सकता हूं। कृपया बताएं कि आप किस बारे में जानना चाहते हैं - ज्योतिष, वास्तु, रत्न, मंत्र, या कोई अन्य विषय?';
      } else {
        return 'I can explain to you step by step. Please tell me what you want to know about - astrology, Vastu, gemstones, mantras, or any other topic?';
      }
    }
    
    // Generic helpful response
    if (language == 'hindi') {
      return '''मैं आपके प्रश्न को समझ रहा हूं। 

आपके प्रश्न के अनुसार, मैं आपकी सहायता कर सकता हूं:
• ज्योतिष और होरोस्कॉप
• कुंडली और राशि मिलान  
• दोष विश्लेषण
• अंक ज्योतिष
• रत्न और मंत्र
• वास्तु शास्त्र
• करियर, प्रेम, स्वास्थ्य

कृपया अपना प्रश्न थोड़ा और विस्तार से पूछें, जैसे:
"मेरी राशि मेष है, आज का दिन कैसा रहेगा?"
"मंगल दोष क्या है और इसका उपाय क्या है?"
"कौन सा रत्न मेरे लिए शुभ होगा?"''';
    } else {
      return '''I understand your question. 

According to your question, I can help you with:
• Astrology and Horoscope
• Kundli and Zodiac Matching
• Dosha Analysis
• Numerology
• Gemstones and Mantras
• Vastu Shastra
• Career, Love, Health

Please ask your question a bit more in detail, like:
"My zodiac sign is Aries, how will today be?"
"What is Mangal dosha and what is its remedy?"
"Which gemstone will be auspicious for me?"''';
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
