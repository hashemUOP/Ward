import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'phone_otp.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({super.key});

  static String verify = "";
  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  bool isPhoneNumberValid = false; // Track whether the phone number is valid
  /*
   tracks loading state that activates once the user taps "Send the code" the state isLoading becomes true
   which make the screen grey and untouchable and a loading circle appear which helps to make sure that the user only tap
   "Send the code" one time , in other words only one api call is sent for firebase auth to send otp to phone number once.\
   when api is successfully sent show loading
   */
  bool isLoading = false;
  String phoneNum = "";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: isLoading ? Colors.black38 : Colors.white,//if user tap "Send the code" make appbar color grey else white
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Main content
          Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset('assets/images/img1.png', width: 150, height: 150),
                  const SizedBox(height: 25),
                  const Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "We need to register your phone to get started!",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.green),
                    ),
                    child: IntlPhoneField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                      ),
                      initialCountryCode: 'JO', // Set default country code
                      onChanged: (phone) {
                        // Access the full phone number with the country code
                        phoneNum = phone.completeNumber;

                        // Enable button only if the entered phone number is valid
                        setState(() {
                          isPhoneNumberValid = phone.isValidNumber();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

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
                      onPressed: isPhoneNumberValid
                          ? () async {
                        setState(() {
                          isLoading = true; // Start loading
                        });

                        try {
                          // Set FirebaseAuth settings to ensure app verification (reCAPTCHA) is enabled
                          FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: false);

                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: phoneNum,
                            timeout: const Duration(seconds: 120),
                            verificationCompleted: (PhoneAuthCredential credential) {
                              print("Auto verification completed: ${credential.smsCode}");
                            },
                            verificationFailed: (FirebaseAuthException e) {
                             print(e);
                             // Display a detailed error message in the SnackBar
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: Text('Verification failed: ${e.message}'),
                               ),
                             );
                             setState(() {
                               isLoading = false;
                             });//close loading screen after error occurs
                            },
                            codeSent: (String verificationId, int? resendToken) {
                              MyPhone.verify = verificationId;
                              setState(() {
                                isLoading = false; // Stop loading once code is sent
                              });
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const MyVerify(),
                                ),
                              );
                            },
                            codeAutoRetrievalTimeout: (String verificationId) {
                              setState(() {
                                isLoading = false; // Stop loading on timeout
                              });
                              print('Auto-retrieval timed out');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Auto-retrieval timed out'),
                                ),
                              );
                            },
                          );
                        } catch (e) {
                          setState(() {
                            isLoading = false; // Stop loading on error
                          });
                          print('Error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred: $e')),
                          );
                        }
                      }
                          : null,
                      child: const Text(
                        "Send the code",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Loading overlay
          if (isLoading)
            const ModalBarrier(
              dismissible: false,
              color: Colors.black38,
            ),//if user press
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
                      SizedBox(width: 20,),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      SizedBox(width: 21,),
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
      ),
    );
  }
}
