/*
very very important:
WillPopScope this widget is deprecated try using if playstore doesn't accept app ,
use Navigator.pushReplacement in main.dart which prevents user from pop after
sending user to a new route(page),in other words doesn't keep old route in stack
as if the new route is the top of stack and only element in it

 */
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ward/chatbot/main_screen.dart';
import 'package:ward/diagnose/diagnose.dart';
import 'package:ward/my_garden/my_garden.dart';
import 'package:ward/settings/settings.dart';
import 'home.dart';
import 'package:flutter/services.dart';

class MyNavBar extends StatefulWidget {

  final int? globalSelectedIndex;
  const MyNavBar({super.key, this.globalSelectedIndex});

  @override
  State<MyNavBar> createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  int _selectedIndex = 0;
  bool hasUsedGlobalIndex = false; // Flag to track if globalSelectedIndex has been used
  bool? hasConnection;


  @override
  void initState() {
    super.initState();
    // _listenToConnectionChanges();
    // Check if globalSelectedIndex is provided and has not been used yet
    if (widget.globalSelectedIndex != null && !hasUsedGlobalIndex) {
      _selectedIndex = widget.globalSelectedIndex!;
      hasUsedGlobalIndex = true; // Mark as used
    }
  }

  void _listenToConnectionChanges() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasConnection = hasConnection;
      });//set hasConnection value based on internet connection state
    });//this code listen to the status of the internet connection continuously
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> pages = [
    const Home(),
    const MyGarden(),
    const MainScreen(),
    const Diagnose(),
    const Settings(),
  ];

  /*
  // this code do the following when the user is in the MyNavBar page and pops(try's to go the previous page(Login)
  he gets an alert dialog
  which prevents poping back to the login page unless  he go to settings and log out or delete account
   */
  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Exit App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Do you really want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // User stays
            child: const Text(
              'No',
              style: TextStyle(color: Colors.green),
            ),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop(); // Exit the app
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //this widget is deprecated try using if playstore doesn't accept app ,use Navigator.pushReplacement in main.dart which prevents user from pop after sending user to a new route(page),in other words doesn't keep old route in stack as if the new route is the top of stack and only element in it
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: hasConnection == false // When there's no internet connection, show this UI
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/images/5865576.jpg')),
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                child: const Text(
                  'No internet connection.\nPlease check your connection.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
            : pages[_selectedIndex], // If connected, show the respective page,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey.shade300, // Upper border color
                width: 1.0,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.grey,
              activeColor: Colors.green[500],
              tabBackgroundColor: Colors.green.shade50,
              gap: 8,
              padding: const EdgeInsets.all(12),
              selectedIndex: _selectedIndex,
              onTabChange: _navigateBottomBar,
              tabs: const [
                GButton(
                  icon: Iconsax.house_24,
                  text: 'Home',
                ),
                GButton(
                  icon: FontAwesomeIcons.leaf,
                  text: 'My Garden',
                ),
                GButton(
                  icon: Iconsax.messages,
                  text: 'ChatBot',
                ),
                GButton(
                  icon: FontAwesomeIcons.stethoscope,
                  text: 'Diagnose',
                ),
                GButton(
                  icon: Iconsax.user_tag4,
                  text: 'Account',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
