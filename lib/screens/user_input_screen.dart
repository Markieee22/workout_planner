import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

class UserInputScreen extends StatefulWidget {
  @override
  _UserInputScreenState createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  void _goToGoalSelection() {
    if (_formKey.currentState!.validate()) {
      double weight = double.parse(_weightController.text.trim());
      double height = double.parse(_heightController.text.trim()) / 100;
      double bmi = weight / (height * height);

      String category;
      String recommendation;

      if (bmi < 18.5) {
        category = "Underweight";
        recommendation = "We recommend muscle-gain workouts.";
      } else if (bmi >= 18.5 && bmi < 25) {
        category = "Fit";
        recommendation = "You are in a healthy range!";
      } else {
        category = "Overweight";
        recommendation = "Focus on weight-loss workouts.";
      }

      final user = UserModel(
        name: _usernameController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        weight: weight,
        height: height * 100,
      );

      Provider.of<UserProvider>(context, listen: false).setUser(user);

      Navigator.pushNamed(
        context,
        '/goal-selection',
        arguments: {
          'recommendation': recommendation,
          'category': category,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/fitness_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Let's Get Started!",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Enter your details to personalize your fitness journey.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  SizedBox(height: 30),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_usernameController, "Username", Icons.person, _validateUsername),
                        _buildTextField(_ageController, "Age", Icons.cake, _validateAge, isNumber: true),
                        _buildTextField(_weightController, "Weight (kg)", Icons.fitness_center, _validateWeight, isNumber: true),
                        _buildTextField(_heightController, "Height (cm)", Icons.height, _validateHeight, isNumber: true),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Next Button with Gradient Effect
                  GestureDetector(
                    onTap: _goToGoalSelection,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlue],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String? Function(String?) validator, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.white70, size: 28),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        ),
        validator: validator,
      ),
    );
  }

  // Validation Functions
  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return "Username is required.";
    if (value.length < 3) return "Username must be at least 3 characters long.";
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) return "Age is required.";
    final int? age = int.tryParse(value.trim());
    if (age == null || age < 10 || age > 100) return "Enter a valid age (10-100).";
    return null;
  }

  String? _validateWeight(String? value) {
    if (value == null || value.trim().isEmpty) return "Weight is required.";
    final double? weight = double.tryParse(value.trim());
    if (weight == null || weight < 30 || weight > 300) return "Enter a valid weight (30-300 kg).";
    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.trim().isEmpty) return "Height is required.";
    final double? height = double.tryParse(value.trim());
    if (height == null || height < 100 || height > 250) return "Enter a valid height (100-250 cm).";
    return null;
  }
}
