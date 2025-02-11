import 'package:flutter/material.dart';

import '/screens/pages/login_page.dart';
import '/screens/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LogInPage(onClickRegister: toggle,)
      : RegisterPage(onClickLogIn: toggle);

  void toggle() => setState(() {
    isLogin = !isLogin;
  });
}
