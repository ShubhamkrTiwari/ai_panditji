import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/horoscope_model.dart';
import '../utils/zodiac_data.dart';
import '../screens/horoscope_detail_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/compatibility_screen.dart';
import '../screens/birth_chart_screen.dart';
import '../screens/dosha_screen.dart';
import '../screens/panchang_screen.dart';
import '../screens/numerology_screen.dart';
import '../services/horoscope_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedZodiac;
  HoroscopeModel? todayHoroscope;
  bool isLoadingHoroscope = false;

  @override
  void initState() {
    super.initState();
    _loadTodayHoroscope();
  }

  Future<void> _loadTodayHoroscope() async {
    // Load horoscope for first sign as example
    if (ZodiacData.zodiacSigns.isNotEmpty) {
      setState(() {
        isLoadingHoroscope = true;
      });
      try {
        final service = HoroscopeService();
        final horoscope = await service.getDailyHoroscope(
          ZodiacData.zodiacSigns[0].name,
        );
        setState(() {
          todayHoroscope = horoscope;
          isLoadingHoroscope = false;
        });
      } catch (e) {
        setState(() {
          isLoadingHoroscope = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.deepPurple.shade700,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'AI पंडित जी',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.deepPurple.shade800,
                        Colors.purple.shade600,
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 20,
                        top: 20,
                        child: Icon(
                          Icons.stars,
                          color: Colors.amber,
                          size: 60,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Horoscope Card
                  _buildDailyHoroscopeCard(),
                  SizedBox(height: 20),

                  // Quick Services
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'त्वरित सेवाएं',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildQuickServices(),

                  // Main Features
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'मुख्य सुविधाएं',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildMainFeatures(),

                  // Zodiac Signs
                  SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'अपनी राशि चुनें',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildZodiacGrid(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyHoroscopeCard() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade600,
            Colors.purple.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.calendar_today, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'आज का होरोस्कॉप',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatDate(DateTime.now()),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (isLoadingHoroscope)
              Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            else if (todayHoroscope != null)
              Text(
                todayHoroscope!.horoscope.length > 150
                    ? '${todayHoroscope!.horoscope.substring(0, 150)}...'
                    : todayHoroscope!.horoscope,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              )
            else
              Text(
                'आज का दिन आपके लिए शुभ होगा। सकारात्मक सोच बनाए रखें।',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            SizedBox(height: 12),
            InkWell(
              onTap: () {
                if (ZodiacData.zodiacSigns.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HoroscopeDetailScreen(
                        zodiacSign: ZodiacData.zodiacSigns[0].name,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'पूरा पढ़ें',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickServices() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildServiceCard(
              icon: Icons.account_circle,
              title: 'कुंडली',
              subtitle: 'जन्म कुंडली',
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BirthChartScreen()),
                );
              },
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildServiceCard(
              icon: Icons.favorite,
              title: 'मिलान',
              subtitle: 'राशि मिलान',
              color: Colors.pink,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompatibilityScreen()),
                );
              },
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildServiceCard(
              icon: Icons.chat_bubble,
              title: 'AI चैट',
              subtitle: 'पंडित जी',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainFeatures() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  icon: Icons.warning,
                  title: 'दोष विश्लेषण',
                  subtitle: 'कालसर्प, मंगल दोष',
                  color: Colors.red,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoshaScreen()),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildFeatureCard(
                  icon: Icons.calendar_month,
                  title: 'पंचांग',
                  subtitle: 'तिथि, वार, नक्षत्र',
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PanchangScreen()),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  icon: Icons.numbers,
                  title: 'अंक ज्योतिष',
                  subtitle: 'न्यूमेरोलॉजी',
                  color: Colors.purple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NumerologyScreen()),
                    );
                  },
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildFeatureCard(
                  icon: Icons.stars,
                  title: 'होरोस्कॉप',
                  subtitle: 'सभी राशियां',
                  color: Colors.amber,
                  onTap: () {
                    if (ZodiacData.zodiacSigns.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HoroscopeDetailScreen(
                            zodiacSign: ZodiacData.zodiacSigns[0].name,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZodiacGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: ZodiacData.zodiacSigns.length,
        itemBuilder: (context, index) {
          final sign = ZodiacData.zodiacSigns[index];
          return _buildZodiacCard(sign);
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('dd MMMM yyyy', 'hi').format(date);
    } catch (e) {
      // Fallback to English format if Hindi locale is not available
      return DateFormat('dd MMMM yyyy').format(date);
    }
  }

  Widget _buildZodiacCard(ZodiacSign sign) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HoroscopeDetailScreen(zodiacSign: sign.name),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(sign.color).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sign.symbol,
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 8),
            Text(
              sign.hindiName,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 2),
            Text(
              sign.name,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
