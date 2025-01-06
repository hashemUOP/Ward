import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ward/global_widgets/cat_data.dart';
import 'package:ward/global_widgets/customized_appbar.dart';
import 'package:ward/global_widgets/globals.dart';
import 'package:ward/global_widgets/home_cat_list.dart';
import 'package:ward/home/get_started.dart';
import 'package:ward/home/get_started_data.dart';
import 'package:ward/home/search_plant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _timeOfDay = "";

  void _checkTimeOfDay() {
    int hour = DateTime.now().hour;

    if (hour >= 6 && hour < 12) {
      _timeOfDay = "Good Morning!";
    } else if (hour >= 12 && hour < 18) {
      _timeOfDay = "Good Afternoon!";
    } else if (hour >= 18 && hour < 22) {
      _timeOfDay = "Good Evening!";
    } else {
      _timeOfDay = "Good Night!";
    }
  }
  User? user = FirebaseAuth.instance.currentUser;  // Get the current user
  String _userName = "";  // To store the user's name

  @override
  void initState() {
    super.initState();
    _loadUserName();  // Fetch user's name when widget is initialized
    _checkTimeOfDay();
  }//important note the compiler of flutter runs the initstate method before any other method , even build(the function that shows the ui code)
  //check top priority functions in flutter

  void _loadUserName() {
    User? user = FirebaseAuth.instance.currentUser;  // Get the current user

    if (user != null) {
      bool isPhoneSignIn = user.providerData.any((userInfo) => userInfo.providerId == 'phone');

      if (isPhoneSignIn) {
        setState(() {
          _userName = "Plant Lover";  // Set "Plant Lover" if signed in with phone
        });
      } else if (user.displayName != null && user.displayName!.isNotEmpty) {
        setState(() {
          _userName = user.displayName!;  // Set the user's display name if available
        });
      } else {
        setState(() {
          _userName = "Plant Lover";  // Default to "Plant Lover" if no display name
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    GetStartedData dataMap =
        GetStartedData(); // instance of class GetStartedData

    void handleTap(Widget className) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => className),
      );
    }

    // List of items with image and text
    List<Map<String, String>> items = [
      {
        "image":
            "assets/images/GettingStarted/homeListView/1703696590658c58ce7d5c95.webp",
        "text": "How to identify and diagnose plants\n easily with Ward"
      },
      {
        "image":
            "assets/images/GettingStarted/homeListView/hands-agronomistresearcher-closeup-he-examines-260nw-2236643375.png",
        "text": "Species and varieties, what are the\n differences"
      },
      {
        "image":
            "assets/images/GettingStarted/homeListView/9d2ae850bc902da36a51d2cbf3.jpg",
        "text": "The reasons why the same plant\n can look different"
      },
    ];
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0), // set the height to 0
          child: AppBar(
            backgroundColor: Colors.grey[200],
            automaticallyImplyLeading: false,
          )),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(
                  searchBarReferal:  const SearchPlant(),
                  upperText: _timeOfDay,
                  searchBarText: "Search for plants",
                  lowerText: _userName
              ),
              const Padding(
                padding: EdgeInsets.only(left: 17.0, top: 50, bottom: 7),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: SizedBox(
                  height: screenHeight * 0.23,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 10, right: 12, left: 12),
                        child: GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              handleTap(GetStarted(data: dataMap.getStarted1));
                            } else if (index == 1) {
                              handleTap(GetStarted(data: dataMap.getStarted2));
                            } else if (index == 2) {
                              handleTap(GetStarted(data: dataMap.getStarted3));
                            }
                          },
                          child: Container(
                            width: screenWidth * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  offset: const Offset(0, 1),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                ),
                              ],
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                fit: StackFit.expand, // ensures the children in stack space range fills the container check flutter inspector
                                children: [
                                  Image.asset(
                                    item['image']!,
                                    fit: BoxFit.cover, // image cover its all available space(container)
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Text(
                                      item['text']!,
                                      style:  const TextStyle(
                                        color: Colors.white,
                                        shadows: [
                                          BoxShadow(
                                            color: Colors.black,
                                            offset: Offset(0, 1),
                                            blurRadius: 0.9,
                                            spreadRadius: 0.9,
                                          ),
                                        ],
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, top: 50),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Categories",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              CatList(
                imageURL: images, // list of the cat images
                catName: names, // list of the cat names
              ),
            ],
          ),
        ),
      ),
    );
  }
}
