import 'package:flutter/material.dart';
import 'package:ward/plants_listing_and_details/plants_listing.dart';

class CatList extends StatefulWidget {
  final List<String> imageURL;
  final List<String> catName;
  final bool? isForAddPlant;

  const CatList({super.key, required this.imageURL, required this.catName, this.isForAddPlant});

  @override
  _CatListState createState() => _CatListState();
}

class _CatListState extends State<CatList> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double containerWidth = screenWidth * 0.45;
    double containerHeight = screenHeight * 0.2;
    double horizontalMargin = screenWidth * 0.02;
    double verticalMargin = screenHeight * 0.01;

    return Column(
      children: [
        for (int i = 0; i < 8; i += 2)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to PlantsListing with catName[i]
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantsListing(
                            catName: widget.catName[i],
                            isForAddPlant: widget.isForAddPlant, // Pass the isForAddPlant to the next page if necessary
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  offset: const Offset(0, 1),
                                  blurRadius: 1,
                                  spreadRadius: 1),
                            ],
                          ),
                          height: containerHeight,
                          width: containerWidth,
                          margin: EdgeInsets.only(
                            left: horizontalMargin,
                            right: horizontalMargin,
                            top: verticalMargin,
                            bottom: verticalMargin,
                          ),
                          child: Image(
                            image: AssetImage(widget.imageURL[i]),
                            fit: BoxFit.cover,
                            height: containerHeight,
                            width: containerWidth,
                          ),
                        ),
                        Positioned(
                          bottom: 14,
                          left: 14,
                          child: Text(
                            widget.catName[i],
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: i == 2 ? 13 : 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to PlantsListing with catName[i + 1]
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantsListing(
                            catName: widget.catName[i + 1],
                            isForAddPlant: widget.isForAddPlant, // Pass the isForAddPlant to the next page if necessary
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  offset: const Offset(0, 1),
                                  blurRadius: 1,
                                  spreadRadius: 1),
                            ],
                          ),
                          height: containerHeight,
                          width: containerWidth,
                          margin: EdgeInsets.only(
                            left: horizontalMargin,
                            right: horizontalMargin,
                            top: verticalMargin,
                            bottom: verticalMargin,
                          ),
                          child: Image(
                            image: AssetImage(widget.imageURL[i + 1]),
                            fit: BoxFit.cover,
                            height: containerHeight,
                            width: containerWidth,
                          ),
                        ),
                        Positioned(
                          bottom: 14,
                          left: 14,
                          child: Text(
                            widget.catName[i + 1],
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: i == 5 || i == 7 ? 13 : 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
