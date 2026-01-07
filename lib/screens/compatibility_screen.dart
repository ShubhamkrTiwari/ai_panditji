import 'package:flutter/material.dart';
import '../utils/zodiac_data.dart';
import '../services/ai_service.dart';

class CompatibilityScreen extends StatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen> {
  String? selectedSign1;
  String? selectedSign2;
  String? compatibilityResult;
  bool isLoading = false;

  Future<void> _checkCompatibility() async {
    if (selectedSign1 == null || selectedSign2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('कृपया दोनों राशियां चुनें')),
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
        SnackBar(content: Text('त्रुटि: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.pink.shade900,
              Colors.pink.shade700,
              Colors.purple.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'राशि मिलान',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                // Sign Selection
                Text(
                  'पहली राशि चुनें',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                _buildSignSelector(
                  selectedSign: selectedSign1,
                  onChanged: (sign) {
                    setState(() {
                      selectedSign1 = sign;
                    });
                  },
                ),
                SizedBox(height: 24),

                Text(
                  'दूसरी राशि चुनें',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12),
                _buildSignSelector(
                  selectedSign: selectedSign2,
                  onChanged: (sign) {
                    setState(() {
                      selectedSign2 = sign;
                    });
                  },
                ),
                SizedBox(height: 32),

                // Check Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _checkCompatibility,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'मिलान जांचें',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 24),

                // Result
                if (compatibilityResult != null)
                  Container(
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
                            Icon(Icons.favorite, color: Colors.pink, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'मिलान परिणाम',
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
                          compatibilityResult!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignSelector({
    required String? selectedSign,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedSign,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          dropdownColor: Colors.purple.shade700,
          style: TextStyle(color: Colors.white, fontSize: 16),
          hint: Text(
            'राशि चुनें',
            style: TextStyle(color: Colors.white70),
          ),
          items: ZodiacData.zodiacSigns.map((sign) {
            return DropdownMenuItem<String>(
              value: sign.name,
              child: Row(
                children: [
                  Text(sign.symbol, style: TextStyle(fontSize: 20)),
                  SizedBox(width: 12),
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
    );
  }
}

