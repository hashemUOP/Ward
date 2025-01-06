// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:html' as html; // Import the HTML package for web functionality
//
// class CommonDiseasesPage extends StatefulWidget {
//   @override
//   _CommonDiseasesPageState createState() => _CommonDiseasesPageState();
// }
//
// class _CommonDiseasesPageState extends State<CommonDiseasesPage> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   Future<void> _exportDataToTextFile() async {
//     // Get the collection data, sorted by disease_id
//     QuerySnapshot querySnapshot = await firestore
//         .collection('common_diseases')
//         .orderBy('disease_id', descending: true) // Sorting by disease_id
//         .get();
//
//     // Prepare data to write with specific formatting
//     StringBuffer dataBuffer = StringBuffer();
//     for (var doc in querySnapshot.docs) {
//       var data = doc.data() as Map<String, dynamic>;
//
//       // Extract fields
//       String diseaseId = data['disease_id']?.toString() ?? '';
//       String host = data['host']?.toString() ?? '';
//       String commonName = data['common_name']?.toString() ?? '';
//       String scientificName = data['scientific_name']?.toString() ?? '';
//       String type = data['type']?.toString() ?? '';
//
//       // Write to buffer in the format: disease_id host common_name scientific_name type
//       dataBuffer.writeln('$diseaseId $host $commonName $scientificName $type');
//     }
//
//     // Create a Blob from the text data
//     final blob = html.Blob([dataBuffer.toString()], 'text/plain', 'native');
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute('download', 'common_diseases.txt') // Set the filename
//       ..click(); // Trigger download
//
//     // Cleanup
//     html.Url.revokeObjectUrl(url); // Release the object URL
//
//     // Optional: Display a confirmation message
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Data exported to common_diseases.txt')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Common Diseases'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _exportDataToTextFile,
//           child: Text('Export Data to Text File'),
//         ),
//       ),
//     );
//   }
// }
