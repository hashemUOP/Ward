import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:ward/chatbot/consts.dart';
import 'package:ward/firebase_options.dart';
import 'package:ward/global_widgets/globals.dart';
import 'package:ward/home/nav_bar.dart';
import 'package:ward/login/auth_service_google.dart';
import 'package:ward/login/login.dart';

//things to do:

//// to save time from loading images save first images url in a list with their plant id then call it in the listing plant.dart
////notify user when time & date occur then notify user then create a new document with the same time but old date + repeat date

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      Brightness.dark)); //change the status bar color for all pages

  Gemini.init(apiKey: GEMINI_API_KEY);//create api(connection) between gemini server and project

  //initialize connection between project and firebase includes all services such as firestore,auth
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //this code to stop landscape mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    setupRealTimeListeners();
    numOfPlantsListener();
    getPlantIds();
  }

/*
To improve the performance of the MyGarden page and reduce the appearance of loading screens,
 i used the MyGarden Async functions here and in the  to store the results in global variables
  from globals.dart. This way, the data is pre-fetched when the app initializes,
   allowing the MyGarden page to access the stored values directly,
 eliminating the need for async operations during the load of MyGarden
 and removes the loading circle that appear on each time you tap AllPlants or Reminders in
 MyGarden , or when MyGarden is initialized.
 */
/////////////////////////////////////////  MyGarden Async functions   ////////////////////////////////////////////////////////////////////////////////////////
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> numOfPlantsListener() async {
    if (user != null) {
      // Set up real-time listener for 'users_plants' collection based on user_id
      FirebaseFirestore.instance
          .collection('users_plants')
          .where('user_id', isEqualTo: user!.uid) // Use the global userIdentity
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        // Create a set to store unique plant_ids
        Set<String> uniquePlantIds = {};

        // Loop through the documents and add the plant_id to the set
        for (var doc in snapshot.docs) {
          String plantId = doc.get('plant_id');
          uniquePlantIds.add(plantId); // Set will automatically filter out duplicates
        }

        // Update numOfUsersPGlobal with the count of unique plant_ids in real-time
        setState(() {
          numOfUsersPGlobal = uniquePlantIds.length;
        });
      });
    }else{
      print("user not signed");
    }
  }


  // Method to set up real-time listeners for plants and reminders
  void setupRealTimeListeners() {
    // Ensure user is not null
    if (user != null) {
      // Listen for real-time changes in the 'users_plants' collection
      FirebaseFirestore.instance
          .collection('users_plants')
          .where('user_id', isEqualTo: user!.uid)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        setState(() {
          doesUserHavePGlobal = snapshot.docs.isNotEmpty; // Update global variable
        });
      });

      // Listen for real-time changes in the 'users_reminders' collection
      FirebaseFirestore.instance
          .collection('users_reminders')
          .where('user_id', isEqualTo: user!.uid)
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        setState(() {
          doesUserHaveRGlobal = snapshot.docs.isNotEmpty; // Update global variable
        });
      });
    } else {
      print('User is null, cannot set up real-time listeners.');
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////// plants_listing Async functions /////////////////////////////////////////////

  Future<void> getPlantIds() async {
    List<String> plantIds = [];
    if (user != null) {
      try {
        // Access the 'users_plants' collection
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users_plants')
            .where("user_id", isEqualTo: user!.uid)
            .get();

        // Loop through each document in the collection
        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String,
              dynamic>?; // Safely cast to Map<String, dynamic>

          // Check if the data is not null and contains the 'plant_id' field
          if (data != null && data.containsKey('plant_id')) {
            plantIds.add(data['plant_id']);
          }
        }
      } catch (e) {
        print('Error fetching plant IDs: $e');
      }
    }else{
      print("user not signed");
    }
    userPlantsIDsList = plantIds;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.green.shade500, // default color for the circular loading circle
        ),
        // Apply the OpenSans font family to any Text widget in app.
        fontFamily: 'OpenSans',
        //default font family for all TextStyle widget in project Small , Medium , Large picks a default for each font size.
        textTheme: const TextTheme(
          bodySmall: TextStyle(fontFamily: 'OpenSans'),
          bodyMedium: TextStyle(fontFamily: 'OpenSans'),
          bodyLarge: TextStyle(fontFamily: 'OpenSans'),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();

    // Listen to auth state changes
    _authService.userChanges.listen((User? user) { //check settings.dart line 76, when user is signed out user variable User? user becomes null
      if (user != null) {
        // if user has an account in firebase auth whether he is signed by phone , google , or any other way is signed in, navigate to MyNavBar
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MyNavBar()),
        );
      } else {
        // User is signed out, navigate to Login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    });
  }//this is make sure if user is signed in with google account to be transferred to Home everytime he opens app , and if not he will be transferred to Login page

  @override
  Widget build(BuildContext context) {
    // Show a loading indicator while checking auth state
    return  Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.green.shade500,)),
    );
  }
}


