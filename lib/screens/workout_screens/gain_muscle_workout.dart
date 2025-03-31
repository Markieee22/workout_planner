import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GainMuscleWorkoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> workouts = [
    {
      "title": "Bench Press",
      "description": "A compound movement that primarily targets your chest, triceps, and shoulders. Keep your back flat and lower the bar to your mid-chest.",
      "sets": "4 sets of 8 reps",
      "video": "assets/videos/bench_press.mp4"
    },
    {
      "title": "Deadlifts",
      "description": "Engages your lower back, hamstrings, glutes, and core. Maintain a straight back and drive through your heels.",
      "sets": "4 sets of 6 reps",
      "video": "assets/videos/deadlift.mp4"
    },
    {
      "title": "Pull-ups",
      "description": "A great upper-body exercise that strengthens the lats, biceps, and forearms. Use a controlled motion.",
      "sets": "3 sets of 10 reps",
      "video": "assets/videos/pull_ups.mp4"
    },
    {
      "title": "Squats",
      "description": "Develops leg strength, core stability, and overall power. Keep your knees aligned and lower until thighs are parallel.",
      "sets": "4 sets of 10 reps",
      "video": "assets/videos/squats.mp4"
    },
    {
      "title": "Lunges",
      "description": "Builds leg strength and balance by targeting quads, hamstrings, and glutes. Keep your torso upright.",
      "sets": "3 sets of 12 reps (each leg)",
      "video": "assets/videos/lunges.mp4"
    },
    {
      "title": "Shoulder Press",
      "description": "Strengthens shoulders and upper arms. Keep your core engaged and press the weights overhead.",
      "sets": "4 sets of 8 reps",
      "video": "assets/videos/shoulder_press.mp4"
    },
    {
      "title": "Bicep Curls",
      "description": "Targets and isolates the biceps. Use controlled movements and avoid swinging your arms.",
      "sets": "3 sets of 12 reps",
      "video": "assets/videos/bicep_curls.mp4"
    },
    {
      "title": "Triceps Dips",
      "description": "Works the triceps and shoulders. Lower yourself slowly for maximum activation.",
      "sets": "3 sets of 10 reps",
      "video": "assets/videos/triceps_dips.mp4"
    },
    {
      "title": "Calf Raises",
      "description": "Strengthens and tones the calves. Hold at the top position for a second before lowering.",
      "sets": "4 sets of 15 reps",
      "video": "assets/videos/calf_raises.mp4"
    },
    {
      "title": "Plank",
      "description": "A core endurance exercise that strengthens the entire body. Keep your spine neutral and hold position.",
      "sets": "3 sets of 45 seconds",
      "video": "assets/videos/plank.mp4"
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
          title: Text("Gain Muscle Workout"),
          backgroundColor: Colors.red.shade700,
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
              colors: [Colors.red.shade800, Colors.red.shade400],
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
