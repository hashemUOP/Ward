import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Try extends StatefulWidget {
  const Try({super.key});

  @override
  State<Try> createState() => _TryState();
}

class _TryState extends State<Try> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String documentId = 'RW8JeiduxQcS79uxOj39';
  String? plantName;
  String? plantImage;

  @override
  void initState() {
    super.initState();
    fetchPlantData();
  }

  Future<void> fetchPlantData() async {
    try {
      DocumentSnapshot doc = await firestore.collection('plants names').doc(documentId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          plantName = data['name'];
          plantImage = data['image'];
        });
      } else {
        print('No document found');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plant Data')),
      body: plantName != null && plantImage != null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Name: $plantName', style: TextStyle(fontSize: 24)),
          SizedBox(height: 16),
          Image.network(plantImage!),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
