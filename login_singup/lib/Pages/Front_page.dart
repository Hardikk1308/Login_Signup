import 'package:flutter/material.dart';
import 'package:login_singup/Pages/Login_page.dart';
import 'Signup_page.dart';

class First_page extends StatelessWidget {
  const First_page({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    const Style = TextStyle(
        color: Colors.white, fontSize: 60, fontWeight: FontWeight.w700);

    return Scaffold(
      body: Stack(
        children: [
          //IMAGE
          Image.asset(
            'assets/images/leaf_4.jpeg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          //TEXT
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.4, horizontal: screenHeight * 0.04),
            child: RichText(
              text: const TextSpan(text: 'The best', style: Style, children: [
                TextSpan(text: '           app for', style: Style),
                TextSpan(text: '           your plants', style: Style),
              ]),
            ),
          ),

          //BOTTONS
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Signuppage(),
                    )),
                child: Center(
                  child: Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.85,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: const Center(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.2),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      )),
                  child: Center(
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenWidth * 0.85,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 12, 48, 26),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: const Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
