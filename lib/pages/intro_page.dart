import 'package:flutter/material.dart';

import 'home_page.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                /* === === LOGO === === */
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 180,
                  color: Colors.black,
                ),
              ),


              /* === === SUB TITLE === === */
              const SizedBox(height: 120),
              Text(
                'Life\'s too short for boring notes. Get creative, get social with PostIt!',
                maxLines: 5,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  wordSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),

              /* === === START BUTTON === === */
              const SizedBox(height: 48),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'P O S T   I T   N O W',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
