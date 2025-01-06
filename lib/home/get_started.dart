import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../global_widgets/customized_text.dart';

class GetStarted extends StatelessWidget {
  final List<Map<String, String>> data;
  const GetStarted({super.key, required this.data});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_circle_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:  MyText(
          fromLeft: 0,
          text: data[0]["title"]!,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var map in data)
                  for (var entry in map.entries)
                    if (entry.key.contains("header"))
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (entry.key.contains("body"))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w100),
                        ),
                      )
                    else if (entry.key.contains("img"))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Image.asset(
                            entry.value,
                            fit: BoxFit.cover,
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
