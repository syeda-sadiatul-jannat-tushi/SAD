import 'package:flutter/material.dart';

class FloatingToy extends StatefulWidget {
  final IconData icon;
  final double left;
  final double top;
  final double size;

  const FloatingToy({
    super.key,
    required this.icon,
    required this.left,
    required this.top,
    this.size = 40,
  });

  @override
  State<FloatingToy> createState() => _FloatingToyState();
}

class _FloatingToyState extends State<FloatingToy>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -12,
      end: 12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.left,
          top: widget.top + _animation.value,
          child: IgnorePointer(
            child: Icon(
              widget.icon,
              size: widget.size,
              color: Colors.pink[200],
            ),
          ),
        );
      },
    );
  }
}
