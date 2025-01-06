import 'package:flutter/material.dart';
import 'package:ward/my_garden/add_plant.dart';

class NoPlantsScreen extends StatelessWidget {
  const NoPlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        children: [
          SizedBox(height: screenHeight*0.15,),
          Image.asset(
          "assets/images/9038324.png",
            width: screenWidth * 0.17,
          ),
          const SizedBox(height: 20),
          const Text(
            "You Have No Plants",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "Add your first plant and carry out\n your daily plant care routines.",
            style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14,color: Colors.grey.shade600),
            textAlign: TextAlign.center, // Centers the multi-line text
          ),
          const SizedBox(height: 30), // Space between text and button
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddPlant()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green[100], // Background color for the button
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Add Plant",
                style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.w400),
              ),
            ),
          )


        ],
      ),
    );
  }
}
