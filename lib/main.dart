import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/user_input_screen.dart';
import 'screens/goal_selection_screen.dart';
import 'screens/workout_screens/lose_weight_workout.dart';
import 'screens/workout_screens/gain_muscle_workout.dart' as gainMuscle;
import 'screens/workout_screens/stay_fit_workout.dart' as stayFit;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => UserInputScreen());
          case '/goal-selection':
            final args = settings.arguments as Map<String, String>? ?? {};
            return MaterialPageRoute(
              builder: (context) => GoalSelectionScreen(
                recommendation: args['recommendation'] ?? "Stay Fit Workouts are ideal!",
              ),
            );
          case '/lose-weight':
            return MaterialPageRoute(builder: (context) => LoseWeightWorkoutScreen());
          case '/gain-muscle':
            return MaterialPageRoute(builder: (context) => gainMuscle.GainMuscleWorkoutScreen());
          case '/stay-fit':
            return MaterialPageRoute(builder: (context) => stayFit.StayFitWorkoutScreen());
          default:
            return MaterialPageRoute(builder: (context) => UserInputScreen());
        }
      },
    );
  }
}
