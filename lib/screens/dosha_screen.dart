import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/zodiac_data.dart';

// Colors
const Color primaryColor = Color(0xFF6C63FF);
const Color backgroundColor = Color(0xFF0F0F1E);
const Color cardColor = Color(0xFF1E1E2E);
const Color textPrimary = Colors.white;
const Color textSecondary = Color(0xFFA0A0B2);

class DoshaScreen extends StatefulWidget {
  const DoshaScreen({super.key});

  @override
  State<DoshaScreen> createState() => _DoshaScreenState();
}

class _DoshaScreenState extends State<DoshaScreen> {
  String? selectedZodiac;
  String? selectedDosha;

  final List<Map<String, dynamic>> doshas = [
    {
      'name': 'कालसर्प दोष',
      'hindiName': 'Kalsarpa Dosha',
      'icon': Icons.warning,
      'color': Colors.red,
      'description':
          'कालसर्प दोष तब होता है जब सभी ग्रह राहु और केतु के बीच होते हैं।',
    },
    {
      'name': 'मंगल दोष',
      'hindiName': 'Mangal Dosha',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
      'description':
          'मंगल दोष तब होता है जब मंगल ग्रह 1, 4, 7, 8, या 12वें भाव में हो।',
    },
    {
      'name': 'पितृ दोष',
      'hindiName': 'Pitra Dosha',
      'icon': Icons.family_restroom,
      'color': Colors.brown,
      'description': 'पितृ दोष पूर्वजों के असंतुष्ट होने के कारण होता है।',
    },
    {
      'name': 'साढ़े साती',
      'hindiName': 'Sade Sati',
      'icon': Icons.auto_awesome,
      'color': Colors.blue,
      'description': 'साढ़े साती तब होती है जब शनि चंद्रमा के आसपास होता है।',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('दोष विश्लेषण',
            style: GoogleFonts.poppins(
                color: textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zodiac Selection
            Text(
              ' अपनी राशि चुनें',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedZodiac,
                  isExpanded: true,
                  hint: Text(
                    'राशि चुनें',
                    style: GoogleFonts.roboto(color: textSecondary),
                  ),
                  dropdownColor: cardColor,
                  icon: const Icon(Icons.arrow_drop_down, color: textSecondary),
                  style: GoogleFonts.roboto(color: textPrimary),
                  items: ZodiacData.zodiacSigns.map((sign) {
                    return DropdownMenuItem<String>(
                      value: sign.name,
                      child: Text('${sign.hindiName} (${sign.name})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedZodiac = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Dosha Cards
            Text(
              'दोष प्रकार',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...doshas.map((dosha) => _buildDoshaCard(dosha)),
          ],
        ),
      ),
    );
  }

  Widget _buildDoshaCard(Map<String, dynamic> dosha) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: textSecondary,
          collapsedIconColor: textSecondary,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (dosha['color'] as Color).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              dosha['icon'] as IconData,
              color: dosha['color'] as Color,
            ),
          ),
          title: Text(
            dosha['name'] as String,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textPrimary,
            ),
          ),
          subtitle: Text(
            dosha['hindiName'] as String,
            style: GoogleFonts.roboto(fontSize: 12, color: textSecondary),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dosha['description'] as String,
                    style:
                        GoogleFonts.roboto(height: 1.5, color: textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'उपाय:',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• नियमित रूप से पूजा-पाठ करें\n• दान-पुण्य करें\n• संबंधित मंत्र का जाप करें\n• विशेषज्ञ से सलाह लें',
                          style: GoogleFonts.roboto(
                              fontSize: 14, color: textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
