import 'package:flutter/material.dart';

class LikeAniamationn extends StatefulWidget {
  final Widget child;
  final bool isanimateing;
  final Duration duration;
  final VoidCallback? onEnd;
  final bool smallLike;
  const LikeAniamationn(
      {super.key,
      required this.child,
      required this.isanimateing,
      this.duration = const Duration(microseconds: 150),
      this.onEnd,
      this.smallLike = false});

  @override
  State<LikeAniamationn> createState() => _LikeAniamationnState();
}

class _LikeAniamationnState extends State<LikeAniamationn>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(microseconds: widget.duration.inMilliseconds));
    scale = Tween<double>(
      begin: 1,
      end: 1.2,
    ).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAniamationn oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isanimateing != oldWidget.isanimateing) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isanimateing || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(
        const Duration(milliseconds: 200),
      );

      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
