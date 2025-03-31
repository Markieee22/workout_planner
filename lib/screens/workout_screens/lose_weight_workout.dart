import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoseWeightWorkoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> workouts = [
    {
      "title": "Jumping Jacks",
      "description": "A full-body exercise that gets your heart rate up and burns calories quickly.",
      "sets": "4 sets of 30 seconds",
      "video": "assets/videos/jumping_jacks.mp4",
    },
    {
      "title": "Burpees",
      "description": "A high-intensity full-body movement that enhances strength and endurance.",
      "sets": "3 sets of 12 reps",
      "video": "assets/videos/burpees.mp4",
    },
    {
      "title": "Mountain Climbers",
      "description": "A cardio and core workout that strengthens the abs and improves agility.",
      "sets": "4 sets of 30 seconds",
      "video": "assets/videos/mountain_climbers.mp4",
    },
    {
      "title": "High Knees",
      "description": "A fat-burning cardio exercise that also builds leg strength.",
      "sets": "3 sets of 40 reps (20 per leg)",
      "video": "assets/videos/high_knees.mp4",
    },
    {
      "title": "Squat Jumps",
      "description": "An explosive lower-body workout that improves strength and burns calories.",
      "sets": "4 sets of 10 reps",
      "video": "assets/videos/squat_jumps.mp4",
    },
    {
      "title": "Lunges",
      "description": "A classic leg and glute workout that enhances lower-body endurance.",
      "sets": "3 sets of 12 reps (each leg)",
      "video": "assets/videos/lunges.mp4",
    },
    {
      "title": "Plank to Shoulder Taps",
      "description": "A core-strengthening movement that also enhances balance and stability.",
      "sets": "3 sets of 20 taps (10 per side)",
      "video": "assets/videos/plank_shoulder_taps.mp4",
    },
    {
      "title": "Flutter Kicks",
      "description": "A lower-ab exercise that tones the core and strengthens the hip flexors.",
      "sets": "4 sets of 30 seconds",
      "video": "assets/videos/flutter_kicks.mp4",
    },
    {
      "title": "Side Leg Raises",
      "description": "A simple yet effective move to tone your thighs and strengthen your hips.",
      "sets": "3 sets of 15 reps (each leg)",
      "video": "assets/videos/side_leg_raises.mp4",
    },
    {
      "title": "Standing Side Crunches",
      "description": "A core exercise that engages the obliques and burns belly fat.",
      "sets": "3 sets of 20 reps (10 per side)",
      "video": "assets/videos/standing_side_crunches.mp4",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/goal-selection');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lose Weight Workout"),
          backgroundColor: Colors.blue.shade700,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/goal-selection');
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.blue.shade400],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              return WorkoutCard(
                title: workouts[index]["title"]!,
                description: workouts[index]["description"]!,
                sets: workouts[index]["sets"]!,
                videoPath: workouts[index]["video"]!,
              );
            },
          ),
        ),
      ),
    );
  }
}

class WorkoutCard extends StatefulWidget {
  final String title;
  final String description;
  final String sets;
  final String videoPath;

  WorkoutCard({
    required this.title,
    required this.description,
    required this.sets,
    required this.videoPath,
  });

  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleVideo() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.9),
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : Container(
                        height: 180,
                        color: Colors.black,
                      ),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  size: 50,
                  color: Colors.white,
                ),
                onPressed: _toggleVideo,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 5),
                Text(
                  "Workout Plan: ${widget.sets}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
