import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../models/horoscope_model.dart';
import '../services/horoscope_service.dart';
import '../utils/zodiac_data.dart';

class HoroscopeDetailScreen extends StatefulWidget {
  final String zodiacSign;

  const HoroscopeDetailScreen({
    super.key,
    required this.zodiacSign,
  });

  @override
  State<HoroscopeDetailScreen> createState() => _HoroscopeDetailScreenState();
}

class _HoroscopeDetailScreenState extends State<HoroscopeDetailScreen> {
  HoroscopeModel? horoscope;
  bool isLoading = true;
  final HoroscopeService _horoscopeService = HoroscopeService();

  @override
  void initState() {
    super.initState();
    _loadHoroscope();
  }

  Future<void> _loadHoroscope() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await _horoscopeService.getDailyHoroscope(widget.zodiacSign);
      setState(() {
        horoscope = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('त्रुटि: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final signData = ZodiacData.getZodiacSign(widget.zodiacSign);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(signData?.color ?? 0xFF6C5CE7).withOpacity(0.9),
              Color(signData?.color ?? 0xFF6C5CE7).withOpacity(0.7),
              Colors.deepPurple.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            signData?.hindiName ?? widget.zodiacSign,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            signData?.name ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: _loadHoroscope,
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: isLoading
                    ? _buildShimmerLoader()
                    : horoscope == null
                        ? Center(
                            child: Text(
                              'कोई डेटा उपलब्ध नहीं',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Horoscope Card
                                _buildHoroscopeCard(),
                                SizedBox(height: 16),

                                // Lucky Info Cards
                                _buildLuckyInfoCards(),
                                SizedBox(height: 16),

                                // Zodiac Info
                                _buildZodiacInfo(signData!),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.3),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoroscopeCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stars, color: Colors.amber, size: 28),
              SizedBox(width: 12),
              Text(
                'आज का होरोस्कॉप',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            horoscope!.horoscope,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuckyInfoCards() {
    return Row(
      children: [
        Expanded(
          child: _buildLuckyCard(
            icon: Icons.looks_one,
            title: 'भाग्यशाली संख्या',
            value: horoscope!.luckyNumber,
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildLuckyCard(
            icon: Icons.color_lens,
            title: 'भाग्यशाली रंग',
            value: horoscope!.luckyColor,
            color: Colors.pink,
          ),
        ),
      ],
    );
  }

  Widget _buildLuckyCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZodiacInfo(ZodiacSign sign) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'राशि की जानकारी',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          _buildInfoRow('प्रतीक', sign.symbol),
          _buildInfoRow('तिथि सीमा', sign.dateRange),
          _buildInfoRow('तत्व', sign.element),
          _buildInfoRow('ग्रह', sign.planet),
          _buildInfoRow('मूड', horoscope!.mood),
          _buildInfoRow('संगतता', horoscope!.compatibility),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

