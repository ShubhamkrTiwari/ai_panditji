import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/zodiac_data.dart';
import '../services/ai_service.dart';
import 'package:flutter/rendering.dart' show ViewportOffset, ViewportDimension;

// Colors
const Color primaryColor = Color(0xFF6C63FF);
const Color backgroundColor = Color(0xFF0F0F1E);
const Color cardColor = Color(0xFF1E1E2E);
const Color textPrimary = Colors.white;
const Color textSecondary = Color(0xFFA0A0B2);

class CompatibilityScreen extends StatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _HeartData {
  final AnimationController controller;
  final Offset position;
  final double scale;
  final double size;

  _HeartData({
    required this.controller,
    required this.position,
    required this.scale,
    required this.size,
  });
}

class _CompatibilityScreenState extends State<CompatibilityScreen> with TickerProviderStateMixin {
  // Heart animation controllers
  late AnimationController _heartController;
  final List<_HeartData> _floatingHearts = [];
  final Random _random = Random();
  
  @override
  void initState() {
    super.initState();
    // Controller for triggering heart animations
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    // Start generating floating hearts
    _startHeartAnimation();
  }
  
  @override
  void dispose() {
    _heartController.dispose();
    for (var heartData in _floatingHearts) {
      heartData.controller.dispose();
    }
    super.dispose();
  }
  
  void _startHeartAnimation() {
    // Random delay between 0.5 to 2 seconds for next heart
    final randomDelay = 500 + _random.nextInt(1500);
    Future.delayed(Duration(milliseconds: randomDelay), () {
      if (mounted) {
        _addFloatingHeart();
        _startHeartAnimation();
      }
    });
  }
  
  void _addFloatingHeart() {
    final size = MediaQuery.of(context).size;
    
    // Slower animation duration (8-12 seconds)
    final controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8 + _random.nextInt(5)),
    );
    
    // Random position anywhere on screen
    final position = Offset(
      _random.nextDouble() * size.width,
      _random.nextDouble() * size.height,
    );
    
    // Random scale for variety (0.8 to 1.5)
    final scale = 0.8 + _random.nextDouble() * 0.7;
    
    // Create and store heart data
    final heartData = _HeartData(
      controller: controller,
      position: position,
      scale: scale,
      size: 20.0 + _random.nextDouble() * 40.0, // 20 to 60 pixels
    );
    
    _floatingHearts.add(heartData);
    
    // Animate the heart
    controller.forward().then((_) {
      if (mounted) {
        setState(() {
          _floatingHearts.remove(heartData);
          controller.dispose();
        });
      }
    });
    
    setState(() {});
  }
  String? selectedSign1;
  String? selectedSign2;
  String? compatibilityResult;
  bool isLoading = false;

  Future<void> _checkCompatibility() async {
    if (selectedSign1 == null || selectedSign2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('कृपया दोनों राशियां चुनें'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
      compatibilityResult = null;
    });

    try {
      final result = await AIService.generateCompatibility(
        selectedSign1!,
        selectedSign2!,
      );
      setState(() {
        compatibilityResult = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('त्रुटि: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Widget to display a single floating heart
  Widget _buildFloatingHeart(_HeartData heartData, int index) {
    final controller = heartData.controller;
    final position = heartData.position;
    
    // Heart colors with different opacities
    final colors = [
      const Color(0xFFFF6B6B).withOpacity(0.8),
      const Color(0xFFFF8E8E).withOpacity(0.8),
      const Color(0xFFFFB6B6).withOpacity(0.8),
      const Color(0xFFFFD3D3).withOpacity(0.8),
      const Color(0xFFFF6B9C).withOpacity(0.8),
      const Color(0xFFFF8EC7).withOpacity(0.8),
    ];
    
    final color = colors[_random.nextInt(colors.length)];
    
    // Animation for the heart
    final animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));
    
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        // Calculate scale with pop-up effect
        final scale = heartData.scale * (0.5 + 0.5 * sin(controller.value * pi));
        
        // Calculate opacity (fade in and out)
        final opacity = controller.value < 0.1 
            ? controller.value * 10  // Fade in quickly
            : controller.value > 0.9 
                ? (1 - (controller.value - 0.9) * 10)  // Fade out at the end
                : 1.0;  // Stay fully visible in the middle
                
        return Positioned(
          left: position.dx - (heartData.size / 2),
          top: position.dy - (heartData.size / 2) - (100 * controller.value),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Transform.rotate(
                angle: controller.value * pi * 2, // Full rotation
                child: Icon(
                  Icons.favorite,
                  color: color,
                  size: heartData.size,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('राशि मिलान',
            style: GoogleFonts.poppins(
                color: textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: textPrimary,
      ),
      body: Stack(
        children: [
          // Background hearts
          ..._floatingHearts.map((heartData) => _buildFloatingHeart(heartData, _floatingHearts.indexOf(heartData))),
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sign Selection Cards
                _buildSignSelector(
                  label: 'पहली राशि चुनें',
                  selectedSign: selectedSign1,
                  onChanged: (sign) {
                    setState(() {
                      selectedSign1 = sign;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildSignSelector(
                  label: 'दूसरी राशि चुनें',
                  selectedSign: selectedSign2,
                  onChanged: (sign) {
                    setState(() {
                      selectedSign2 = sign;
                    });
                  },
                ),
                const SizedBox(height: 32),

                // Check Button - Enhanced
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [primaryColor, Color(0xFF8A2BE2)],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isLoading ? null : _checkCompatibility,
                      borderRadius: BorderRadius.circular(28),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.favorite_rounded,
                                      color: Colors.white, size: 22),
                                  const SizedBox(width: 12),
                                  Text(
                                    'मिलान जांचें',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Result - Enhanced
                if (compatibilityResult != null)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [primaryColor, Color(0xFF8A2BE2)],
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(14)),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.favorite_rounded,
                                  color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'मिलान परिणाम',
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: textPrimary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          compatibilityResult!,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: textSecondary,
                            height: 1.7,
                            letterSpacing: 0.3,
                          ),
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

  Widget _buildSignSelector({
    required String label,
    required String? selectedSign,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textPrimary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedSign,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: textSecondary),
              dropdownColor: cardColor,
              style: GoogleFonts.roboto(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              hint: Text(
                'राशि चुनें',
                style: GoogleFonts.roboto(
                  color: textSecondary,
                  fontWeight: FontWeight.normal,
                ),
              ),
              items: ZodiacData.zodiacSigns.map((sign) {
                return DropdownMenuItem<String>(
                  value: sign.name,
                  child: Row(
                    children: [
                      Text(sign.symbol, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Text('${sign.hindiName} (${sign.name})'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
