import 'package:flutter/material.dart';


class CustomizedExpansionTile extends StatelessWidget {
  final String question;
  final String answer;
  const CustomizedExpansionTile({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ExpansionTile(
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.grey),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color:Colors.grey),
            ),
            iconColor: Colors.green.shade500,
            textColor: Colors.green.shade500,
            title: Text(
              question,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  answer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
