import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ward/global_widgets/animated_button.dart';
import 'package:ward/global_widgets/customized_text.dart';
import 'package:ward/login/auth_service_google.dart';
import 'package:ward/login/login.dart';
import 'package:ward/try/diseases_entry.dart';
import '../global_widgets/color_changing_container.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //all google account actions are located in the AuthService
  final AuthService _authService = AuthService(); // Create an instance of AuthService
  User? user =  FirebaseAuth.instance.currentUser;



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Set the height to 0
        child: AppBar(backgroundColor: Colors.white, automaticallyImplyLeading: false),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Settings", style: TextStyle(color: Colors.black54)),
              ),
              const SizedBox(height: 30),
              ColorChangingContainer(
                icon: const Icon(Icons.bug_report_outlined, color: Colors.black54),
                iconPost: const Icon(Iconsax.arrow_right_3, color: Colors.black54),
                iconPostPadding: screenWidth * 0.423,
                inWidget: const MyText(
                  fromLeft: 10,
                  text: 'Report a bug',
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                onTap:() {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DiseasesEntry(),
                    ),
                  );
                }
              ),
              ColorChangingContainer(
                icon: const Icon(Iconsax.star, color: Colors.black54),
                iconPost: const Icon(Iconsax.arrow_right_3, color: Colors.black54),
                iconPostPadding: screenWidth * 0.423,
                inWidget: const MyText(
                  fromLeft: 10,
                  text: 'Rate app',
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              ColorChangingContainer(
                icon: const Icon(FontAwesomeIcons.solidCircleUser, color: Colors.black54),
                iconPost: const Icon(Iconsax.arrow_right_3, color: Colors.black54),
                iconPostPadding: screenWidth * 0.423,
                inWidget: const MyText(
                  fromLeft: 10,
                  text: 'User\'s Info',
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                onTap: (){
                    showModalBottomSheet(context: context, builder:
                        (context) {
                          return SizedBox(
                            height: screenHeight * 0.4,
                            width: double.infinity,
                            child:  SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image(image: NetworkImage("${user!.photoURL}")),
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text(
                                          "Username : ",
                                          style: TextStyle(
                                          fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45
                                        ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          user!.displayName.toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  user!.phoneNumber != null?
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text(
                                          "Phone Number: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black45
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          user!.phoneNumber.toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                      :
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text(
                                          "Email : ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black45
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          user!.email.toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(15.0),
                                        child: Text(
                                          "Uid : ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black45
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          user!.uid,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                              overflow: TextOverflow.ellipsis
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                    );
                },
              ),
              ColorChangingContainer(
                icon: const Icon(Iconsax.global, color: Colors.black54),
                iconPost: const Icon(Iconsax.arrow_right_3, color: Colors.black54),
                iconPostPadding: screenWidth * 0.423,
                inWidget: const MyText(
                  fromLeft: 10,
                  text: 'Change language',
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                onTap: (){
                },
              ),
              ColorChangingContainer(
                onTap: () async {
                  try {
                    await _authService.signOut(); // Attempt to sign out the user
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const Login()), // Navigate to Login page
                    );
                  } catch (e) {
                    // Handle any sign-out errors here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                },
                icon: const Icon(Iconsax.logout, color: Colors.black54),
                inWidget: const MyText(
                  fromLeft: 10,
                  text: 'Log out',
                  color: Colors.black54,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 40),
              AnimatedButton(
                onTap: () async {
                  await _authService.deleteUser(context); // Delete the user's account
                },
                buttonColor: Colors.white,
                text: 'Delete my account',
                textColor: Colors.green,
                textSize: 15,
                containerBorderColor: Colors.green,
                containerRadius: 10,
                containerHeight: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
