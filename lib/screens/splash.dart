import 'package:dhiwise_flutter_assigment/screens/login.dart';
import 'package:flutter/material.dart';

import '../apis/shared_pref.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SharedPref.getLoginStatus().then((value) {


      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (cotext) =>
              value ? const MyHomePage() : const LoginScreen(isLogin: true)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: FlutterLogo()));
  }
}
