import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePlantForm extends StatefulWidget {
  @override
  _CreatePlantFormState createState() => _CreatePlantFormState();
}

class _CreatePlantFormState extends State<CreatePlantForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? plantId;
  String? commonName;
  String? scientificName;
  String? category;
  String? plantOverview;
  String? water;
  String? sunlight;
  String? fertilizer;
  String? soil;
  String? pruning;
  String? pottingRepotting;
  String? pestsAndDiseases;
  String? toxicity;
  String? propagation;
  String? temperature;
  String? imageUrl1;
  String? imageUrl2;
  String? imageUrl3;
  String? howToPlant;
  String? careWinter;
  String? transplant;

  // Controllers for image URLs
  final TextEditingController image1Controller = TextEditingController();
  final TextEditingController image2Controller = TextEditingController();
  final TextEditingController image3Controller = TextEditingController();

  // Dropdown categories
  final List<String> categories = [
    "Leaf Plants",
    "Flowers",
    "Succulents and Cacti",
    "Trees",
    "Shrubs",
    "Herbs and Weeds",
    "Fruits",
    "Vegetables",
    "Toxic Plants"
  ];

  // Method to submit the form and create a document in Firestore
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Creating a document in Firestore with auto-generated ID
      await FirebaseFirestore.instance.collection('plants').add({
        'plant_id': plantId,
        'common_name': commonName,
        'scientific_name': scientificName,
        'category': category,
        'plant_overview': plantOverview,
        'water': water,
        'sunlight': sunlight,
        'fertilizer': fertilizer,
        'soil': soil,
        'pruning': pruning,
        'potting_and_repotting': pottingRepotting,
        'pests_and_diseases': pestsAndDiseases,
        'toxicity': toxicity,
        'propagation': propagation,
        'temperature': temperature,
        'how_to_plant': howToPlant,
        'care_winter': careWinter,
        'transplant': transplant,
        'images': [
          imageUrl1,
          imageUrl2,
          imageUrl3,
        ],  // Storing image URLs
      });

      // Clear the form after submission
      _formKey.currentState!.reset();
      image1Controller.clear();
      image2Controller.clear();
      image3Controller.clear();
      setState(() {
        category = null;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Plant added successfully')));
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Plant ID'),
                onSaved: (value) => plantId = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter Plant ID' : null,
              ),
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
              // Dropdown for Category
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: category,
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              // Plant Overview
              TextFormField(
                decoration: const InputDecoration(labelText: 'Plant Overview'),
                onSaved: (value) => plantOverview = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Please enter plant overview' : null,
              ),
              // Water
              TextFormField(
                decoration: const InputDecoration(labelText: 'Water'),
                onSaved: (value) => water = value,
              ),
              // Sunlight
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sunlight'),
                onSaved: (value) => sunlight = value,
              ),
              // Fertilizer
              TextFormField(
                decoration: const InputDecoration(labelText: 'Fertilizer'),
                onSaved: (value) => fertilizer = value,
              ),
              // Soil
              TextFormField(
                decoration: const InputDecoration(labelText: 'Soil'),
                onSaved: (value) => soil = value,
              ),
              // Pruning
              TextFormField(
                decoration: const InputDecoration(labelText: 'Pruning'),
                onSaved: (value) => pruning = value,
              ),
              // Potting and Repotting
              TextFormField(
                decoration: const InputDecoration(labelText: 'Potting and Repotting'),
                onSaved: (value) => pottingRepotting = value,
              ),
              // Pests and Diseases
              TextFormField(
                decoration: const InputDecoration(labelText: 'Pests and Diseases'),
                onSaved: (value) => pestsAndDiseases = value,
              ),
              // Toxicity
              TextFormField(
                decoration: const InputDecoration(labelText: 'Toxicity'),
                onSaved: (value) => toxicity = value,
              ),
              // Propagation
              TextFormField(
                decoration: const InputDecoration(labelText: 'Propagation'),
                onSaved: (value) => propagation = value,
              ),
              // Temperature
              TextFormField(
                decoration: const InputDecoration(labelText: 'Temperature'),
                onSaved: (value) => temperature = value,
              ),
              // How to Plant
              TextFormField(
                decoration: const InputDecoration(labelText: 'How to Plant'),
                onSaved: (value) => howToPlant = value,
              ),
              // Care Winter
              TextFormField(
                decoration: const InputDecoration(labelText: 'Care Winter'),
                onSaved: (value) => careWinter = value,
              ),
              // Transplant
              TextFormField(
                decoration: const InputDecoration(labelText: 'Transplant'),
                onSaved: (value) => transplant = value,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: (){},
                child: const Text('Show Plants list'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
