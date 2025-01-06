import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:ward/home/nav_bar.dart';
import 'package:ward/login/phone_auth_page.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({super.key});

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false; // Moved this variable inside the state class
  String code = ""; // Moved this variable inside the state class

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/img1.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value) {
                  code = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      setState(() {
                        isLoading = true; // Show loading indicator
                      });
                      // Create a PhoneAuthCredential with the code
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                        verificationId: MyPhone.verify, // Ensure this is set correctly
                        smsCode: code,
                      );

                      // Sign the user in (or link) with the credential
                      await auth.signInWithCredential(credential);
                      //print("User signed in"); // Debug print

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MyNavBar(),
                        ),
                      );
                    } catch (error) {
                      setState(() {
                        isLoading = false; // Stop loading when an error occurs
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("An error occurred: $error")),
                      );
                      //print("Error: $error"); // Debug print
                    }
                  },
                  child: const Text("Verify Phone Number", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Edit Phone Number?",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              if (isLoading)
                const ModalBarrier(
                  dismissible: false,
                  color: Colors.black38,
                ), // if user press
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
                          SizedBox(width: 20),
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          ),
                          SizedBox(width: 21),
                          Expanded(
                            child: AutoSizeText(
                              "Your request is being processed...",
                              maxLines: 2,
                              style: TextStyle(
                                decoration: TextDecoration.none, // this removes any underline
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Tajawal",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
