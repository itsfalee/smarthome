import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_app_smarthome/component/custom_form_button.dart';
import 'package:flutter_app_smarthome/component/custom_input_field.dart';
import 'package:flutter_app_smarthome/component/page_header.dart';
import 'package:flutter_app_smarthome/component/page_heading.dart';
import 'package:flutter_app_smarthome/login/lyr_forget_password.dart';
import 'package:flutter_app_smarthome/login/lyr_homepage.dart';
import 'package:flutter_app_smarthome/login/lyr_register.dart';
import 'package:flutter_app_smarthome/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_smarthome/main.dart';
import 'package:flutter_app_smarthome/login/lyr_temperature.dart';
import 'package:flutter_app_smarthome/login/lyr_forget_password.dart';
import 'package:flutter_app_smarthome/login/lyr_homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//class _LoginPageState extends State<LoginPage> {
class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = true;

  @override
  Widget build(BuildContext context) {
    // myColor = Theme.of(context).primaryColorDark;
    mediaSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.teal,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 0, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage('assets/images/bannerr.png'),
            fit: BoxFit.cover,
            width: 400,
            height: 180,
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "LOGIN",
          style: TextStyle(
              color: Colors.teal, fontSize: 32, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 40),
        Text(
          "Username/Email",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        _buildInputField1(emailController),
        const SizedBox(height: 40),
        Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
        _buildInputField(passwordController, isPassword: true,),
        const SizedBox(height: 20),
        _buildRememberForgot(),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 20),
        _buildRegister(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText:
            'Enter your password',
            isDense: true,
        suffixIcon: isPassword
            ?  IconButton(onPressed: _toggleVisibility, icon: _isHidden ? Icon(Icons.visibility_off): Icon(Icons.visibility),)
            :const Icon(Icons.person_rounded)
           ),
      obscureText: _isHidden,
    );
  }

   Widget _buildInputField1(TextEditingController controller,
     ) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        hintText: 'Enter your username/email',
            isDense: true,
        suffixIcon: Icon(Icons.person_rounded)
           ),
      obscureText: false,
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [              
         Container(
          //width: size.width * 0.80,
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForgetPasswordPage ()))
            },
            child: const Text(
              'Forget password?',
              style: TextStyle(
                color: Color(0xff939393),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );

          // If login is successful, navigate to the home page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } on FirebaseAuthException catch (e) {
          // Handle login errors
          String errorMessage = 'Login failed.';

          if (e.code == 'user-not-found') {
            errorMessage = 'No user found for that email.';
          } else if (e.code == 'wrong-password') {
            errorMessage = 'Wrong password provided for that user.';
          }

          final snackBar = SnackBar(
            content: Text(errorMessage),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        backgroundColor: Colors.teal,
        minimumSize: const Size.fromHeight(50),
      ),
      child: const Text(
        "LOGIN",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t have an account ? ',
            style: TextStyle(
                fontSize: 13,
                color: Color(0xff939393),
                fontWeight: FontWeight.bold)),
        Container(
          //width: size.width * 0.80,
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Register()))
            },
            child: const Text(
              'Register',
              style: TextStyle(
                color: Color(0xff939393),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

 }