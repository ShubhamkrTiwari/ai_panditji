import 'package:ai_panditji/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/horoscope_model.dart';
import '../utils/zodiac_data.dart';
import '../services/horoscope_service.dart';
import 'horoscope_detail_screen.dart';
import 'chat_screen.dart';
import 'compatibility_screen.dart';
import 'birth_chart_screen.dart';
import 'dosha_screen.dart';
import 'panchang_screen.dart';
import 'numerology_screen.dart';

// Colors
const Color primaryColor = Color(0xFF6C63FF);
const Color secondaryColor = Color(0xFFFF6584);
const Color backgroundColor = Color(0xFF0F0F1E);
const Color cardColor = Color(0xFF1E1E2E);
const Color textPrimary = Colors.white;
const Color textSecondary = Color(0xFFA0A0B2);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String? selectedZodiac = 'मेष';
  HoroscopeModel? todayHoroscope;
  bool isLoadingHoroscope = false;
  final CarouselController _carouselController = CarouselController();
  int _currentCarouselIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _bottomNavIndex = 0; // For BottomNavigationBar
  final PageController _pageController = PageController(initialPage: 0);

  // Sample data for features
  final List<Map<String, dynamic>> features = [
    {
      'icon': Icons.psychology,
      'title': 'कुंडली',
      'color': const Color(0xFFFF9F43),
      'screen': const BirthChartScreen(),
    },
    {
      'icon': FontAwesomeIcons.heart,
      'title': 'कॉम्पैटिबिलिटी',
      'color': const Color(0xFFFF6B6B),
      'screen': const CompatibilityScreen(),
    },
    {
      'icon': Icons.calendar_today,
      'title': 'पंचांग',
      'color': const Color(0xFF6C5CE7),
      'screen': const PanchangScreen(),
    },
    {
      'icon': Icons.numbers,
      'title': 'न्यूमरोलॉजी',
      'color': const Color(0xFF00B894),
      'screen': const NumerologyScreen(),
    },
    {
      'icon': Icons.auto_awesome,
      'title': 'दोष',
      'color': const Color(0xFFE84393),
      'screen': const DoshaScreen(),
    },
    {
      'icon': Icons.chat,
      'title': 'एआई सलाह',
      'color': const Color(0xFF0984E3),
      'screen': const ChatScreen(),
    },
  ];

  // Sample daily predictions
  final List<Map<String, dynamic>> dailyPredictions = [
    {
      'time': 'सुबह',
      'prediction': 'आज का दिन आपके लिए शुभ रहेगा। कोई शुभ समाचार मिल सकता है।',
      'icon': Icons.wb_sunny,
      'color': 0xFFFFD700,
    },
    {
      'time': 'दोपहर',
      'prediction': 'कार्यक्षेत्र में सफलता मिलेगी। नए अवसर प्राप्त होंगे।',
      'icon': Icons.brightness_5,
      'color': 0xFFFFA500,
    },
    {
      'time': 'शाम',
      'prediction': 'पारिवारिक सदस्यों के साथ समय बिताएं। रिश्तों में मिठास आएगी।',
      'icon': Icons.nights_stay,
      'color': 0xFF9370DB,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    
    if (ZodiacData.zodiacSigns.isNotEmpty && selectedZodiac == null) {
      selectedZodiac = ZodiacData.zodiacSigns[0].hindiName;
    }
    _loadTodayHoroscope();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayHoroscope() async {
    final zodiacToLoad = selectedZodiac ?? 
        (ZodiacData.zodiacSigns.isNotEmpty ? ZodiacData.zodiacSigns[0].hindiName : null);
    
    if (zodiacToLoad != null) {
      setState(() {
        isLoadingHoroscope = true;
      });
      try {
        final service = HoroscopeService();
        final horoscope = await service.getDailyHoroscope(zodiacToLoad);
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

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  Future<bool> _onWillPop() async {
    if (_bottomNavIndex != 0) {
      setState(() {
        _bottomNavIndex = 0;
        _pageController.jumpToPage(0);
      });
      return false; // Don't exit the app, just go to home
    }
    return true; // Allow exit if already on home
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Home Screen
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppBar(),
                  const SizedBox(height: 16),
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),
                  _buildHoroscopeCard(),
                  const SizedBox(height: 24),
                  _buildFeaturesGrid(),
                  const SizedBox(height: 24),
                  _buildDailyPredictions(),
                  const SizedBox(height: 24),
                  _buildZodiacCarousel(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            // Chat Screen
            const ChatScreen(),
            // Compatibility Screen
            const CompatibilityScreen(),
            // Settings Screen
            const SettingsScreen(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'नमस्ते!',
                style: GoogleFonts.roboto(
                  color: textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'आपका स्वागत है',
                style: GoogleFonts.poppins(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor.withOpacity(0.5), width: 2),
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                'https://img.icons8.com/color/96/000000/hindu-god-krishna.png',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'आज का राशिफल',
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'आज ${DateFormat('d MMMM y', 'hi').format(DateTime.now())} को आपके लिए क्या खास है?',
            style: GoogleFonts.roboto(
              color: textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoroscopeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8A2BE2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'आज का भविष्यफल',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${selectedZodiac ?? 'राशि चुनें'} राशि के लिए',
                      style: GoogleFonts.roboto(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedZodiac,
                    dropdownColor: const Color(0xFF6C63FF),
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedZodiac = newValue;
                          _loadTodayHoroscope();
                        });
                      }
                    },
                    items: ZodiacData.zodiacSigns
                        .map<DropdownMenuItem<String>>((zodiac) {
                      return DropdownMenuItem<String>(
                        value: zodiac.hindiName,
                        child: Text(
                          zodiac.hindiName,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLoadingHoroscope)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          else if (todayHoroscope != null)
            Text(
              todayHoroscope!.horoscope,
              style: GoogleFonts.roboto(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            )
          else
            Text(
              'आज के लिए कोई भविष्यवाणी उपलब्ध नहीं है। कृपया बाद में पुनः प्रयास करें।',
              style: GoogleFonts.roboto(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (selectedZodiac != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HoroscopeDetailScreen(
                      zodiacSign: selectedZodiac!,
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: 0,
            ),
            child: Center(
              child: Text(
                'पूरा भविष्यफल पढ़ें',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'सेवाएं',
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return _buildFeatureItem(
                icon: feature['icon'],
                title: feature['title'],
                color: feature['color'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => feature['screen']),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildDailyPredictions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Daily Predictions',
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dailyPredictions.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              final prediction = dailyPredictions[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(prediction['icon'], color: Color(prediction['color']), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          prediction['time'],
                          style: GoogleFonts.poppins(
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prediction['prediction'],
                      style: GoogleFonts.roboto(
                        color: textSecondary,
                        fontSize: 14,
                      ),
                       maxLines: 3,
                       overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.roboto(
                color: textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZodiacCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'सभी राशियाँ',
            style: GoogleFonts.poppins(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        CarouselSlider.builder(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 210,
            viewportFraction: 0.6,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          itemCount: ZodiacData.zodiacSigns.length,
          itemBuilder: (context, index, realIndex) {
            final zodiac = ZodiacData.zodiacSigns[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedZodiac = zodiac.hindiName;
                  _loadTodayHoroscope();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _currentCarouselIndex == index 
                          ? primaryColor 
                          : cardColor,
                      _currentCarouselIndex == index 
                          ? primaryColor.withOpacity(0.7) 
                          : cardColor.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _currentCarouselIndex == index
                          ? primaryColor.withOpacity(0.3)
                          : Colors.transparent,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          zodiac.symbol,
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      zodiac.hindiName,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      zodiac.dateRange,
                      style: GoogleFonts.roboto(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: AnimatedSmoothIndicator(
            activeIndex: _currentCarouselIndex,
            count: ZodiacData.zodiacSigns.length,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: primaryColor,
              dotColor: Color(0xFF3A3A4E),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomNavigationBar(
          currentIndex: _bottomNavIndex,
          onTap: _onBottomNavTapped,
          backgroundColor: Colors.transparent,
          selectedItemColor: primaryColor,
          unselectedItemColor: textSecondary,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_rounded),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.heartPulse),
              label: 'Compatibility',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    try {
      return DateFormat('dd MMMM yyyy', 'hi').format(date);
    } catch (e) {
      return DateFormat('dd MMMM yyyy').format(date);
    }
  }
}
