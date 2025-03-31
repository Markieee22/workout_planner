import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

VideoPlayerController? _activeController; // Track the currently playing video

class WorkoutCard extends StatefulWidget {
  final String title;
  final String description;
  final String videoPath;
  final String thumbnailPath;

  WorkoutCard({
    required this.title,
    required this.description,
    required this.videoPath,
    required this.thumbnailPath,
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
        _activeController!.pause(); // Pause the currently playing video
      }
      _controller.play();
      _activeController = _controller; // Set the active controller
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
                    : Image.asset(
                        widget.thumbnailPath,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
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
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  widget.description,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
