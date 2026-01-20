import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Colors
const Color primaryColor = Color(0xFF6C63FF);
const Color backgroundColor = Color(0xFF0F0F1E);
const Color cardColor = Color(0xFF1E1E2E);
const Color textPrimary = Colors.white;
const Color textSecondary = Color(0xFFA0A0B2);

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
        SnackBar(
          content: const Text('कृपया नाम और जन्म तिथि दर्ज करें'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    int day = _birthDate!.day;
    int month = _birthDate!.month;
    int year = _birthDate!.year;

    int lifePath = _reduceToSingleDigit(day + month + year);
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
      initialDate: _birthDate ?? DateTime.now(),
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('अंक ज्योतिष', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildInputCard(),
            const SizedBox(height: 24),
            if (lifePathNumber != null && destinyNumber != null)
              _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(_nameController, 'नाम'),
          const SizedBox(height: 16),
          _buildDateTimePicker(),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calculate_rounded, size: 18),
              label: Text('गणना करें', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              onPressed: _calculateNumerology,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textSecondary),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        prefixIcon: const Icon(Icons.person_outline, color: textSecondary),
      ),
    );
  }
  
  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('जन्म तिथि', style: GoogleFonts.roboto(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _birthDate != null ? DateFormat('dd/MM/yyyy').format(_birthDate!) : 'जन्म तिथि चुनें',
                  style: GoogleFonts.roboto(color: textPrimary, fontSize: 16),
                ),
                const Icon(Icons.calendar_today_outlined, color: textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        _buildNumberCard('जीवन पथ अंक', lifePathNumber!, _getNumberMeaning(lifePathNumber!), primaryColor, Icons.person_search_rounded),
        const SizedBox(height: 16),
        _buildNumberCard('भाग्य अंक', destinyNumber!, _getNumberMeaning(destinyNumber!), Colors.orange, Icons.star_border_rounded),
      ],
    );
  }
  
  Widget _buildNumberCard(String title, int number, String meaning, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(title, style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            number.toString(),
            style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            meaning,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(color: textSecondary, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
