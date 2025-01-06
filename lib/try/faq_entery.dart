import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateFaqForm extends StatefulWidget {
  const CreateFaqForm({super.key});

  @override
  _CreateFaqFormState createState() => _CreateFaqFormState();
}

class _CreateFaqFormState extends State<CreateFaqForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? plantId;
  List<Map<String, String>> faqs = [
    {"question": "", "answer": ""},
    {"question": "", "answer": ""},
    {"question": "", "answer": ""},
    {"question": "", "answer": ""},
  ];

  // Focus nodes to detect when each question is focused
  List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  String? hintText = "";

  @override
  void initState() {
    super.initState();

    // Add listeners to each FocusNode to update hint text dynamically
    _focusNodes[0].addListener(() {
      if (_focusNodes[0].hasFocus) {
        setState(() {
          hintText = "Is easy to grow?";
        });
      }
    });

    _focusNodes[1].addListener(() {
      if (_focusNodes[1].hasFocus) {
        setState(() {
          hintText = "How fast does it grow?";
        });
      }
    });

    _focusNodes[2].addListener(() {
      if (_focusNodes[2].hasFocus) {
        setState(() {
          hintText = "Why should you not plant it?";
        });
      }
    });

    _focusNodes[3].addListener(() {
      if (_focusNodes[3].hasFocus) {
        setState(() {
          hintText = "Can I plant it outside?";
        });
      }
    });
  }

  // Method to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Creating a document in Firestore with auto-generated ID
      await FirebaseFirestore.instance.collection('faqs').add({
        'plant_id': plantId,
        'faq': faqs,
      });

      // Clear the form after submission
      _formKey.currentState!.reset();
      setState(() {
        faqs = [
          {"question": "", "answer": ""},
          {"question": "", "answer": ""},
          {"question": "", "answer": ""},
          {"question": "", "answer": ""},
        ];
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('FAQs added successfully')));
    }
  }

  @override
  void dispose() {
    // Dispose of the focus nodes when no longer needed
    for (FocusNode node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create FAQ Document'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Plant ID Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Plant ID (FK)'),
                onSaved: (value) => plantId = value,
                validator: (value) => value == null || value.isEmpty ? 'Please enter Plant ID' : null,
              ),
              const SizedBox(height: 10),

              // FAQ Fields
              for (int i = 0; i < faqs.length; i++)
                Column(
                  children: [
                    TextFormField(
                      focusNode: _focusNodes[i],
                      decoration: InputDecoration(
                        labelText: 'Question ${i + 1}',
                        hintText: i == _focusNodes.indexWhere((fn) => fn.hasFocus) ? hintText : null,
                      ),
                      onChanged: (value) {
                        faqs[i]['question'] = value;
                      },
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a question' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Answer ${i + 1}'),
                      onChanged: (value) {
                        faqs[i]['answer'] = value;
                      },
                      validator: (value) => value == null || value.isEmpty ? 'Please enter an answer' : null,
                    ),
                    const SizedBox(height: 10),
                  ],
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
