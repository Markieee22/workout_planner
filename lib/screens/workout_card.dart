import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class WorkoutCard extends StatefulWidget {
  final String title;
  final String videoPath;
  final String description;
  final int duration;
  final Function(VideoPlayerController, ChewieController) onVideoPlay;

  WorkoutCard({
    required this.title,
    required this.videoPath,
    required this.description,
    required this.duration,
    required this.onVideoPlay,
  });

  @override
  _WorkoutCardState createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  Timer? _timer;
  int _timeRemaining = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoController,
            autoPlay: false,
            looping: false,
          );
        });
      });
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) return; // Prevent multiple timers

    setState(() {
      _timeRemaining = widget.duration;
      _isPlaying = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _togglePlayPause() {
    if (_videoController.value.isPlaying) {
      _videoController.pause();
      _timer?.cancel();
      setState(() {
        _isPlaying = false;
      });
    } else {
      widget.onVideoPlay(_videoController, _chewieController!);
      _videoController.play();
      _startTimer();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _rewind() {
    _videoController.seekTo(Duration(seconds: (_videoController.value.position.inSeconds - 10).clamp(0, widget.duration)));
  }

  void _forward() {
    _videoController.seekTo(Duration(seconds: (_videoController.value.position.inSeconds + 10).clamp(0, widget.duration)));
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(widget.description, style: TextStyle(color: Colors.grey[700])),
            SizedBox(height: 10),
            _videoController.value.isInitialized && _chewieController != null
                ? Column(
                    children: [
                      AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: Chewie(controller: _chewieController!),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.replay_10),
                            onPressed: _rewind,
                          ),
                          IconButton(
                            icon: Icon(_videoController.value.isPlaying ? Icons.pause : Icons.play_arrow),
                            onPressed: _togglePlayPause,
                          ),
                          IconButton(
                            icon: Icon(Icons.forward_10),
                            onPressed: _forward,
                          ),
                        ],
                      )
                    ],
                  )
                : Container(
                    height: 200,
                    color: Colors.black12,
                    child: Center(child: CircularProgressIndicator()),
                  ),
            SizedBox(height: 10),
            _isPlaying
                ? Text("Time Remaining: $_timeRemaining s", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                : ElevatedButton(
                    onPressed: _startTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Start Workout", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
          ],
        ),
      ),
    );
  }
}
