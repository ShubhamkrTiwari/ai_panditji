import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PanchangScreen extends StatefulWidget {
  const PanchangScreen({super.key});

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  DateTime selectedDate = DateTime.now();

  final List<String> tithis = [
    'प्रतिपदा',
    'द्वितीया',
    'तृतीया',
    'चतुर्थी',
    'पंचमी',
    'षष्ठी',
    'सप्तमी',
    'अष्टमी',
    'नवमी',
    'दशमी',
    'एकादशी',
    'द्वादशी',
    'त्रयोदशी',
    'चतुर्दशी',
    'पूर्णिमा',
    'अमावस्या',
  ];

  final List<String> nakshatras = [
    'अश्विनी',
    'भरणी',
    'कृतिका',
    'रोहिणी',
    'मृगशिरा',
    'आर्द्रा',
    'पुनर्वसु',
    'पुष्य',
    'अश्लेषा',
    'मघा',
    'पूर्व फाल्गुनी',
    'उत्तर फाल्गुनी',
    'हस्त',
    'चित्रा',
    'स्वाती',
    'विशाखा',
    'अनुराधा',
    'ज्येष्ठा',
    'मूल',
    'पूर्वाषाढ़ा',
    'उत्तराषाढ़ा',
    'श्रवण',
    'धनिष्ठा',
    'शतभिषा',
    'पूर्व भाद्रपद',
    'उत्तर भाद्रपद',
    'रेवती',
  ];

  final List<String> weekdays = [
    'रविवार',
    'सोमवार',
    'मंगलवार',
    'बुधवार',
    'गुरुवार',
    'शुक्रवार',
    'शनिवार',
  ];

  String _formatDate(DateTime date) {
    try {
      return DateFormat('dd MMMM yyyy', 'hi').format(date);
    } catch (e) {
      // Fallback to English format if Hindi locale is not available
      return DateFormat('dd MMMM yyyy').format(date);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dayIndex = selectedDate.weekday % 7;
    final tithiIndex = selectedDate.day % 16;
    final nakshatraIndex = selectedDate.day % 27;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('पंचांग'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selector
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: EdgeInsets.all(16),
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
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.green.shade700),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'तारीख चुनें',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            _formatDate(selectedDate),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Panchang Details
            _buildPanchangCard(
              'वार',
              weekdays[dayIndex],
              Icons.calendar_view_week,
              Colors.blue,
            ),
            SizedBox(height: 12),
            _buildPanchangCard(
              'तिथि',
              tithis[tithiIndex],
              Icons.brightness_6,
              Colors.orange,
            ),
            SizedBox(height: 12),
            _buildPanchangCard(
              'नक्षत्र',
              nakshatras[nakshatraIndex],
              Icons.stars,
              Colors.purple,
            ),
            SizedBox(height: 12),
            _buildPanchangCard(
              'योग',
              'सिद्ध योग',
              Icons.auto_awesome,
              Colors.green,
            ),
            SizedBox(height: 12),
            _buildPanchangCard(
              'करण',
              'बव करण',
              Icons.timeline,
              Colors.red,
            ),

            SizedBox(height: 20),
            // Auspicious Times
            Text(
              'शुभ मुहूर्त',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 12),
            _buildMuhuratCard('अभिजित मुहूर्त', '11:45 AM - 12:30 PM'),
            SizedBox(height: 8),
            _buildMuhuratCard('ब्रह्म मुहूर्त', '4:30 AM - 5:15 AM'),
            SizedBox(height: 8),
            _buildMuhuratCard('गोधूलि मुहूर्त', '6:00 PM - 6:30 PM'),
          ],
        ),
      ),
    );
  }

  Widget _buildPanchangCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuhuratCard(String name, String time) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: Colors.green.shade700, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

