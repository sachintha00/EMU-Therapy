import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/main.dart';
import '/colors.dart';

class LogInPage extends StatefulWidget {

  final VoidCallback onClickRegister;

  const LogInPage({
    super.key,
    required this.onClickRegister,
  });

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose(){
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBGColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                alignment: Alignment.topLeft,
                child: Image.asset("assets/icons/l_icon_img.png"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              Image.asset('assets/images/l_img.png',
                height: MediaQuery.of(context).size.width * 0.65,
                width: MediaQuery.of(context).size.width * 0.65,
              ),
              Card(
                color: mainBGColor,
                elevation: 0,
                margin: EdgeInsets.zero,
                child: Column(
                    children: [Text(
                      "EMuTherapy",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        color: mainFontColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Music Therapy Application for Mood Fixing",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        color: mainFontColor,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ]
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.1,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: MediaQuery.of(context).size.width * 0.1),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined, color: mainFontColor,),
                          hintText: "User Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: mainBGColor,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: darkOrangeColor,
                              width: 2.0,
                            ),
                          ),
                          hintStyle: const TextStyle(
                            color: mainFontColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password, color: mainFontColor,),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: mainBGColor,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: darkOrangeColor,
                              width: 2.0,
                            ),
                          ),
                          hintStyle: const TextStyle(
                            color: mainFontColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: mainFontColor,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {

                          },
                          child: const Text('Forgot Password'),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: secondBGColor,
                          backgroundColor: darkOrangeColor,
                          minimumSize: Size(MediaQuery.of(context).size.width * 0.7, MediaQuery.of(context).size.width * 0.14),
                        ),
                          onPressed: (){
                            logIn();
                          },
                          child: const Text("Log In")
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            text: 'No account?   ',
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()..onTap = widget.onClickRegister,
                                text: 'Register',
                                style: const TextStyle(
                                  color: mainFontColor,
                                ),
                              )
                            ]
                          )
                      ),

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

  Future logIn() async{

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center( child: CircularProgressIndicator(),)
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);

  }
}
