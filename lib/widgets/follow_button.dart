import 'package:flutter/material.dart';
import 'package:instagrem/utils/colors.dart';

class FollowButton extends StatelessWidget {
  final String label;
  final void Function()? onPressed;
  const FollowButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: TextButton(
        onPressed: onPressed,
        child: Container(
          width: 250,
          height: 27,
          decoration: BoxDecoration(
            color: blueColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
