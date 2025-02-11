import 'dart:ffi';

import '/colors.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainBGColor,
        body: Stack(
          children: [
            Positioned(
              top: 30,
              left: 20,
              child: Image.asset('assets/icons/l_icon_img.png'),
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Image.asset('assets/images/l_img.png',height: 300, width: 300,),
            ),
            const Positioned(
                top: 450,
                left: 20,
                child: Text("EMuTherapy", style: TextStyle(fontSize: 34, color: mainFontColor, fontWeight: FontWeight.bold,))
            ),
            const Positioned(
                top: 500,
                left: 20,
                child: Text("Music Therapy Application for Mood Fixing", style: TextStyle(fontSize: 18, color: mainFontColor, fontWeight: FontWeight.w400,))
            ),
            Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: 50,
                    height: 70,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(darkOrangeColor)
                      ),
                      onPressed: () {
                      // add your button onPressed logic here
                      },
                      child: const Text('Get Started', style: TextStyle(fontSize: 24, color: Colors.white))
                    )
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}
