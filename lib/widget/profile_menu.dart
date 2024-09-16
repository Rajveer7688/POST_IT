import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:post_it/pages/no_action.dart';

class ProfileMenu extends StatelessWidget {
  final String title;
  final String value;
  final bool onPressed;

  const ProfileMenu({
    super.key,
    required this.title,
    required this.value,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(onPressed) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NoAction()));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: AutoSizeText(
                title,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: AutoSizeText(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
