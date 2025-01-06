import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DiseaseDetails extends StatefulWidget {
  final String disease_id;
  const DiseaseDetails({super.key, required this.disease_id});

  @override
  State<DiseaseDetails> createState() => _DiseaseDetailsState();
}

class _DiseaseDetailsState extends State<DiseaseDetails> {
  final PageController _pageController = PageController();

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
        backgroundColor: Colors.white,
        body: SafeArea(
            child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('common_diseases')
                    .where('disease_id', isEqualTo: widget.disease_id)////important you can use more than one .where() to add more than one condition ex .where().where()
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var disease = snapshot.data!.docs.first;
                  List<dynamic> images = disease['images'];

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
                                            fit: BoxFit.contain,
                                            placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                CircularProgressIndicator()),
                                            //widget that will be shown until image renders
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
                                      ],
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
                          child: Text(disease['common_name'],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(disease['scientific_name']),
                        ),
                            const SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text("type :\t" + disease['type']),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text("host :\t" +disease['host']),
                            ),
                        const SizedBox(height: 40),
                        const Padding(
                          padding:
                              EdgeInsets.only(left: 30.0,bottom: 10),
                          child: Row(
                            children: [
                              Icon(Icons.fact_check_outlined,color: Colors.green,),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Conditions favoring disease",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(disease["conditions"] ?? ""),
                        ),

                            const SizedBox(height: 25),

                            const Padding(
                              padding:
                              EdgeInsets.only(left: 30.0,bottom: 8),
                              child: Row(
                                children: [
                                  Icon(Icons.search,color: Colors.green,),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "symptoms",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(disease["symptoms"] ?? ""),
                            ),

                            const SizedBox(height: 25),

                            const Padding(
                              padding:
                              EdgeInsets.only(left: 30.0,bottom: 10),
                              child: Row(
                                children: [
                                  Icon(Icons.health_and_safety_outlined,color: Colors.green,),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "prevention",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(disease["prevention"] ?? ""),
                            ),
                            const SizedBox(height: 30),
                        // Conditional "See More" button
                      ]));
                })));
  }
}
