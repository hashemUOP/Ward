/*
the button + that adds plants to collection users_plants is in plants_listing.dart
 */
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ward/global_widgets/cat_data.dart';
import 'package:ward/global_widgets/home_cat_list.dart';
import 'package:ward/home/search_plant.dart';

class AddPlant extends StatefulWidget {
  const AddPlant({super.key});

  @override
  State<AddPlant> createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlant> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                  const AutoSizeText("Add Plant to Garden",style: TextStyle(fontWeight: FontWeight.bold),maxLines: 1,),
                ],
              ),
              SizedBox(height: screenHeight * 0.017),
              GestureDetector(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white
                  ),
                  child:const Row(
                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.search,color: Colors.grey,),
                      SizedBox(width: 10,),
                      Text("Search for plants",style: TextStyle(color: Colors.grey, fontSize: 14),)
                    ],
                  ),
                ),
                onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>const SearchPlant(
                        isForAddPlant: true,
                      )),
                    );
                  },
              )
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade100,
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            CatList(
              imageURL: images, // list of the cat images
              catName: names, // list of the cat names
              isForAddPlant: true,
            ),
          ],
        ),
      ),
    );
  }
}

