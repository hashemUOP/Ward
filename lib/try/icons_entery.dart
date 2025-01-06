import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateShortRequirementForm extends StatefulWidget {
  @override
  _CreateShortRequirementFormState createState() => _CreateShortRequirementFormState();
}

class _CreateShortRequirementFormState extends State<CreateShortRequirementForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? SoilType;
  String? difficulty;
  String? humidity;
  String? lighting;
  String? nativeArea;
  String? soilPH;
  String? bloomTime;
  String? temperature;
  String? toxicity;
  String? plantId;

  // Dropdown choices
  final List<String> toxicityChoices = ['Toxic','Non-Toxic'];
  final List<String> lightingChoices = ['Full Sun', 'Part Sun', 'Shade'];
  final List<String> humidityChoices = ['Dry', 'High', 'Normal'];
  final List<String> difficultyChoices = ['Easy', 'Medium', 'Hard'];
  final List<String> plantTypeChoices = [
    'Leaf Plants',
    'Flowers',
    'Succulents and Cacti',
    'Trees',
    'Shrubs',
    'Herbs and Weeds',
    'Fruits',
    'Vegetables',
    'Toxic Plants',
  ];
  final List<String> sunExposureChoices = [
    'Part Shade',
    'Full Sun',
    'Partial Sun',
    'Full Sun to Part Shade',
  ];
  final List<String> soilTypeChoices = ['Sandy', 'Rich, well drained', 'Rich, moist-soil'];

  Future<void> _submitForm() async {
    // Save form values without validation
    _formKey.currentState!.save();

    // Creating a document in Firestore with auto-generated ID
    await FirebaseFirestore.instance.collection('short_requirements').add({
      'temperature': temperature,       // 1. Temperature
      'lighting': lighting,             // 2. Lighting
      'humidity': humidity,             // 3. Humidity
      'soil_type': SoilType,            // 4. Soil Type
      'soil_ph': soilPH,                // 5. Soil pH
      'bloom_time': bloomTime,          // 6. Bloom Time
      'native_area': nativeArea,        // 7. Native Area
      'toxicity': toxicity,             // 8. Toxicity
      'difficulty': difficulty,         // 9. Difficulty
      'plant_id': plantId,              // 10. Plant ID
    });

    // Clear the form after submission
    _formKey.currentState!.reset();
    setState(() {
      SoilType = null;
      difficulty = null;
      humidity = null;
      lighting = null;
      nativeArea = null;
      soilPH = null;
      bloomTime = null;
      temperature = null;
      toxicity = null;
      plantId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Short requirement added successfully')));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Short Requirement Document'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Common Name Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Soil Type'),
                onSaved: (value) => SoilType = value?.isEmpty ?? true ? null : value,
              ),
              // Difficulty Field (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Difficulty'),
                items: difficultyChoices.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => difficulty = value),
              ),
              // Humidity Field (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Humidity'),
                items: humidityChoices.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => humidity = value),
              ),
              // Lighting Field (Dropdown)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Lighting'),
                items: lightingChoices.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => lighting = value),
              ),
              // Native Area Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Native Area'),
                onSaved: (value) => nativeArea = value?.isEmpty ?? true ? null : value,
              ),
              // Soil pH Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Soil pH'),
                onSaved: (value) => soilPH = value?.isEmpty ?? true ? null : value,
              ),
              // Temperature Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Temperature'),
                onSaved: (value) => temperature = value?.isEmpty ?? true ? null : value,
              ),
              // Toxicity Field
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Toxicity'),
                items: toxicityChoices.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => toxicity = value),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Bloom Time'),
                onSaved: (value) => bloomTime = value?.isEmpty ?? true ? null : value,
              ),
              // Plant ID Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Plant ID'),
                onSaved: (value) => plantId = value?.isEmpty ?? true ? null : value,
              ),
              const SizedBox(height: 20),
              // Submit Button
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
