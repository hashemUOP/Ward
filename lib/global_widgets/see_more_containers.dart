import 'package:flutter/material.dart';


class SeeMoreContainers extends StatelessWidget {
  final String iconImage;
  final String iconText;
  final String textFromDB;
  const SeeMoreContainers({super.key,required, required this.iconImage, required this.iconText, required this.textFromDB });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, bottom: 10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 0.2,
                      spreadRadius: 0.2,
                    )
                  ],
                ),
                height: 30,
                width: 30,
                child: Transform.scale(
                  scale: 0.6,
                  child: Image.asset(
                    iconImage,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain, // Make sure the image fits within the container
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  iconText,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Text(textFromDB),
    ),
    const SizedBox(height: 20)
      ],
    );


  }
}
