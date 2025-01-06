/*
To improve the performance of the MyGarden page and reduce the appearance of loading screens,
 you can move the async functions to main.dart and store the results in global variables
  from globals.dart. This way, the data is pre-fetched when the app initializes,
   allowing the MyGarden page to access the stored values directly,
 eliminating the need for async operations during the load of MyGarden
 and removes the loading circle that appear on each time you tap AllPlants or Reminders in
 MyGarden , or when MyGarden is initialized.
 */

/*
the button + that adds plants to collection users_plants is in plants_listing.dart
 */
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ward/my_garden/add_plant.dart';
import 'package:ward/my_garden/create_reminder.dart';
import 'package:ward/my_garden/no_plants_screen.dart';
import 'package:ward/my_garden/no_reminders_screen.dart';
import 'package:ward/plants_listing_and_details/plant_details.dart';
import 'package:intl/intl.dart';
import 'package:ward/global_widgets/globals.dart';




class MyGarden extends StatefulWidget {
  const MyGarden({super.key});

  @override
  State<MyGarden> createState() => _MyPlantsState();
}


class _MyPlantsState extends State<MyGarden> {
  User? user = FirebaseAuth.instance.currentUser;

  late Color containerColor1;
  late Color containerColor2;
  late bool isPlantTapped; // this var saves if button in app bar plant is tapped or not


  @override
  void initState() {
    super.initState();
    containerColor1 = Colors.green.withOpacity(0.1);
    containerColor2 = Colors.transparent;
    isPlantTapped = true;
    setupRealTimeListeners();
    getPlantIds();
    numOfPlantsListener();
  }

