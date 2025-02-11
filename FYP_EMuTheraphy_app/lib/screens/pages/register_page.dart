import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '/main.dart';
import '/colors.dart';
import '/model/user.dart';

class RegisterPage extends StatefulWidget {

  final Function() onClickLogIn;

  const RegisterPage({
    super.key,
    required this.onClickLogIn,

  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  PlatformFile? pickedImage;
  UploadTask? uploadTaskImage;
  String? imageUrlDB;

  Future uploadImage() async{

    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedImage = result.files.first;
    });

    final path = 'profileImage/${pickedImage!.name!}';
    final file = File(pickedImage!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTaskImage = ref.putFile(file);

    final snapshot = await uploadTaskImage!.whenComplete(() {});

    imageUrlDB = await snapshot.ref.getDownloadURL();
    print("link $imageUrlDB");
  }

  //form controllers
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();

  @override
  void dispose(){
    super.dispose();

    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondBGColor,
      appBar: AppBar(
        title: const Center(child: Text("Register as a User")),
        backgroundColor: mainBGColor,
      ),
      body: SingleChildScrollView(
        child:  Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Stack(
                  children: [
                    Image.asset("assets/images/default_user.png",
                      height: MediaQuery.of(context).size.width * 0.35,
                      width: MediaQuery.of(context).size.width * 0.35,
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: IconButton(onPressed: uploadImage,
                          icon: const Icon(Icons.add_a_photo,
                            size: 50,
                            color: mainFontColor,
                          )
                      ),
                    ),

                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.supervised_user_circle_outlined, color: mainFontColor,),
                    hintText: "Name",
                    hintStyle: TextStyle(
                      color: mainFontColor,
                      fontStyle: FontStyle.italic,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkOrangeColor),
                    ),
                  ),
                  onChanged: (value){},
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: mainFontColor,),
                    hintText: "E-Mail",
                    hintStyle: TextStyle(
                      color: mainFontColor,
                      fontStyle: FontStyle.italic,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkOrangeColor),
                    ),
                  ),
                  validator: (email) =>
                  email != null && !EmailValidator.validate(email)
                      ? 'Enter valid e-mail'
                      : null,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month, color: mainFontColor,),
                    hintText: "Age",
                    hintStyle: TextStyle(
                      color: mainFontColor,
                      fontStyle: FontStyle.italic,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkOrangeColor),
                    ),
                  ),
                  onChanged: (value){},
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                TextFormField(
                  controller: genderController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.emoji_people, color: mainFontColor,),
                    hintText: "Gender",
                    hintStyle: TextStyle(
                      color: mainFontColor,
                      fontStyle: FontStyle.italic,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkOrangeColor),
                    ),
                  ),
                  onChanged: (value){},
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password_rounded, color: mainFontColor,),
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: mainFontColor,
                      fontStyle: FontStyle.italic,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkOrangeColor),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? 'Enter min 6 characters'
                      : null,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.1,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: mainFontColor,
                      backgroundColor: mainBGColor,
                      elevation: 0,
                      minimumSize: Size(MediaQuery.of(context).size.width * 0.7, MediaQuery.of(context).size.width * 0.14),
                    ),
                    onPressed: (){
                      final user = UserData(
                        id: emailController.text.trim(),
                        name: nameController.text.trim(),
                        age: ageController.text.trim(),
                        gender: genderController.text.trim()
                      );
                      registerUser(user);
                    },
                    child: const Text("Register", style: TextStyle(fontSize: 18),)
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black54,
                        ),
                        text: 'Already have an account?   ',
                        children: [
                          TextSpan(
                            recognizer: TapGestureRecognizer()..onTap = widget.onClickLogIn,
                            text: 'Log In',
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
        ),
      ),
    );
  }

  Future registerUser(UserData user) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        user.id = userCredential.user!.uid; // Set Firestore doc ID to Firebase UID
        uploadUser(user);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }


  Future uploadUser(UserData user) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.id);
    final json = user.toJson();
    await userRef.set(json);
  }


}
