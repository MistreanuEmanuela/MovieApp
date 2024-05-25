import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedDialog extends StatefulWidget {
  final String message;
  final IconData icon;
  final Duration duration;

  AnimatedDialog({
    required this.message,
    required this.icon,
    this.duration = const Duration(seconds: 3),
  });

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Start timer to automatically dismiss dialog
    _timer = Timer(widget.duration, () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 60,
                color: Colors.red, // You can change the color if needed
              ),
              SizedBox(height: 20),
              Text(
                widget.message,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
             
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }
}
