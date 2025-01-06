import 'package:flutter/material.dart';
import 'package:ward/diagnose/diagnose_search.dart';
import 'package:ward/diagnose/disease_details.dart';
import 'package:ward/diagnose/diseases_list.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ward/global_widgets/customized_appbar.dart';
import 'package:ward/try/icons_entery.dart';

class Diagnose extends StatefulWidget {
  const Diagnose({super.key});

  @override
  State<Diagnose> createState() => _DiagnoseState();
}

class _DiagnoseState extends State<Diagnose> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    /*
    important note common name isn't unique might be repeated in db but scientific is unique
     */
    List<Map<String, String>> commonDiseasesData = [
      {
        "name": "Leaf Spot",
        "image": "assets/images/CommonDiseases/cercospora_hydrangea-1024x766_1200x600_crop_center.webp",
        "disease_id" : "00062"
      },
      {
        "name": "Blight",
        "image": "assets/images/CommonDiseases/potato-blight.jpg",
        "disease_id" : "00023"
      },
      {
        "name": "Anthracnose",
        "image": "assets/images/CommonDiseases/Anthracnose46.jpg",
        "disease_id" : "00019"
      },
      {
        "name": "Rust",
        "image": "assets/images/CommonDiseases/orange-rust-berry.jpg",
        "disease_id" : "00027"
      },
      {
        "name": "Root Rot",
        "image": "assets/images/CommonDiseases/hot-to-prevent-root-rot.jpg",
        "disease_id" : "00015"
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // set the height to 0
        child: AppBar(
          backgroundColor: Colors.grey[200],
          automaticallyImplyLeading: false,
        ),
      ),
      backgroundColor: const Color(0xFFF4F5F5),
      body: SafeArea(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Header(
                  searchBarReferal: DiagnoseSearch(),
                  upperText: "Pests and diseases",
                  lowerText: "Diagnose",
                  searchBarText: "Search for diseases",
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: screenHeight * 0.05,
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                  ),
                  child: DottedBorder(
                    color: Colors.grey.shade400,
                    borderType: BorderType.RRect,
                    strokeWidth: 2,
                    dashPattern: const [8],
                    radius: const Radius.circular(15),
                    child: Container(
                      height: screenHeight * 0.35,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: screenHeight *
                                0.03, // Position the image relative to the top
                            left: screenWidth * 0.15, // Center horizontally
                            right: screenWidth * 0.15,
                            child: Image.asset(
                              "assets/images/9038218.png",
                              width: screenWidth * 0.7,
                              height: screenHeight * 0.09,
                            ),
                          ),
                          Positioned(
                            top: screenHeight *
                                0.16, // Adjust the position for the text
                            left: screenWidth * 0.2, // Set horizontal padding
                            right: screenWidth * 0.2,
                            child: const Text(
                              "Take photos of the plant's sick parts from different angles",
                              style: TextStyle(color: Colors.black54),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            top: screenHeight *
                                0.28, // Space out the button vertically
                            left: screenWidth * 0.24,
                            right: screenWidth * 0.24,
                            bottom: screenHeight * 0.028,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CreateShortRequirementForm()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.green[
                                      100], // Background color for the button
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "Add Plant",
                                  style: TextStyle(
                                    color: Colors.green[600],
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Common diseases",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AllDiseases()),
                              );
                            },
                            child: Text(
                              "See more",
                              style: TextStyle(color: Colors.green[600]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.2,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: commonDiseasesData.length,
                          itemBuilder: (context, index) {
                            final item = commonDiseasesData[index];
                            return GestureDetector(
                              onTap: (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DiseaseDetails(disease_id: item["disease_id"]!),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.01,
                                  right: screenWidth * 0.04,
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(23)),
                                  ),
                                  width: screenWidth * 0.7,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          item["image"]!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          item["name"]!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 20.0,
                                                color: Colors.black,
                                                offset: Offset(2.0, 2.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
