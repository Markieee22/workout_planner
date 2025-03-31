import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController? _activeController; // Keeps track of the currently playing video

class StayFitWorkoutScreen extends StatelessWidget {
  final List<Map<String, dynamic>> workouts = [
    {
      "title": "Jumping Jacks",
      "description": "A full-body exercise to improve cardio and flexibility.",
      "video": "assets/videos/jumping_jacks.mp4",
      "sets": "3 sets of 30 seconds"
    },
    {
      "title": "Push-ups",
      "description": "Push-ups strengthen your arms and chest muscles.",
      "video": "assets/videos/push_ups.mp4",
      "sets": "3 sets of 12 reps"
    },
    {
      "title": "Burpees",
      "description": "A high-intensity exercise that works the entire body.",
      "video": "assets/videos/burpees.mp4",
      "sets": "3 sets of 10 reps"
    },
    {
      "title": "Squat Jumps",
      "description": "Improves lower body strength and explosiveness.",
      "video": "assets/videos/squat_jumps.mp4",
      "sets": "3 sets of 15 reps"
    },
    {
      "title": "High Knees",
      "description": "Boosts heart rate and improves endurance.",
      "video": "assets/videos/high_knees.mp4",
      "sets": "3 sets of 40 seconds"
    },
    {
      "title": "Mountain Climbers",
      "description": "Great for core strength and cardio.",
      "video": "assets/videos/mountain_climbers.mp4",
      "sets": "3 sets of 30 seconds"
    },
    {
      "title": "Lunges",
      "description": "Targets quads, hamstrings, and glutes.",
      "video": "assets/videos/lunges.mp4",
      "sets": "3 sets of 12 reps per leg"
    },
    {
      "title": "Plank",
      "description": "Improves core stability and endurance.",
      "video": "assets/videos/plank.mp4",
      "sets": "3 sets of 45 seconds"
    },
    {
      "title": "Bicycle Crunches",
      "description": "Strengthens abs and obliques.",
      "video": "assets/videos/bicycle_crunches.mp4",
      "sets": "3 sets of 20 reps (each side)"
    },
    {
      "title": "Side Plank",
      "description": "Engages the core and strengthens obliques.",
      "video": "assets/videos/side_plank.mp4",
      "sets": "3 sets of 30 seconds per side"
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
          title: Text("Stay Fit Workout"),
          backgroundColor: Colors.green.shade700,
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
              colors: [Colors.green.shade800, Colors.green.shade400],
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
                videoPath: workouts[index]["video"]!,
                sets: workouts[index]["sets"]!,
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
  final String videoPath;
  final String sets;

  WorkoutCard({
    required this.title,
    required this.description,
    required this.videoPath,
    required this.sets,
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

    _controller.addListener(() {
      setState(() {
        _isPlaying = _controller.value.isPlaying;
      });
    });
  }

  @override
  void dispose() {
    if (_activeController == _controller) {
      _activeController = null;
    }
    _controller.dispose();
    super.dispose();
  }

  void _toggleVideo() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      if (_activeController != null && _activeController != _controller) {
        _activeController!.pause();
      }

      _controller.play();
      _activeController = _controller;
    }
  }

  void _seekForward() {
    _controller.seekTo(_controller.value.position + Duration(seconds: 10));
  }

  void _seekBackward() {
    _controller.seekTo(_controller.value.position - Duration(seconds: 10));
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes);
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
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
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.replay_10, color: Colors.white, size: 30),
                      onPressed: _seekBackward,
                    ),
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        color: Colors.white,
                        size: 50,
                      ),
                      onPressed: _toggleVideo,
                    ),
                    IconButton(
                      icon: Icon(Icons.forward_10, color: Colors.white, size: 30),
                      onPressed: _seekForward,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(widget.description, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                SizedBox(height: 5),
                Text("Workout Plan: ${widget.sets}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
