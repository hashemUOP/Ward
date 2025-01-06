import 'package:flutter/material.dart';
import 'package:ward/global_widgets/color_convert.dart';

List<Map<String, dynamic>> plantReqMap = [
  {
    "icon": const Icon(
      Icons.thermostat,
      color: Colors.white,
    ),
    "reqText" : "Temperature",
    "iconContainerColor" : Colors.yellow.shade700,
    "rowColor": Colors.white,
  },
  {
    "icon": const Icon(
      Icons.sunny,
      color: Colors.white,
    ),
    "reqText" : "Lighting",
    "iconContainerColor" : Colors.yellow.shade900,
    "rowColor": hexToColor("#f8fcfb"),
  },
  {
    "icon": const ImageIcon(AssetImage("assets/images/plants_details_icons/humidity_percentage_25dp_E8EAED_FILL0_wght400_GRAD0_opsz24.png"),color: Colors.white,) ,
    "reqText" : "Humidity",
    "iconContainerColor" : Colors.blue,
    "rowColor": Colors.white,
  },
  {
    "icon": const ImageIcon(AssetImage("assets/images/plants_details_icons/icons8-ground-50.png"),color: Colors.white,) ,
    "reqText" : "Soil Type",
    "iconContainerColor" : Colors.pinkAccent,
    "rowColor": hexToColor("#f8fcfb"),
  },
  {
    "icon": const ImageIcon(AssetImage("assets/images/plants_details_icons/icons8-test-tube-100.png"),color: Colors.white,) ,
    "reqText" : "Soil PH",
    "iconContainerColor" : Colors.purpleAccent,
    "rowColor": Colors.white,
  },
  {
    "icon": const Icon(Icons.access_time_filled_rounded,color: Colors.white,) ,
    "reqText" : "Bloom Time",
    "iconContainerColor" : Colors.green,
    "rowColor": hexToColor("#f8fcfb"),
  },
  {
    "icon": const Icon(color: Colors.white,Icons.location_on) ,
    "reqText" : "Native Area",
    "iconContainerColor" : Colors.blueAccent.shade700,
    "rowColor": Colors.white,
  },
  {
    "icon": const Icon(Icons.warning,color: Colors.white,) ,
    "reqText" : "Toxicity",
    "iconContainerColor" : Colors.red,
    "rowColor": hexToColor("#f8fcfb"),
  },
  {
    "icon": const Icon(Icons.signal_cellular_alt_sharp,color: Colors.white,) ,
    "reqText" : "Difficulty",
    "iconContainerColor" : Colors.brown.shade400,
    "rowColor": Colors.white,
  }
];



List<Map<String, dynamic>> seeMoreData = [
  {
  "iconImage" : "assets/images/plants_details_icons/5611083.png",
  "iconText" : "Water",
  "textFromDB" : "water",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/4260528.png",
    "iconText" : "Light",
    "textFromDB" : "sunlight",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/5991492.png",
    "iconText" : "Temperature",
    "textFromDB" : "temperature",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/1574993.png",
    "iconText" : "Soil",
    "textFromDB" : "soil",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/9137274.png",
    "iconText" : "Fertilization",
    "textFromDB" : "fertilizer",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/226479.png",
    "iconText" : "Pruning",
    "textFromDB" : "pruning",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/9571756.png",
    "iconText" : "Propagation",
    "textFromDB" : "propagation",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/2813955.png",
    "iconText" : "Transplant",
    "textFromDB" : "transplant",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/292493.png",
    "iconText" : "Winter care",
    "textFromDB" : "care_winter",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/8892701.png",
    "iconText" : "How to plant",
    "textFromDB" : "how_to_plant",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/5811652.png",
    "iconText" : "Repotting",
    "textFromDB" : "potting_and_repotting",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/4850385.png",
    "iconText" : "Popular Pests and Diseases",
    "textFromDB" : "pests_and_diseases",
  },
  {
    "iconImage" : "assets/images/plants_details_icons/12898687.png",
    "iconText" : "Toxicity",
    "textFromDB" : "toxicity",
  },
  ];
