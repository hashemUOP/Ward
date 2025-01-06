import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ward/global_widgets/globals.dart';
import 'package:ward/home/nav_bar.dart';
import 'package:ward/plants_listing_and_details/plant_details.dart';
import 'package:cached_network_image/cached_network_image.dart'; //use this package for faster rendering of url images from db than Image.Network()


class PlantsListing extends StatefulWidget {
  final String catName;
  final bool? isForAddPlant;


  const PlantsListing({super.key, required this.catName, this.isForAddPlant});

  @override
  PlantsListingState createState() => PlantsListingState();
}

class PlantsListingState extends State<PlantsListing> {
  bool? hasConnection;
  TextEditingController searchController = TextEditingController();
  bool? isPlantIdInDB;

  @override
  void initState() {
    super.initState();
    _listenToConnectionChanges();
    getPlantIds();
  }//this code checks internet connection on initial

  bool checkPlantIdInDB(String plantId){
    for(int i = 0; i<userPlantsIDsList!.length;i++){
      if(plantId == userPlantsIDsList![i]){
        return true;
      }
    }
    return false;
  }
  Future<void> getPlantIds() async {
    List<String> plantIds = [];
    User? user = FirebaseAuth.instance.currentUser;
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


  void _listenToConnectionChanges() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasConnection = hasConnection;
      });//set hasConnection value based on internet connection state
    });//this code listen to the status of the internet connection continuously
  }




  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,  // this removes the back arrow
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Iconsax.arrow_circle_left,
              color: Colors.black54),
        ),
        title: Text(
          widget.catName == "Succulents\n& Cacti"
              ? "Succulents and Cacti"
              : widget.catName == "Herbs\n& Weeds"
              ? "Herbs and Weeds"
              : widget.catName
        ),
        backgroundColor: Colors.white,
      ),
      body: hasConnection == false
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/5865576.jpg')),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.1),
              child: const Text(
                'No internet connection.\nPlease check your connection.',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      )
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('plants')
            .where(
            'category', isEqualTo: widget.catName == "Succulents\n& Cacti"
            ? "Succulents and Cacti"
            : widget.catName == "Herbs\n& Weeds"
            ? "Herbs and Weeds"
            : widget.catName)
            .snapshots(),
        builder: (context, snapshot) {
          //show when error fetching data occur
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                      image: AssetImage('assets/images/no image found.png')),
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

          return ListView.builder(//create a ui for the data from firestore
            itemCount: plants.length,
            itemBuilder: (context, index) {
              var plant = plants[index];

              // Accessing the array field and getting the first image
              List<dynamic> images = plant['images'] ?? [];
              String? firstImageUrl =
              images.isNotEmpty ? images[0] : null;

              return GestureDetector(
                onTap: () {
                  // Navigate to PlantDetails page when container is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlantDetails(
                        plantID: plant['plant_id'],//show plant details based on plant_id
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.013,
                      horizontal: screenWidth * 0.04),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade500
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:  Row(
                    children: [
                      firstImageUrl != null
                          ? CachedNetworkImage(//use this package instead of Image.Network for faster rendering and saving the image from url as cache for not rendering it every time you scroll by it
                        imageUrl: firstImageUrl,
                        height: screenHeight * 0.1,
                        width: screenHeight * 0.1,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Transform.scale(
                             scale: 0.5, // scale down to  circle size to 50%
                             child: const CircularProgressIndicator(),
                           ),//if image still not rendered
                        errorWidget: (context, url, error) =>
                            Image.asset(//if error happened rendering the image
                              "assets/images/no image found.png",
                              height: screenHeight * 0.1,
                              width: screenHeight * 0.1,
                              fit: BoxFit.cover,
                            ),
                      )
                          : Image.asset(//if image is null
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
                widget.isForAddPlant == true ?//show button or text if user is in add plant page else show nothing(empty sized box)
                (checkPlantIdInDB(plant["plant_id"]) == false?//if plants already in garden don't show button and user is in the add plant page
                      IconButton(
                        onPressed: () async {
                          // Get the current authenticated user
                          User? user = FirebaseAuth.instance.currentUser;
                          if(user!= null ){
                            try {
                              // Add the plant details to the "users_plants" collection
                              await FirebaseFirestore.instance.collection('users_plants').add({
                                'plant_id': plant['plant_id'],
                                'common_name': plant['common_name'],
                                'scientific_name': plant['scientific_name'],
                                'images': plant['images'] ?? [],
                                'timestamp': FieldValue.serverTimestamp(), // time of adding
                                'user_id': user.uid,
                                'user_email': user.email ?? "",
                                'user_phone' : user.phoneNumber ?? ""

                              });
                              //after showing a confirmation message (Snackbar) send user back to MyGarden
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => const MyNavBar(globalSelectedIndex: 1),
                                ),
                              );
                              // Show a confirmation message (Snackbar) after adding the plant
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${plant['common_name']} has been added to your plants'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              // Handle any errors that might occur during the addition process
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to add plant: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }else {
                            // Debugging: User is not authenticated
                            print('No user is logged in');

                            // If no user is logged in, show an error
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('No user is logged in'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                        },
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.green,
                          size: 30,
                        ),
                      )
                      :
                     Text("Plant already\n  in garden.",style: TextStyle(color: Colors.grey.shade700,fontSize: 10),))
                    :
                      const SizedBox(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}