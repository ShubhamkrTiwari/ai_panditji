import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/zodiac_data.dart';
import '../models/horoscope_model.dart';

class BirthChartScreen extends StatefulWidget {
  const BirthChartScreen({super.key});

  @override
  State<BirthChartScreen> createState() => _BirthChartScreenState();
}

class _BirthChartScreenState extends State<BirthChartScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _birthDate;
  TimeOfDay? _birthTime;
  final TextEditingController _birthPlaceController = TextEditingController();
  ZodiacSign? _zodiacSign;

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('hi', 'IN'),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _zodiacSign = ZodiacData.getZodiacByDate(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _birthTime = picked;
      });
    }
  }

  void _generateChart() {
    if (_nameController.text.isEmpty ||
        _birthDate == null ||
        _birthTime == null ||
        _birthPlaceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('कृपया सभी जानकारी भरें')),
      );
      return;
    }

    // Show chart result
    showDialog(
      context: context,
      builder: (context) => _buildChartDialog(),
    );
  }

  Widget _buildChartDialog() {
    return AlertDialog(
      title: Text('जन्म कुंडली'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('नाम', _nameController.text),
            _buildInfoRow(
              'जन्म तिथि',
              DateFormat('dd/MM/yyyy').format(_birthDate!),
            ),
            _buildInfoRow(
              'जन्म समय',
              '${_birthTime!.hour}:${_birthTime!.minute}',
            ),
            _buildInfoRow('जन्म स्थान', _birthPlaceController.text),
            if (_zodiacSign != null) ...[
              Divider(),
              _buildInfoRow('राशि', _zodiacSign!.hindiName),
              _buildInfoRow('प्रतीक', _zodiacSign!.symbol),
              _buildInfoRow('तत्व', _zodiacSign!.element),
              _buildInfoRow('ग्रह', _zodiacSign!.planet),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('बंद करें'),
        ),
      ],
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
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
              Colors.orange.shade900,
              Colors.orange.shade700,
              Colors.deepOrange.shade300,
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
                        'जन्म कुंडली',
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

                // Form
                _buildTextField(
                  controller: _nameController,
                  label: 'नाम',
                  hint: 'अपना नाम दर्ज करें',
                  icon: Icons.person,
                ),
                SizedBox(height: 16),

                _buildDateField(
                  label: 'जन्म तिथि',
                  value: _birthDate != null
                      ? DateFormat('dd/MM/yyyy').format(_birthDate!)
                      : null,
                  onTap: _selectDate,
                  icon: Icons.calendar_today,
                ),
                SizedBox(height: 16),

                _buildDateField(
                  label: 'जन्म समय',
                  value: _birthTime != null
                      ? '${_birthTime!.hour}:${_birthTime!.minute.toString().padLeft(2, '0')}'
                      : null,
                  onTap: _selectTime,
                  icon: Icons.access_time,
                ),
                SizedBox(height: 16),

                _buildTextField(
                  controller: _birthPlaceController,
                  label: 'जन्म स्थान',
                  hint: 'जन्म स्थान दर्ज करें',
                  icon: Icons.location_on,
                ),
                SizedBox(height: 32),

                // Zodiac Preview
                if (_zodiacSign != null)
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _zodiacSign!.symbol,
                          style: TextStyle(fontSize: 48),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _zodiacSign!.hindiName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                _zodiacSign!.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 32),

                // Generate Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _generateChart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'कुंडली बनाएं',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(icon, color: Colors.white70),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String? value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white70),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value ?? 'चुनें',
                    style: TextStyle(
                      color: value != null ? Colors.white : Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white70),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

