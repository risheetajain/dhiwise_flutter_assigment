import 'package:dhiwise_flutter_assigment/main.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../apis/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.isLogin});
  final bool isLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = false;
  @override
  void initState() {
    super.initState();
    isLogin = widget.isLogin;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? "Login Screen" : "Sign Up Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value != null && isEmail(value)) {
                  return null;
                }
                return "Please enter valid Email Address";
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                  hintText: "Email ID", labelText: "Email ID"),
            ),
            const SizedBox(width: 10),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: passwordController,
              decoration: const InputDecoration(
                  hintText: "Password", labelText: "Password"),
              validator: (value) {
                if (value != null && value.length >= 6) {
                  return null;
                }
                return "Please enter at least 6 characters";
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please Enter Details");
                    return;
                  }

                  FirebaseAuthenication.selectLoginOrSIgnUp(
                          isLogin: isLogin,
                          email: emailController.text,
                          password: passwordController.text)
                      .then((val) {
                    Fluttertoast.showToast(msg: val ?? "");
                    if (val == "Successful") {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const MyHomePage()));
                    }
                  });
                },
                child: Text(
                  isLogin ? "Login" : "Sign Up",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            RichText(
                text: TextSpan(
                    text: isLogin
                        ? "Create a Account? "
                        : "Already have an account? ",
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    children: [
                  TextSpan(
                      text: isLogin ? "Sign Up" : "Login",
                      style: const TextStyle(
                          fontSize: 18, color: Colors.deepOrange),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        })
                ]))
          ],
        ),
      ),
    );
  }
}

bool isEmail(String email) {
  RegExp emailRegx = RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");
  return emailRegx.hasMatch(email.toLowerCase());
}
