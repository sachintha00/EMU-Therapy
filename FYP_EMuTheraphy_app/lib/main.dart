import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/pages/home_page.dart';
import 'screens/pages/auth_page.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBUf-FpjSkFtUVhfu5J9a4AK4CIFFqF9-E",
        appId: "1:259205197945:android:491c91ce6488ffe48124a8",
        messagingSenderId: "259205197945",
        storageBucket: "socially-28072.appspot.com",
        projectId: "socially-28072",

      ))
      : await Firebase.initializeApp();
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      // home: HomePage(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState){
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError){
            return const Center(child: Text("Something went wrong.."),);
          } else if (snapshot.hasData){
            return const HomePage();
          }else{
            return const AuthPage();
          }
        }
      ),
    );
  }
}