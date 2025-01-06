import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiseasesEntry extends StatefulWidget {
  @override
  _DiseasesEntryState createState() => _DiseasesEntryState();
}

class _DiseasesEntryState extends State<DiseasesEntry> {
  final _formKey = GlobalKey<FormState>();

  // Form fields

  String? commonName;
  String? scientificName;
  String? type;
  String? host;
  String? conditions;
  String? symptoms;
  String? prevention;
  String? imageUrl1;
  String? imageUrl2;
  String? imageUrl3;
  String? diseaseId;

  // Controllers for image URLs
  final TextEditingController image1Controller = TextEditingController();
  final TextEditingController image2Controller = TextEditingController();
  final TextEditingController image3Controller = TextEditingController();


  // Method to submit the form and create a document in Firestore
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Creating a document in Firestore with auto-generated ID
      await FirebaseFirestore.instance.collection('common_diseases').add({

        'common_name': commonName,
        'scientific_name': scientificName,
        "type" : type,
        "host" : host,
        "conditions" : conditions,
        "symptoms" : symptoms,
        "prevention" : prevention,
        'images': [
          imageUrl1,
          imageUrl2,
          imageUrl3,
        ],  // Storing image URLs
        'disease_id': diseaseId,
      });

      // Clear the form after submission
      _formKey.currentState!.reset();
      image1Controller.clear();
      image2Controller.clear();
      image3Controller.clear();


      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('disease added successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Plant Document'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Plant ID

              // Common Name
              TextFormField(
                decoration: const InputDecoration(labelText: 'Common Name'),
                onSaved: (value) => commonName = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter common name' : null,
              ),
              // Scientific Name
              TextFormField(
                decoration: const InputDecoration(labelText: 'Scientific Name'),
                onSaved: (value) => scientificName = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter scientific name' : null,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'type'),
                onSaved: (value) => type = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter type' : null,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'host'),
                onSaved: (value) => host = value,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'conditions'),
                onSaved: (value) => conditions = value,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'symptoms'),
                onSaved: (value) => symptoms = value,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'prevention'),
                onSaved: (value) => prevention = value,
              ),
              // Image URL Fields
              TextFormField(
                controller: image1Controller,
                decoration: const InputDecoration(labelText: 'Image URL 1'),
                onSaved: (value) => imageUrl1 = value,
                validator: (value) =>
                value!.isEmpty ? 'Please provide an image URL' : null,
              ),
              TextFormField(
                controller: image2Controller,
                decoration: const InputDecoration(labelText: 'Image URL 2'),
                onSaved: (value) => imageUrl2 = value,
                validator: (value) =>
                value!.isEmpty ? 'Please provide an image URL' : null,
              ),
              TextFormField(
                controller: image3Controller,
                decoration: const InputDecoration(labelText: 'Image URL 3'),
                onSaved: (value) => imageUrl3 = value,
                validator: (value) =>
                value!.isEmpty ? 'Please provide an image URL' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'disease ID'),
                onSaved: (value) => diseaseId = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter disease ID' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
