import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'workout_screens/lose_weight_workout.dart';
import 'workout_screens/gain_muscle_workout.dart' as gainMuscle;
import 'workout_screens/stay_fit_workout.dart' as stayFit;
import 'settings_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  final String recommendation;

  GoalSelectionScreen({required this.recommendation});

  @override
  _GoalSelectionScreenState createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  late String _selectedGoal;
  late String _workoutAdvice;
  late String _dietAdvice;

  @override
  void initState() {
    super.initState();
    _selectedGoal = _autoSelectGoal(widget.recommendation);
    _updateAdvice(_selectedGoal);
  }

  // Auto-selects fitness goal based on BMI category
  String _autoSelectGoal(String recommendation) {
    if (recommendation.contains("Gain Weight")) return "Gain Muscle";
    if (recommendation.contains("Lose Weight")) return "Lose Weight";
    return "Stay Fit";
  }

  // Updates workout and diet advice
  void _updateAdvice(String goal) {
    setState(() {
      _workoutAdvice = _generateWorkoutAdvice(goal);
      _dietAdvice = _generateDietAdvice(goal);
    });
  }

  // Generates realistic workout advice
  String _generateWorkoutAdvice(String goal) {
    switch (goal) {
      case "Lose Weight":
        return "🔥 High-intensity workouts (HIIT, cardio) burn fat efficiently. "
            "Include resistance training 3-4 times per week for lean muscle retention. "
            "Maintain at least 10,000 steps daily for optimal calorie burn.";
      case "Gain Muscle":
        return "💪 Strength training (progressive overload) 4-5 times per week is key. "
            "Focus on compound movements (squats, deadlifts, bench press). "
            "Ensure proper recovery and aim for 7-9 hours of sleep.";
      case "Stay Fit":
      default:
        return "🏃 A balanced mix of strength training and cardiovascular endurance is ideal. "
            "Engage in functional workouts, flexibility training, and mobility exercises. "
            "Prioritize active recovery to prevent injuries.";
    }
  }

  // Generates professional diet advice
  String _generateDietAdvice(String goal) {
    switch (goal) {
      case "Lose Weight":
        return "🥗 Focus on a high-protein, low-carb diet with healthy fats. "
            "Eat whole, nutrient-dense foods, and avoid processed sugars. "
            "Hydration is crucial—drink at least 3 liters of water daily.";
      case "Gain Muscle":
        return "🍗 Increase protein intake (1.2-2.2g per kg of body weight). "
            "Consume complex carbs (brown rice, quinoa) to fuel workouts. "
            "Eat every 3-4 hours to support muscle growth and recovery.";
      case "Stay Fit":
      default:
        return "🥑 Maintain a balanced macronutrient intake. "
            "Include fiber-rich foods for gut health. "
            "Prioritize micronutrients for optimal body function and longevity.";
    }
  }

  // Navigate directly to the selected workout screen
  void _goToWorkoutScreen() {
    Widget screen;

    if (_selectedGoal == "Lose Weight") {
      screen = LoseWeightWorkoutScreen();
    } else if (_selectedGoal == "Gain Muscle") {
      screen = gainMuscle.GainMuscleWorkoutScreen();
    } else {
      screen = stayFit.StayFitWorkoutScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "YOUR FITNESS PLAN",
          style: GoogleFonts.bebasNeue(
            fontSize: 28,
            letterSpacing: 2,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 4, color: Colors.black38, offset: Offset(2, 2))],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Recommended Fitness Plan",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),

              _buildRecommendationBox("Workout Advice", _workoutAdvice),
              SizedBox(height: 15),
              _buildRecommendationBox("Diet Advice", _dietAdvice),

              SizedBox(height: 25),

              Container(
                width: screenWidth * 0.8,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGoal,
                    dropdownColor: Colors.white,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade900),
                    style: GoogleFonts.montserrat(fontSize: 18, color: Colors.black),
                    items: [
                      DropdownMenuItem(value: "Lose Weight", child: Text("Lose Weight")),
                      DropdownMenuItem(value: "Gain Muscle", child: Text("Gain Muscle")),
                      DropdownMenuItem(value: "Stay Fit", child: Text("Stay Fit")),
                    ],
                    onChanged: (value) {
                      _updateAdvice(value!);
                      setState(() => _selectedGoal = value);
                    },
                  ),
                ),
              ),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _goToWorkoutScreen,
                child: Text("Proceed", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationBox(String title, String content) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(content, style: GoogleFonts.montserrat(fontSize: 16)),
        ],
      ),
    );
  }
}
