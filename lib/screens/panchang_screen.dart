import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// Colors
const Color primaryColor = Color(0xFF6C63FF);
const Color backgroundColor = Color(0xFF0F0F1E);
const Color cardColor = Color(0xFF1E1E2E);
const Color textPrimary = Colors.white;
const Color textSecondary = Color(0xFFA0A0B2);

class PanchangScreen extends StatelessWidget {
  const PanchangScreen({super.key});

  // Sample Panchang Data (replace with a real API call)
  final Map<String, dynamic> panchangData = const {
    'samvat': 'विक्रम संवत् 2081',
    'month': 'ज्येष्ठ',
    'paksha': 'शुक्ल पक्ष',
    'tithi': {
      'name': 'दशमी',
      'ends_at': '08:30 PM'
    },
    'nakshatra': {
      'name': 'उत्तराषाढ़ा',
      'ends_at': '11:00 PM'
    },
    'yoga': {
      'name': 'वरीयान्',
      'ends_at': '05:00 PM'
    },
    'karana': {
      'name': 'तैतिल',
      'ends_at': '07:45 AM'
    },
    'sunrise': '05:45 AM',
    'sunset': '07:15 PM',
    'moonrise': '02:30 PM',
    'moonset': '01:40 AM',
    'rahuKaal': '10:30 AM - 12:00 PM',
    'abhijitMuhurta': '11:50 AM - 12:45 PM',
    'guliKaal': '06:00 AM - 07:30 AM',
    'yamaganda': '01:30 PM - 03:00 PM',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('आज का पंचांग', style: GoogleFonts.poppins(color: textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(),
            const SizedBox(height: 24),
            _buildPrimaryPanchang(),
            const SizedBox(height: 24),
            _buildTimingsCard(),
            const SizedBox(height: 24),
            _buildAuspiciousTimes(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateHeader() {
    return Center(
      child: Column(
        children: [
          Text(
            DateFormat('EEEE, d MMMM y', 'hi').format(DateTime.now()), // Dynamic date
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${panchangData['samvat']} | ${panchangData['month']} मास, ${panchangData['paksha']}',
            style: GoogleFonts.roboto(color: textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryPanchang() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.0,
      children: [
        _buildPanchangItem(FontAwesomeIcons.calendarDay, 'तिथि', panchangData['tithi']['name']!, panchangData['tithi']['ends_at']!),
        _buildPanchangItem(FontAwesomeIcons.star, 'नक्षत्र', panchangData['nakshatra']['name']!, panchangData['nakshatra']['ends_at']!),
        _buildPanchangItem(FontAwesomeIcons.link, 'योग', panchangData['yoga']['name']!, panchangData['yoga']['ends_at']!),
        _buildPanchangItem(FontAwesomeIcons.hands, 'करण', panchangData['karana']['name']!, panchangData['karana']['ends_at']!),
      ],
    );
  }

  Widget _buildPanchangItem(IconData icon, String title, String value, String endsAt) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: textSecondary, size: 18),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.roboto(color: textSecondary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('तक $endsAt', style: GoogleFonts.roboto(color: textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTimingsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTimingColumn(FontAwesomeIcons.sun, 'सूर्योदय', panchangData['sunrise']!, Colors.orangeAccent),
          _buildTimingColumn(FontAwesomeIcons.solidSun, 'सूर्यास्त', panchangData['sunset']!, Colors.redAccent),
          _buildTimingColumn(FontAwesomeIcons.moon, 'चंद्रोदय', panchangData['moonrise']!, Colors.lightBlueAccent),
          _buildTimingColumn(FontAwesomeIcons.solidMoon, 'चंद्रास्त', panchangData['moonset']!, Colors.indigoAccent),
        ],
      ),
    );
  }

  Widget _buildTimingColumn(IconData icon, String title, String time, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(title, style: GoogleFonts.roboto(color: textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(time, style: GoogleFonts.poppins(color: textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildAuspiciousTimes() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('शुभ और अशुभ समय', style: GoogleFonts.poppins(color: textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildTimeRow(FontAwesomeIcons.clock, 'अभिजीत मुहूर्त', panchangData['abhijitMuhurta']!, Colors.greenAccent),
          const Divider(color: textSecondary, thickness: 0.2, height: 24),
          _buildTimeRow(FontAwesomeIcons.solidClock, 'राहुकाल', panchangData['rahuKaal']!, Colors.redAccent),
          const Divider(color: textSecondary, thickness: 0.2, height: 24),
          _buildTimeRow(FontAwesomeIcons.hourglassHalf, 'गुलिक काल', panchangData['guliKaal']!, Colors.orangeAccent),
          const Divider(color: textSecondary, thickness: 0.2, height: 24),
          _buildTimeRow(FontAwesomeIcons.hourglassEnd, 'यमगण्ड', panchangData['yamaganda']!, Colors.red[300]!),
        ],
      ),
    );
  }

  Widget _buildTimeRow(IconData icon, String title, String time, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 16),
        Text(title, style: GoogleFonts.roboto(color: textSecondary, fontSize: 16)),
        const Spacer(),
        Text(time, style: GoogleFonts.poppins(color: textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
