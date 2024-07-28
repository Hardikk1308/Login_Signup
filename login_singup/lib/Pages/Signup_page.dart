import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Utils/Textbox.dart';
// import 'package:login_singup/config.dart';
import 'Homepage.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  // CONTROLLERS
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // VALIDATION
  bool _isValidate = false;

  Future<void> regbody() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        numberController.text.isNotEmpty) {
      setState(() {
        _isValidate = false; // Reset validation flag
      });

      var regbody = {
        "email": emailController.text,
        "password": passwordController.text,
        "fullname": nameController.text,
        "phonenumber": numberController.text
      };

      // BACKEND INTEGRATION
      try {
        var response = await http.post(
          Uri.parse('http://192.168.45.101:3000/registration'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regbody),
        );

        if (response.statusCode == 200) {
          var jsonResponse = jsonDecode(response.body);
          print(jsonResponse);
          Navigator.push(
            context,
            MaterialPageRoute(
              // ignore: missing_required_param
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
            padding: EdgeInsets.all(20),
            backgroundColor: Colors.red,
              content: Text('Registration failed',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
            ),
          );
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

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    // CONSTANTS
    const style = TextStyle(
        color: Colors.black, fontSize: 40, fontWeight: FontWeight.w600);

    const style1 = TextStyle(
        color: Color.fromARGB(255, 18, 79, 43),
        fontSize: 18,
        fontWeight: FontWeight.w500);
    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Image.asset(
            'assets/images/leaf_2.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // WHITE CONTAINER
          ClipPath(
            clipper: Clip1Clipper(),
            child: Container(
              color: Colors.white70,
            ),
          ),

          // FORM CONTAINER
          SizedBox(
            height: screenHeight * 0.02,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.39,
                  left: screenHeight * 0.03,
                  right: screenHeight * 0.03),
              child: Column(
                children: [
                  const Text(
                    'Register',
                    style: style,
                  ),
                  const Text(
                    'Create your new account',
                    style: style1,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // EMAIL TEXTBOX
                  Textbox(
                    controller: emailController,
                    icons: Icons.mail,
                    name: 'Email',
                    errormsg: _isValidate ? 'Please enter Email' : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // FULL NAME TEXTBOX
                  Textbox(
                    controller: nameController,
                    icons: Icons.person,
                    name: 'Full name',
                    errormsg: _isValidate ? 'Please enter Full name' : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // PHONE NUMBER TEXTBOX
                  Textbox(
                    controller: numberController,
                    icons: Icons.call,
                    name: 'Phone number',
                    errormsg: _isValidate ? 'Please enter Phone number' : null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // PASSWORD TEXTBOX
                  Textbox(
                    controller: passwordController,
                    icons: Icons.lock,
                    name: 'Create password',
                    errormsg: _isValidate ? 'Please enter Password' : null,
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // SIGNUP BUTTON
                  GestureDetector(
                    onTap: regbody,
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
                            'Signup',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // FINAL TEXT
                  Text(
                    'By signing you agree to terms and \n      use and the privacy notice',
                    style: TextStyle(
                        fontSize: screenHeight * 0.018,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87),
                  )
                ],
              ),
            ),
          ),
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
    path.lineTo(size.height, size.width);
    path.quadraticBezierTo(size.height * 0.05, size.width, 0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
