import 'package:flutter/material.dart';
import '../utils/zodiac_data.dart';

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
      'description': 'कालसर्प दोष तब होता है जब सभी ग्रह राहु और केतु के बीच होते हैं।',
    },
    {
      'name': 'मंगल दोष',
      'hindiName': 'Mangal Dosha',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
      'description': 'मंगल दोष तब होता है जब मंगल ग्रह 1, 4, 7, 8, या 12वें भाव में हो।',
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('दोष विश्लेषण'),
        backgroundColor: Colors.deepPurple.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Zodiac Selection
            Text(
              'अपनी राशि चुनें',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedZodiac,
                  isExpanded: true,
                  hint: Text('राशि चुनें'),
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
            SizedBox(height: 24),

            // Dosha Cards
            Text(
              'दोष प्रकार',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 12),
            ...doshas.map((dosha) => _buildDoshaCard(dosha)),
          ],
        ),
      ),
    );
  }

  Widget _buildDoshaCard(Map<String, dynamic> dosha) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        leading: Container(
          padding: EdgeInsets.all(10),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          dosha['hindiName'] as String,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dosha['description'] as String,
                  style: TextStyle(height: 1.5),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'उपाय:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• नियमित रूप से पूजा-पाठ करें\n• दान-पुण्य करें\n• संबंधित मंत्र का जाप करें\n• विशेषज्ञ से सलाह लें',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
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

