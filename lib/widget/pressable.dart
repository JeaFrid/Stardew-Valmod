import 'package:flutter/material.dart';

class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scale;
  final Duration duration;
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scale = 0.94,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  double _currentScale = 1.0;
  bool _longPressTriggered = false;

  void _animate(bool down) {
    setState(() => _currentScale = down ? widget.scale : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animate(true),
      onTapUp: (_) {
        _animate(false);
        if (_longPressTriggered) {
          _longPressTriggered = false;
          return;
        }
        Future.delayed(widget.duration, () {
          if (widget.onTap != null) widget.onTap!();
        });
      },
      onTapCancel: () {
        _animate(false);
        _longPressTriggered = false;
      },
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              _longPressTriggered = true;
              if (widget.onLongPress == null) return;
              widget.onLongPress!();
            },
      child: AnimatedScale(
        scale: _currentScale,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
