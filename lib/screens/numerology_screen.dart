import 'package:flutter/material.dart';

class NumerologyScreen extends StatefulWidget {
  const NumerologyScreen({super.key});

  @override
  State<NumerologyScreen> createState() => _NumerologyScreenState();
}

class _NumerologyScreenState extends State<NumerologyScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _birthDate;
  int? lifePathNumber;
  int? destinyNumber;

  void _calculateNumerology() {
    if (_nameController.text.isEmpty || _birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('कृपया नाम और जन्म तिथि दर्ज करें')),
      );
      return;
    }

    // Calculate Life Path Number
    int day = _birthDate!.day;
    int month = _birthDate!.month;
    int year = _birthDate!.year;

    int lifePath = _reduceToSingleDigit(day + month + year);
    
    // Calculate Destiny Number from name
    int destiny = _calculateNameNumber(_nameController.text);

    setState(() {
      lifePathNumber = lifePath;
      destinyNumber = destiny;
    });
  }

  int _reduceToSingleDigit(int number) {
    while (number > 9 && number != 11 && number != 22 && number != 33) {
      int sum = 0;
      while (number > 0) {
        sum += number % 10;
        number ~/= 10;
      }
      number = sum;
    }
    return number;
  }

  int _calculateNameNumber(String name) {
    final Map<String, int> letterValues = {
      'a': 1, 'i': 1, 'j': 1, 'q': 1, 'y': 1,
      'b': 2, 'k': 2, 'r': 2,
      'c': 3, 'g': 3, 'l': 3, 's': 3,
      'd': 4, 'm': 4, 't': 4,
      'e': 5, 'h': 5, 'n': 5, 'x': 5,
      'u': 6, 'v': 6, 'w': 6,
      'o': 7, 'z': 7,
      'f': 8, 'p': 8,
    };

    int sum = 0;
    for (int i = 0; i < name.length; i++) {
      String char = name[i].toLowerCase();
      if (letterValues.containsKey(char)) {
        sum += letterValues[char]!;
      }
    }

    return _reduceToSingleDigit(sum);
  }

  String _getNumberMeaning(int number) {
    final meanings = {
      1: 'नेतृत्व, स्वतंत्रता, नवाचार',
      2: 'सहयोग, संतुलन, शांति',
      3: 'रचनात्मकता, संचार, आनंद',
      4: 'स्थिरता, व्यवस्था, मेहनत',
      5: 'स्वतंत्रता, साहसिकता, बदलाव',
      6: 'परिवार, जिम्मेदारी, देखभाल',
      7: 'आध्यात्मिकता, ज्ञान, अंतर्दृष्टि',
      8: 'सफलता, शक्ति, भौतिक उपलब्धि',
      9: 'मानवता, सेवा, पूर्णता',
      11: 'अंतर्ज्ञान, आध्यात्मिक जागृति',
      22: 'मास्टर बिल्डर, व्यावहारिक आदर्श',
      33: 'मास्टर टीचर, सेवा और करुणा',
    };
    return meanings[number] ?? 'विशेष संख्या';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('अंक ज्योतिष'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name Input
            Text(
              'नाम',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'अपना नाम दर्ज करें',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),

            // Birth Date
            Text(
              'जन्म तिथि',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.purple.shade700),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _birthDate != null
                            ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                            : 'जन्म तिथि चुनें',
                        style: TextStyle(
                          fontSize: 16,
                          color: _birthDate != null
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _calculateNumerology,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'गणना करें',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Results
            if (lifePathNumber != null && destinyNumber != null) ...[
              _buildNumberCard(
                'जीवन पथ अंक',
                lifePathNumber!,
                _getNumberMeaning(lifePathNumber!),
                Colors.blue,
              ),
              SizedBox(height: 12),
              _buildNumberCard(
                'भाग्य अंक',
                destinyNumber!,
                _getNumberMeaning(destinyNumber!),
                Colors.purple,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNumberCard(String title, int number, String meaning, Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            meaning,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

