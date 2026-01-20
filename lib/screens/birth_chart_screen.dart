import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Colors
const Color primaryColor = Color(0xFF6C63FF);
const Color backgroundColor = Color(0xFF0F0F1E);
const Color cardColor = Color(0xFF1E1E2E);
const Color textPrimary = Colors.white;
const Color textSecondary = Color(0xFFA0A0B2);

class BirthChartScreen extends StatefulWidget {
  const BirthChartScreen({super.key});

  @override
  State<BirthChartScreen> createState() => _BirthChartScreenState();
}

class _BirthChartScreenState extends State<BirthChartScreen> {
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  Map<String, dynamic>? _birthChartData;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1920), 
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _generateKundali() {
    // This is sample data. In a real app, you would use an astrology engine 
    // or API to calculate this based on birth date, time, and place.
    setState(() {
      _birthChartData = {
        'ascendant_details': {
          'sign': 'तुला', 
          'lord': 'शुक्र',
          'nakshatra': 'चित्रा', 
          'pada': 3
        },
        'd1_chart': {
          1: ['Lagna'], 2: ['Ketu'], 4: ['Shani'], 5: ['Guru'], 7: ['Chandrama'],
          8: ['Rahu', 'Mangal'], 10: ['Surya', 'Budh'], 12: ['Shukra']
        },
        'd9_chart': { // Navamsha Chart Data
          1: ['Lagna', 'Guru'], 2: [], 3: ['Shani', 'Ketu'], 5: ['Shukra'], 7: ['Surya'], 
          9: ['Rahu', 'Chandrama'], 10: ['Budh'], 11: ['Mangal']
        },
        'planets': [
          {'name': 'सूर्य', 'sign': 'कर्क', 'house': 10, 'degree': '15.2°', 'nakshatra': 'पुष्य'},
          {'name': 'चंद्रमा', 'sign': 'मिथुन', 'house': 7, 'degree': '23.1°', 'nakshatra': 'पुनर्वसु'},
          {'name': 'मंगल', 'sign': 'वृषभ', 'house': 8, 'degree': '7.8°', 'nakshatra': 'कृत्तिका'},
          {'name': 'बुध', 'sign': 'कर्क', 'house': 10, 'degree': '28.4°', 'nakshatra': 'आश्लेषा'},
          {'name': 'गुरु', 'sign': 'तुला', 'house': 5, 'degree': '11.5°', 'nakshatra': 'चित्रा'},
          {'name': 'शुक्र', 'sign': 'कन्या', 'house': 12, 'degree': '19.0°', 'nakshatra': 'हस्त'},
          {'name': 'शनि', 'sign': 'धनु', 'house': 4, 'degree': '2.3°', 'nakshatra': 'मूल'},
          {'name': 'राहु', 'sign': 'वृषभ', 'house': 8, 'degree': '14.6°', 'nakshatra': 'रोहिणी'},
          {'name': 'केतु', 'sign': 'वृश्चिक', 'house': 2, 'degree': '14.6°', 'nakshatra': 'अनुराधा'},
        ],
        'dasha': [
          {'planet': 'केतु', 'start': '2018-05-15', 'end': '2025-05-15'},
          {'planet': 'शुक्र', 'start': '2025-05-15', 'end': '2045-05-15'},
          {'planet': 'सूर्य', 'start': '2045-05-15', 'end': '2051-05-15'},
          {'planet': 'चंद्रमा', 'start': '2051-05-15', 'end': '2061-05-15'},
        ]
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('कुंडली बनाएं', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold)),
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
            const SizedBox(height: 20),
            if (_birthChartData != null) _buildChartAndDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
     // ... (Input card remains the same)
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(_nameController, 'नाम'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDateTimePicker('जन्म तिथि', _selectedDate != null ? DateFormat('dd/MM/yyyy').format(_selectedDate!) : 'चुनें', () => _selectDate(context))),
              const SizedBox(width: 16),
              Expanded(child: _buildDateTimePicker('जन्म समय', _selectedTime?.format(context) ?? 'चुनें', () => _selectTime(context))),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(_placeController, 'जन्म स्थान'),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: Text('कुंडली बनाएं', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              onPressed: _generateKundali,
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
      ),
    );
  }

  Widget _buildDateTimePicker(String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(value, style: const TextStyle(color: textPrimary)), const Icon(Icons.calendar_today, color: textSecondary, size: 16)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChartAndDetails() {
    return Column(
      children: [
        _buildAscendantDetails(),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildChartSection('जन्म कुंडली (D1)', _birthChartData!['d1_chart'])),
            const SizedBox(width: 16),
            Expanded(child: _buildChartSection('नवांश (D9)', _birthChartData!['d9_chart'])),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('विमशोत्तरी दशा'),
        _buildDashaTable(),
        const SizedBox(height: 24),
        _buildSectionTitle('ग्रह स्थिति'),
        _buildPlanetsTable(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.poppins(color: textPrimary, fontSize: 20, fontWeight: FontWeight.bold));
  }
  
  Widget _buildAscendantDetails() {
    final details = _birthChartData!['ascendant_details'];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildSectionTitle('लग्न विवरण'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem('लग्न राशि', details['sign']), 
              _buildDetailItem('नक्षत्र', details['nakshatra']), 
              _buildDetailItem('स्वामी', details['lord']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: GoogleFonts.roboto(color: textSecondary, fontSize: 14)),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildChartSection(String title, Map<dynamic, dynamic> chartData) {
    return Column(
      children: [
        Text(title, style: GoogleFonts.poppins(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          height: 150, 
          width: 150,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: _KundaliPainter(),
            child: Stack(
              children: List.generate(12, (i) {
                int houseNumber = (i + 1);
                return _buildHouseContent(houseNumber, chartData[houseNumber.toString()] ?? [], _getHouseAlignment(houseNumber));
              }),
            ),
          ),
        ),
      ],
    );
  }

  Alignment _getHouseAlignment(int houseNumber) {
    switch (houseNumber) {
      case 1: return const Alignment(0, -0.7);
      case 2: return const Alignment(0.7, -0.7);
      case 3: return const Alignment(0.7, 0);
      case 4: return const Alignment(0.7, 0.7);
      case 5: return const Alignment(0, 0.7);
      case 6: return const Alignment(-0.7, 0.7);
      case 7: return const Alignment(-0.7, 0);
      case 8: return const Alignment(-0.7, -0.7);
      case 9: return const Alignment(-0.35, -0.35);
      case 10: return const Alignment(0.35, -0.35);
      case 11: return const Alignment(0, 0);
      case 12: return const Alignment(-0.35, 0.35);
      default: return Alignment.center;
    }
  }

  Widget _buildHouseContent(int houseNumber, List<dynamic> planets, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Text(
        planets.join(' '),
        style: const TextStyle(color: textPrimary, fontSize: 9, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPlanetsTable() {
    final planets = _birthChartData!['planets'] as List<dynamic>;
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Table(
        border: TableBorder.all(color: backgroundColor, width: 1.5),
        columnWidths: const {
          0: FlexColumnWidth(2), 1: FlexColumnWidth(2), 2: FlexColumnWidth(1.5), 3: FlexColumnWidth(2)
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(color: backgroundColor),
            children: ['ग्रह', 'राशि', 'डिग्री', 'नक्षत्र'].map((h) => Center(child: Padding(padding: const EdgeInsets.all(12.0), child: Text(h, style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold))))).toList(),
          ),
          ...planets.map((p) {
            return TableRow(
              children: [p['name'], p['sign'], p['degree'], p['nakshatra']].map((cell) => Center(child: Padding(padding: const EdgeInsets.all(10.0), child: Text(cell, style: const TextStyle(color: textSecondary))))).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDashaTable() {
    final dashas = _birthChartData!['dasha'] as List<dynamic>;
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Table(
        border: TableBorder.all(color: backgroundColor, width: 1.5),
        children: [
          TableRow(
            decoration: const BoxDecoration(color: backgroundColor),
            children: ['महादशा', 'आरंभ तिथि', 'अंतिम तिथि'].map((h) => Center(child: Padding(padding: const EdgeInsets.all(12.0), child: Text(h, style: const TextStyle(color: textPrimary, fontWeight: FontWeight.bold))))).toList(),
          ),
          ...dashas.map((d) {
            return TableRow(
              children: [d['planet'], d['start'], d['end']].map((cell) => Center(child: Padding(padding: const EdgeInsets.all(10.0), child: Text(cell, style: const TextStyle(color: textSecondary))))).toList(),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _KundaliPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = textSecondary.withOpacity(0.5)
      ..strokeWidth = 1.0;

    // Outer square
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    // Cross lines
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(0, size.height), paint);
    // Inner diamond
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width, size.height / 2), paint);
    canvas.drawLine(Offset(size.width, size.height / 2), Offset(size.width / 2, size.height), paint);
    canvas.drawLine(Offset(size.width / 2, size.height), Offset(0, size.height / 2), paint);
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width / 2, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
