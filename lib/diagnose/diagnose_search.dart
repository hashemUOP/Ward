import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'disease_details.dart'; //use this package for faster rendering of url images from db than Image.Network()

class DiagnoseSearch extends StatefulWidget {
  const DiagnoseSearch({super.key});

  @override
  _DiagnoseSearchState createState() => _DiagnoseSearchState();
}

class _DiagnoseSearchState extends State<DiagnoseSearch> {
  bool? hasConnection;
  TextEditingController searchController = TextEditingController();
  String userInput = "";

  @override
  void initState() {
    super.initState();
    _listenToConnectionChanges();

    //on initial start a listener to search controller
    searchController.addListener(() {
      setState(() {
        userInput = capitalizeFirstWord(searchController.text);//take each word that user enters in textfield capitalize it then store it in var userInput
      });
    });
  } //this code checks internet connection on initial

  // function to capitalize the first letter of  word , since every common name starts with capital word
  String capitalizeFirstWord(String sentence) {
    if (sentence.isEmpty) {
      return sentence;
    }
    return sentence[0].toUpperCase() + sentence.substring(1);
  }

  void _listenToConnectionChanges() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      final hasConnection = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasConnection = hasConnection;
      }); //set hasConnection value based on internet connection state
    }); //this code listen to the status of the internet connection continuously
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: screenHeight * 0.15,
        bottom: PreferredSize(
          //bottom border of appbar customization
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.grey.shade300, // bottom border of app bar color
            height: 1.0, //bottom of appbar thickness
          ),
        ),
        title: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    child: const Icon(Iconsax.arrow_circle_left,
                        color: Colors.black87),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text("Problem Search",style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              SizedBox(height: screenHeight * 0.017),
              TextFormField(
                cursorColor: Colors.grey,
                style: const TextStyle(color: Colors.black),
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: "Search for problems",
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontSize: 14),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        color: Colors.black54, width: 1.0), // Active border color and width
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade100,
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
          :StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('common_diseases')
            .where('common_name', isGreaterThanOrEqualTo: userInput)//very important you can use more than one where function to put more than 1 condition to query
            .where('common_name', isLessThanOrEqualTo: userInput + '\uf8ff') //\uf8ff in firestore queries serves a similar purpose to SQL's % in LIKE queries, specifically for prefix searches.
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

          var diseases = snapshot.data!.docs;

          return ListView.builder( //create a ui for the data from firestore
            itemCount: diseases.length,
            itemBuilder: (context, index) {
              var disease = diseases[index];

              // Accessing the array field and getting the first image
              List<dynamic> images = disease['images'] ?? [];
              String? firstImageUrl =
              images.isNotEmpty ? images[0] : null;

              return GestureDetector(
                onTap: () {
                  // Navigate to PlantDetails page when container is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DiseaseDetails(
                              disease_id: disease["disease_id"],
                    ),
                  ));
                },
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.013,
                      horizontal: screenWidth * 0.04),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.shade500
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      firstImageUrl != null
                          ? CachedNetworkImage( //use this package instead of Image.Network for faster rendering and saving the image from url as cache for not rendering it every time you scroll by it
                        imageUrl: firstImageUrl,
                        height: screenHeight * 0.1,
                        width: screenHeight * 0.1,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Transform.scale(
                              scale: 0.5, // scale down to  circle size to 50%
                              child: const CircularProgressIndicator(),
                            ),
                        //if image still not rendered
                        errorWidget: (context, url, error) =>
                            Image.asset( //if error happened rendering the image
                              "assets/images/no image found.png",
                              height: screenHeight * 0.1,
                              width: screenHeight * 0.1,
                              fit: BoxFit.cover,
                            ),
                      )
                          : Image.asset( //if image is null
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
                            Text(
                              disease['common_name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(disease['type']),
                          ],
                        ),
                      ),
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
