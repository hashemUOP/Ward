// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UpdateDiseaseForm extends StatefulWidget {
//   @override
//   _UpdateDiseaseFormState createState() => _UpdateDiseaseFormState();
// }
//
// class _UpdateDiseaseFormState extends State<UpdateDiseaseForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _diseaseIdController = TextEditingController();
//   final _symptomsController = TextEditingController();
//   final _conditionsController = TextEditingController();
//   final _preventionController = TextEditingController();
//   final List<TextEditingController> _imageUrlControllers = List.generate(3, (index) => TextEditingController());
//
//   void _updateDocument() async {
//     if (_formKey.currentState!.validate()) {
//       String diseaseId = _diseaseIdController.text.trim();
//
//       // Find the document with the specified disease_id
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('common_diseases')
//           .where('disease_id', isEqualTo: diseaseId)
//           .get();
//
//       if (querySnapshot.docs.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No document found with disease_id: $diseaseId')));
//         return; // Exit the method if no document is found
//       }
//
//       // Assuming only one document is found, get the first one
//       DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
//
//       // Create a Map for the new data
//       Map<String, dynamic> newData = {
//         'symptoms': _symptomsController.text,
//         'conditions': _conditionsController.text,
//         'prevention': _preventionController.text,
//         'images': _imageUrlControllers.map((controller) => controller.text).toList(),
//       };
//
//       // Update the document by adding new fields
//       await documentSnapshot.reference.update(newData).then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Disease information updated successfully!')));
//         _clearForm();
//       }).catchError((error) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating document: $error')));
//       });
//     }
//   }
//
//   void _clearForm() {
//     _diseaseIdController.clear();
//     _symptomsController.clear();
//     _conditionsController.clear();
//     _preventionController.clear();
//     for (var controller in _imageUrlControllers) {
//       controller.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Update Disease')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _diseaseIdController,
//                 decoration: InputDecoration(labelText: 'Disease ID'),
//                 validator: (value) => value!.isEmpty ? 'Please enter a disease ID' : null,
//               ),
//               TextFormField(
//                 controller: _symptomsController,
//                 decoration: InputDecoration(labelText: 'Symptoms'),
//                 validator: (value) => value!.isEmpty ? 'Please enter symptoms' : null,
//               ),
//               TextFormField(
//                 controller: _conditionsController,
//                 decoration: InputDecoration(labelText: 'Conditions'),
//                 validator: (value) => value!.isEmpty ? 'Please enter conditions' : null,
//               ),
//               TextFormField(
//                 controller: _preventionController,
//                 decoration: InputDecoration(labelText: 'Prevention'),
//                 validator: (value) => value!.isEmpty ? 'Please enter prevention methods' : null,
//               ),
//               ..._imageUrlControllers.map((controller) {
//                 return TextFormField(
//                   controller: controller,
//                   decoration: InputDecoration(labelText: 'Image URL'),
//                   validator: (value) => value!.isEmpty ? 'Please enter an image URL' : null,
//                 );
//               }).toList(),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _updateDocument,
//                 child: Text('Update'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
