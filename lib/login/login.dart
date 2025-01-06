import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ward/login/bg_video_widget.dart';
import 'package:ward/login/auth_service_google.dart';
import 'package:ward/login/phone_auth_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _authService =
      AuthService(); // Use AuthService instead of FirebaseAuth
  bool isLoading = false; // Track loading state

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double containerResponsiveHeight() {
      if (screenHeight < 600) {
        return screenHeight * 0.5;
      } else {
        return screenHeight * 0.3;
      }
    }

    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        const BackgroundVideoWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: containerResponsiveHeight(),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      'Welcome to Ward !',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Tajawal',
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      'Sign In to Continue.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildInputContainer(
                    FontAwesomeIcons.squarePhone,
                    'Continue with phone number',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyPhone()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildInputContainer(
                    FontAwesomeIcons.google,
                    'Continue with Google',
                    onTap: () async {
                      setState(() {
                        isLoading = true; // Show loading indicator
                      });
                      await _authService.handleGoogleSignIn(context);
                      setState(() {
                        isLoading = false; // Hide loading indicator after sign-in
                      });
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ),
        if (isLoading)
          const ModalBarrier(
            dismissible: false,
            color: Colors.black38,
          ), //if user press
        if (isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                width: screenWidth,
                height: 70,
                child: const Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    SizedBox(
                      width: 21,
                    ),
                    Expanded(
                        child: AutoSizeText(
                      "Your request is being processed...",
                      maxLines: 2,
                      style: TextStyle(
                          decoration: TextDecoration.none, // this removes any underline
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        fontFamily: "Tajawal"
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Widget _buildInputContainer(IconData icon, String placeholder,
    {VoidCallback? onTap}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40.0),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          border: Border.all(color: Colors.black87),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 15),
            Icon(icon),
            const SizedBox(width: 10),
            Text(
              placeholder,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.black87,
                fontSize: 12,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
