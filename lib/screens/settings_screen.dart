import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/user_provider.dart';
import 'edit_profile_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<DateTime, bool> workoutDays = {}; // Store workout days
  DateTime _selectedDay = DateTime.now(); // Track selected day
  String? _avatarPath; // Store avatar image path

  @override
  void initState() {
    super.initState();
    _loadAvatar();
    _loadWorkoutDays();
  }

  /// Load the saved avatar from SharedPreferences
  Future<void> _loadAvatar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarPath = prefs.getString("profile_image");
    });
  }

  /// Load saved workout days from SharedPreferences
  Future<void> _loadWorkoutDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedWorkoutDays = prefs.getString("workout_days");
    if (savedWorkoutDays != null) {
      Map<String, dynamic> decodedDays = jsonDecode(savedWorkoutDays);
      setState(() {
        workoutDays = decodedDays.map((key, value) => MapEntry(DateTime.parse(key), value));
      });
    }
  }

  /// Save workout days to SharedPreferences
  Future<void> _saveWorkoutDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, bool> stringKeyedDays =
        workoutDays.map((key, value) => MapEntry(key.toIso8601String(), value));
    await prefs.setString("workout_days", jsonEncode(stringKeyedDays));
  }

  /// Toggle workout day and save the changes
  void _toggleWorkoutDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    setState(() {
      if (workoutDays.containsKey(normalizedDay)) {
        workoutDays.remove(normalizedDay);
      } else {
        workoutDays[normalizedDay] = true;
      }
    });
    _saveWorkoutDays(); // Save the updated workout days
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile & Settings", style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _avatarPath != null ? FileImage(File(_avatarPath!)) : null,
                      child: _avatarPath == null
                          ? Icon(Icons.person, size: 50, color: Colors.grey[700])
                          : null,
                    ),
                    SizedBox(height: 10),
                    Text(
                      user?.name ?? "User Name",
                      style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Profile Information
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                color: Colors.grey[100],
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProfileRow(Icons.cake, "Age", "${user?.age ?? 0} years"),
                      Divider(color: Colors.grey[300]),
                      _buildProfileRow(Icons.fitness_center, "Weight", "${user?.weight ?? 0} kg"),
                      Divider(color: Colors.grey[300]),
                      _buildProfileRow(Icons.height, "Height", "${user?.height ?? 0} cm"),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),

              // Workout Calendar
              Text(
                "Workout Calendar",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                color: Colors.grey[100],
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 350),
                    child: SingleChildScrollView(
                      child: TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime(2024, 1, 1),
                        lastDay: DateTime(2030, 12, 31),
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        calendarStyle: CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          defaultTextStyle: GoogleFonts.poppins(color: Colors.black),
                          weekendTextStyle: GoogleFonts.poppins(color: Colors.redAccent),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: GoogleFonts.poppins(color: Colors.redAccent),
                          weekdayStyle: GoogleFonts.poppins(color: Colors.black),
                        ),
                        selectedDayPredicate: (day) {
                          DateTime normalizedDay = DateTime(day.year, day.month, day.day);
                          return workoutDays.containsKey(normalizedDay);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          _toggleWorkoutDay(selectedDay);
                        },
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Edit Profile Button
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text("Edit Profile", style: GoogleFonts.poppins(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfileScreen()),
                    );
                    _loadAvatar(); // Refresh avatar after editing
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          SizedBox(width: 15),
          Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
          Spacer(),
          Text(value, style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
