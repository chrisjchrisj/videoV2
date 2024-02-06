import 'package:flutter/material.dart';
import 'package:video/view/sign%20up/components/signup_body.dart';
import '../../res/app_color.dart';
class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  State<SignUp> createState() => _SignUpState();
}
class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: darkBackgroundColor,
      body: SafeArea(
        child: SignupBody(),
      ),
    );
  }
}
