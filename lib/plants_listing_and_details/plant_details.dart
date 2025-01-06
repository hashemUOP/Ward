import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ward/global_widgets/customized_expansion_tile.dart';
import 'package:ward/global_widgets/dotted_divider.dart';
import 'package:ward/global_widgets/plant_care_req.dart';
import 'package:ward/global_widgets/plant_details_data.dart';
import 'package:ward/global_widgets/see_more_containers.dart';

class PlantDetails extends StatefulWidget {
  final String plantID;

  const PlantDetails({super.key, required this.plantID});

  @override
  PlantDetailsState createState() => PlantDetailsState();
}

class PlantDetailsState extends State<PlantDetails> {
  final PageController _pageController = PageController();
  bool _isTapped = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('plants')
                .where('plant_id', isEqualTo: widget.plantID)
                .get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var plant = snapshot.data!.docs.first;
              List<dynamic> images = plant['images'];

              return SingleChildScrollView(

                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display the image slider
                      images.isNotEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.55,
                                  width: screenWidth,
                                  child: Stack(
                                    children:[
                                      PageView.builder(
                                      // create a ui builder for the images from db
                                      controller: _pageController,
                                      itemCount: images.length,
                                      itemBuilder: (context, index) {
                                        return CachedNetworkImage(
                                          //use this package instead of Image.Network for faster rendering and saving the image from url as cache for not rendering it every time you scroll by it
                                          imageUrl: images[index],
                                          width: screenWidth,
                                          height: screenHeight * 0.55,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => const Center(
                                              child:
                                              CircularProgressIndicator()), //widget that will be shown until image renders
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                //if error happened rendering the image
                                                "assets/images/no image found.png",
                                                height: screenHeight * 0.55,
                                                width: screenWidth,
                                                fit: BoxFit.cover,
                                              ),
                                        );
                                      },
                                    ),
                                      SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 35,
                                            height: 35,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black54,
                                            ),
                                            child: IconButton(
                                                onPressed: () => Navigator.pop(context),
                                                icon: const Icon(
                                                  size: 20,
                                                  Icons.close,
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SmoothPageIndicator(
                                  controller: _pageController,
                                  count: images.length,
                                  effect: ExpandingDotsEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    activeDotColor: Colors.green,
                                    dotColor: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            )
                          : const Text('No images available'),
                      const SizedBox(height: 20),
                      // Plant details
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(plant['common_name'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(plant['scientific_name']),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/plants_details_icons/3849677.png",
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                "Plant overview",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(plant["plant_overview"] ?? ""),
                      ),
                      const SizedBox(height: 15),
                      // Conditional "See More" button
                      if (!_isTapped)
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade500,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isTapped = true;
                                });
                              },
                              child: const Center(child: Text("See More")),
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: _isTapped,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/images/plants_details_icons/8044448.png",
                                    width: 40,
                                    height: 40,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "Care Guide for ${plant['common_name']} :",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            for (int i = 0; i < 13; i++)
                              SeeMoreContainers(
                                  iconImage: seeMoreData[i]["iconImage"],
                                  iconText: seeMoreData[i]["iconText"],
                                  textFromDB:
                                      plant[seeMoreData[i]["textFromDB"]]),
                            const SizedBox(height: 20),
                            // Show "Show Less" button
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade500,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isTapped = false;
                                    });
                                  },
                                  child: const Center(child: Text("Show Less")),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 25),
                        child: DottedDivider(
                          dashWidth: 1.0,
                          dashHeight: 2.0,
                          color: Colors.grey,
                          dotCount: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('short_requirements')
                            .where('plant_id', isEqualTo: widget.plantID)
                            .get(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text("No short information available"));
                          }

                          // Retrieve the first document from the query
                          var short = snapshot.data!.docs.first;

                          List<String> reqFieldsNames = [
                            "temperature",
                            "lighting",
                            "humidity",
                            "soil_type",
                            "soil_ph",
                            "bloom_time",
                            "native_area",
                            "toxicity",
                            "difficulty",
                          ];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Plant Care Requirements:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              for (int i = 0; i < reqFieldsNames.length; i++)
                                PlantCareReq(
                                  reqIcon: plantReqMap[i]
                                      ["icon"], // data from Class PlantCareReq
                                  reqText: plantReqMap[i]["reqText"],
                                  reqData: short[
                                      reqFieldsNames[i]], // data from Firestore
                                  containerColor: plantReqMap[i]
                                      ["iconContainerColor"],
                                  rowColor: plantReqMap[i]["rowColor"],
                                ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 35),
                        child: DottedDivider(
                          dashWidth: 1.0,
                          dashHeight: 2.0,
                          color: Colors.grey,
                          dotCount: 32,
                        ),
                      ),
                      FutureBuilder(
                        //creates a ui screen for the data coming faq collection to display
                        future: FirebaseFirestore.instance
                            .collection("faqs")
                            .where('plant_id', isEqualTo: widget.plantID)
                            .get(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text("No short information available"));
                          }

                          // Get the list of FAQs from the first document
                          var faqDocument = snapshot.data!.docs.first;
                          List<dynamic> faqs =
                              faqDocument["faq"] ?? []; // Access the FAQ array

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/plants_details_icons/14293500.png",
                                      width: 50,
                                      height: 40,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "People Often Ask",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ))
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // display each FAQ in an ExpansionTile
                                ListView.builder(
                                  // use it to duplicate multiple ExpansionTile
                                  shrinkWrap:
                                      true, // Set to true to prevent overflow
                                  physics:
                                      const NeverScrollableScrollPhysics(), // disable scrolling
                                  itemCount: faqs.length,
                                  itemBuilder: (context, index) {
                                    var faq = faqs[index];
                                    String question = faq["question"] ??
                                        "No question available";
                                    String answer =
                                        faq["answer"] ?? "No answer available";

                                    return CustomizedExpansionTile(
                                        question: question, answer: answer);
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ]),
              );
            })
    );
  }
}