  Future<void> getPlantIds() async {
    List<String> plantIds = [];

    try {
      // Access the 'users_plants' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users_plants')
          .where("user_id",isEqualTo: user!.uid)
          .get();

      // Loop through each document in the collection
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>?; // Safely cast to Map<String, dynamic>

        // Check if the data is not null and contains the 'plant_id' field
        if (data != null && data.containsKey('plant_id')) {
          plantIds.add(data['plant_id']);
        }
      }
    } catch (e) {
      print('Error fetching plant IDs: $e');
    }
    userPlantsIDsList = plantIds;
  }


  Future<void> numOfPlantsListener() async {

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
  }


  // Method to set up real-time listeners for plants and reminders
  void setupRealTimeListeners() {
    // Listen for real-time changes in the 'users_plants' collection so that when user deletes all plants the screen NoPlantsScreen() appear
    FirebaseFirestore.instance
        .collection('users_plants')
        .where('user_id', isEqualTo: user!.uid) // Use the global userIdentity
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        doesUserHavePGlobal = snapshot.docs.isNotEmpty; // Update global variable
      });
    });

    // Listen for real-time changes in the 'users_reminders' collection so that when user deletes all reminders the screen NoRemindersScreen() appear
    FirebaseFirestore.instance
        .collection('users_reminders')
        .where('user_id', isEqualTo: user!.uid) // Use the global userIdentity
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      setState(() {
        doesUserHaveRGlobal = snapshot.docs.isNotEmpty; // Update global variable
      });
    });
  }

  //method to remove plant from users_plants collection
  Future<void> onRemove(String plantId) async {
    try {
      // First, find the document by querying the 'plant_id' field
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users_plants')
          .where('user_id',
          isEqualTo: user!.uid) // Find documents belonging to this user
          .where('plant_id',
          isEqualTo: plantId) // Find the specific plant based on 'plant_id'
          .get();

      // Check if there is a document matching this query
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the first document found (there should only be one)
        await querySnapshot.docs.first.reference.delete();
        setState(() {
          // don't delete this , it rebuilds page , which triggers initState again.
        });
        // Show success message
        if (mounted) { // this condition removes this problem Don't use 'BuildContext's across async gaps.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Plant removed from your garden.'),
            ),
          );
        }
      } else {
        if (mounted) {
          // If no document is found, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Plant not found.'),
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors here
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error removing plant: $e'),
          ),
        );
      }
    }
  }

  //method to remove reminder from users_reminders collection
  Future<void> onRemoveReminder(String reminderId) async {
    try {
      // First, find the document by querying the 'plant_id' field
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users_reminders')
          .where('user_id',
          isEqualTo: user!.uid) // Find documents belonging to this user
          .where('reminder_id',
          isEqualTo:
          reminderId) // Find the specific reminder based on 'reminder_id'
          .get();

      // Check if there is a document matching this query
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the first document found (there should only be one)
        await querySnapshot.docs.first.reference.delete();

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Reminder has been removed.'
                  '0'),
            ),
          );
        }
      } else {
        if (mounted) {
          // If no document is found, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Reminder not found.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        // Handle any errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Error removing plant: $e'),
          ),
        );
      }
    }
  }

  void handleTap(Widget className) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => className),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 125,
        backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          //bottom border of appbar customization
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.grey.shade400, // bottom border of app bar color
            height: 1.0, //bottom of appbar thickness
          ),
        ),
        flexibleSpace: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // Align text to the left
          children: [
             SafeArea(
              child:  Padding(
                padding:const EdgeInsets.only(left: 20, top: 0),
                // Add padding at the top
                child:  Text(
                  numOfUsersPGlobal == 0 || numOfUsersPGlobal == null?
                  "No Plants" :
                  "$numOfUsersPGlobal Plants",
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 0),
              // Add padding at the top
              child: Text(
                "My Garden",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
            ),
            const Spacer(),
            Stack(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight * 0.1, // Height for the image section
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Image.asset(
                          "assets/images/img2-2.png",
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          "assets/images/img_2-3.png",
                          fit: BoxFit.cover,
                          height: double.infinity,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  child: Container(
                    height: screenHeight * 0.06,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPlantTapped = true;
                                containerColor1 = Colors.green.withOpacity(0.2);
                                containerColor2 = Colors.transparent;
                              });
                            },
                            child: Container(
                              width: screenWidth * 0.4,
                              decoration: BoxDecoration(
                                color: containerColor1,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "All Plants",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPlantTapped = false;
                                containerColor2 = Colors.green.withOpacity(0.2);
                                containerColor1 = Colors.transparent;
                              });
                            },
                            child: Container(
                              width: screenWidth * 0.4,
                              decoration: BoxDecoration(
                                color: containerColor2,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Reminders",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      backgroundColor: const Color(0xFFF4F5F5),
      body: SafeArea(
          child: Column(
            children: [
              Visibility(
                visible: isPlantTapped && doesUserHavePGlobal == false,
                child: const NoPlantsScreen(),
              ),
          Visibility(
            visible: isPlantTapped && doesUserHavePGlobal == true,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users_plants')
                  .where('user_id', isEqualTo: user!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: AssetImage('assets/images/no image found.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.1),
                          child: const Text(
                            'Error fetching data.\nPlease try again later.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // While waiting for data
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green.shade500,
                    ),
                  );
                }

                var plants = snapshot.data!.docs;

                // Use a set to filter out duplicate plants containers based on their plant_id
                Set<String> uniquePlantIds = {};
                List<QueryDocumentSnapshot> uniquePlants = [];

                for (var plant in plants) {
                  String plantId = plant['plant_id'];
                  if (!uniquePlantIds.contains(plantId)) {
                    uniquePlantIds.add(plantId);
                    uniquePlants.add(plant);
                  }
                }

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20.0, top: 10),
                              child: Text(
                                "Plants",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0, top: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AddPlant(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Add Plant",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        // Use the uniquePlants list
                        Column(
                          children: List.generate(uniquePlants.length, (index) {
                            var plant = uniquePlants[index];
                            List<dynamic> images = plant['images'] ?? [];
                            String? firstImageUrl =
                            images.isNotEmpty ? images[0] : null;

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PlantDetails(plantID: plant['plant_id']),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                margin: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.013,
                                  horizontal: screenWidth * 0.04,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    firstImageUrl != null
                                        ? CachedNetworkImage(
                                      imageUrl: firstImageUrl,
                                      height: screenHeight * 0.1,
                                      width: screenHeight * 0.1,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Transform.scale(
                                            scale: 0.5,
                                            child: const CircularProgressIndicator(),
                                          ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            "assets/images/no image found.png",
                                            height: screenHeight * 0.1,
                                            width: screenHeight * 0.1,
                                            fit: BoxFit.cover,
                                          ),
                                    )
                                        : Image.asset(
                                      "assets/images/no image found.png",
                                      height: screenHeight * 0.1,
                                      width: screenHeight * 0.1,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            plant['common_name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          AutoSizeText(plant['scientific_name']),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: const Icon(Icons.more_horiz),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.grey.shade200,
                                            context: context,
                                            builder: (context) {
                                              return SizedBox(
                                                height: screenHeight * 0.13,
                                                width: double.infinity,
                                                child: Column(
                                                  children: [
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        await onRemove(
                                                            plant["plant_id"]);
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 20.0),
                                                        child: Container(
                                                          width: double.infinity,
                                                          height: screenHeight * 0.08,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                12),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              const SizedBox(
                                                                  width: 10),
                                                              Container(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(7),
                                                                decoration:
                                                                BoxDecoration(
                                                                  shape:
                                                                  BoxShape.circle,
                                                                  color: Colors
                                                                      .red.shade50,
                                                                ),
                                                                child: const Icon(
                                                                  size: 20,
                                                                  FontAwesomeIcons
                                                                      .trash,
                                                                  color: Colors.red,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 10),
                                                              const Text(
                                                                "Remove from Garden",
                                                                style: TextStyle(
                                                                    color:
                                                                    Colors.red),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20)
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Visibility(
                  visible: isPlantTapped == false && doesUserHaveRGlobal == false,
                  child: const NoRemindersScreen()
              ),
              Visibility(
                  visible: isPlantTapped == false && doesUserHaveRGlobal == true,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users_reminders')
                        .where('user_id', isEqualTo: user!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (snapshot.hasError) {
                        //if error happens while fetching data return(stops build) and show code block
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage('assets/images/caution.png'),
                                height: 60,
                                width: 60,
                              ),
                              Padding(
                                padding: EdgeInsets.all(screenWidth * 0.1),
                                child: const Text(
                                  'Error fetching data.\nPlease try again later.',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // While waiting for data
                      if (!snapshot.hasData) {
                        return Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.2,
                            ),
                            Center(
                              child: CircularProgressIndicator(
                                color: Colors.green.shade500,
                              ),
                            ),
                          ],
                        );
                      }

                      var reminders = snapshot.data!.docs;

                      //////////// Use a set to filter out duplicate plants containers based on their plant_id
                      Set<String> uniqueReminderIds = {};
                      List<QueryDocumentSnapshot> uniqueReminders = [];

                      for (var reminder in reminders) {
                        String userId = reminder['reminder_id'];
                        if (!uniqueReminderIds.contains(userId)) {
                          // Only add plants with unique plant_id
                          uniqueReminderIds.add(userId);
                          uniqueReminders.add(reminder);
                        }
                      }

                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20.0, top: 10),
                                    child: Text(
                                      "Upcoming reminders",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, top: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to AddPlant screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (
                                                context) => const CreateReminder(),
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              // Use the uniquePlants list which contains no duplicates
                              ListView.builder(
                                shrinkWrap: true,
                                // Prevent ListView from taking infinite height
                                physics:
                                const NeverScrollableScrollPhysics(),
                                // Disable scrolling inside SingleChildScrollView
                                itemCount: uniqueReminders.length,
                                itemBuilder: (context, index) {
                                  var reminder = uniqueReminders[index];
                          
                                  return Container(
                                    padding: EdgeInsets.all(screenWidth * 0.02),
                                    margin: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.013,
                                      horizontal: screenWidth * 0.04,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.green.shade200
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                AutoSizeText(
                                                  '${reminder['reminder_time']} , ',
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20), ),
                                                  AutoSizeText('${reminder['reminder_date'] is Timestamp
                                                    ? DateFormat('dd/MM/yyyy')
                                                    .format(
                                                    reminder['reminder_date']
                                                        .toDate())
                                                    : reminder['reminder_date']}',
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 14), ),
                                              ],
                                            ),
                          
                                            IconButton(
                                              icon: const Icon(Icons.more_horiz,
                                                color: Colors.white,),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  backgroundColor: Colors.grey.shade200,
                                                  context: context,
                                                  builder: (context) {
                                                    return SizedBox(
                                                      height: screenHeight * 0.13,
                                                      width: double.infinity,
                                                      child: Column(
                                                        children: [
                                                          const Spacer(),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              await onRemoveReminder(reminder["reminder_id"]); // Ensure it's awaited
                                                              setState(() {
                                                                //refresh class so when user changes appear
                                                              });
                                                              Navigator.pop(context); // Close the modal after action
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                                              child: Container(
                                                                width: double.infinity,
                                                                height: screenHeight * 0.08,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    const SizedBox(width: 10),
                                                                    Container(
                                                                      padding:
                                                                      const EdgeInsets.all(7),
                                                                      decoration: BoxDecoration(
                                                                        shape: BoxShape.circle,
                                                                        // Make the container a circle around the icon
                                                                        color: Colors.red.shade50,
                                                                      ),
                                                                      child: const Icon(
                                                                        size: 20,
                                                                        FontAwesomeIcons.trash,
                                                                        color: Colors.red,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 10),
                                                                    const Text(
                                                                      "Remove Reminder",
                                                                      style: TextStyle(color: Colors.red),)
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(height: 20)
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                          
                                          ],
                                        ),
                                        Text(
                                          'reminder for ${reminder["remind_about"]}  ${reminder["common_name"]}',
                                          style: const TextStyle(color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1, // Shows ellipsis (...) when text overflows
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
              ),
            ],
          )
      ),
    );
  }


}
