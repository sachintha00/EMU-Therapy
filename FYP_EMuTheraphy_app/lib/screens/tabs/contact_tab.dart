import 'package:flutter/material.dart';

import '/colors.dart';

class ContactTab extends StatelessWidget {
  const ContactTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Music Therapist", style: TextStyle(fontSize: 22,
                      color: mainFontColor,
                      fontWeight: FontWeight.bold,),)
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Music Therapist Name',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: mainFontColor),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Dr. Ajith Kumara',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Contact Number',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: mainFontColor),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '+94 71 421 2378',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          'E-Mail',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: mainFontColor),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'ajithkumara@gmail.com',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    Expanded(
                        child: Image.asset("assets/images/contact_t_img.png")
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Developer Details", style: TextStyle(fontSize: 22,
                      color: mainFontColor,
                      fontWeight: FontWeight.bold,),)
                ),
              ),
             Container(
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: Colors.white,
               ),
               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
               child: Row(
                 children: [
                   const Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       SizedBox(
                         height: 25,
                       ),
                       Text(
                         'Name',
                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: mainFontColor),
                       ),
                       SizedBox(
                         height: 5,
                       ),
                       Text(
                         'Kusal Jayasanka',
                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                       ),
                       SizedBox(
                         height: 25,
                       ),
                       Text(
                         'Contact Number',
                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: mainFontColor),
                       ),
                       SizedBox(
                         height: 5,
                       ),
                       Text(
                         '+94 70 377 1834',
                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                       ),
                       SizedBox(
                         height: 25,
                       ),
                       Text(
                         'E-Mail',
                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: mainFontColor),
                       ),
                       SizedBox(
                         height: 5,
                       ),
                       Text(
                         'jayasankaw@sltc.ac.lk',
                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                       ),
                       SizedBox(
                         height: 20,
                       ),
                     ],
                   ),
                   Expanded(
                       child: Image.asset("assets/images/contact_d_img.png")
                   ),
                 ],
               ),
             )
    ]
        ),
      ),
    );

  }
}
