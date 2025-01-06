import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ward/diagnose/disease_details.dart';


class AllDiseases extends StatefulWidget {
  const AllDiseases({super.key});

  @override
  State<AllDiseases> createState() => _AllDiseasesState();
}

class _AllDiseasesState extends State<AllDiseases> {
  bool? hasConnection;

  @override
  void initState() {
    super.initState();
    _listenToConnectionChanges();
  } //this code checks internet connection on initial

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
        title: const Text(
            "Common Pests & Diseases"
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
            .collection('common_diseases')//show all documents in collection
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
                  // Navigate to DiseaseDetails page when container is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DiseaseDetails(
                              disease_id: disease["disease_id"],
                            ) //DiseaseDetails
                    ),
                  );
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
                        fit: BoxFit. cover,
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
