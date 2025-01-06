import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  final Widget searchBarReferal;
  final String upperText;
  final String lowerText;
  final String searchBarText;

  const Header({
    super.key,
    required this.searchBarReferal,
    required this.upperText,
    required this.searchBarText,
    required this.lowerText,
  });

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {


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

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade500,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.upperText,
                style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.lowerText,
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Stack(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.1,
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
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.02,
                    ),
                    child: GestureDetector(
                      onTap: () => handleTap(widget.searchBarReferal),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.01,
                          horizontal: screenWidth * 0.04,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey[600]),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Text(
                                widget.searchBarText,
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
