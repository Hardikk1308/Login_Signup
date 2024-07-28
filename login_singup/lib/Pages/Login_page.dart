import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:login_singup/Pages/Signup_page.dart';
import '../Utils/Textbox.dart';
import 'package:http/http.dart' as http;

import 'Homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // VALIDATION
  bool _isValidate = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref;
  }

  Future<void> initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        _isValidate = false; // Reset validation flag
      });

      var loginUser = {
        "email": emailController.text,
        "password": passwordController.text,
      };

      // BACKEND INTEGRATION
      try {
        var response = await http.post(
          Uri.parse('http://192.168.45.101:3000/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(loginUser),
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          if (jsonResponse['Status']) {
            var myToken = jsonResponse['token'];
            prefs.setString('token', myToken);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  token: myToken,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                padding: EdgeInsets.all(20),
                backgroundColor: Colors.red,
                content: Text(
                  'Registration failed',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
              ),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
          ),
        );
      }
    } else {
      setState(() {
        _isValidate = true;
      });
    }
  }

  //BACKEND

  @override
  Widget build(BuildContext context) {
    // TO GET THE APP RESPONSIVE
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // CONSTANTS
    const style = TextStyle(
        color: Colors.black, fontSize: 40, fontWeight: FontWeight.w600);

    const style1 = TextStyle(
        color: Color.fromARGB(255, 18, 79, 43),
        fontSize: 20,
        fontWeight: FontWeight.w400);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Image.asset(
            'assets/images/leaf_1.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // WHITER CONTAINER
          ClipPath(
            clipper: Clip1Clipper(),
            child: Container(
              color: Colors.white70,
            ),
          ),

          // BACK BUTTON
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenHeight * 0.02, vertical: screenWidth * 0.1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(40),
              ),
              child: BackButton(
                  color: const Color(0xff092414),
                  onPressed: () => Navigator.pop(context)),
            ),
          ),

          // WELCOME TEXT
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.35,
                  left: screenHeight * 0.03,
                  right: screenHeight * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Welcome Back', style: style),
                  const Text('Log in to your account', style: style1),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),

                  // KEYBOARD OPERATORS

                  // Name
                  Column(
                    children: [
                      Textbox(
                        controller: emailController,
                        icons: Icons.email,
                        name: 'Email',
                        errormsg: _isValidate ? 'Please enter Email' : null,
                      ),

                      // PASSWORD
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Textbox(
                        controller: passwordController,
                        icons: Icons.lock,
                        name: 'Password',
                        errormsg: _isValidate ? 'Please enter Password' : null,
                      ),
                    ],
                  ),

                  // FORGOT PASSWORD BUTTON
                  Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.45),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: Color(0xff092414),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                  // LOGIN BUTTON
                  SizedBox(
                    height: screenHeight * 0.2,
                  ),
                  GestureDetector(
                    onTap: loginUser,
                    child: Center(
                      child: Container(
                        height: screenHeight * 0.06,
                        width: screenWidth * 0.85,
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 12, 48, 26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        child: const Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // FINAL TEXT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have the account?',
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),

                      // SIGNUP BUTTON
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signuppage(),
                              ));
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              color: Color(0xff092414),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// TO CLIP THE WHITE CONTAINER
class Clip1Clipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.height, size.width * -0.03);
    path.quadraticBezierTo(
        size.height * -0.02, size.height * 0.2, 0, size.width);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
