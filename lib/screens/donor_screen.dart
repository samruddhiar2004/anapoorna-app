import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class DonorScreen extends StatefulWidget {
  const DonorScreen({super.key});

  @override
  State<DonorScreen> createState() => _DonorScreenState();
}

class _DonorScreenState extends State<DonorScreen> {
  final _picker = ImagePicker();
  bool _scanning = false;
  final _foodCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  Future<void> _scanFood() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _scanning = true);

    // MOCK AI DELAY (2 Seconds)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _scanning = false;
      // MOCK RESULT
      _foodCtrl.text = "Rice & Vegetable Curry";
      _qtyCtrl.text = "Approx 5 kg (20 servings)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Donate Food"), backgroundColor: const Color(0xFFFF6B00), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _scanFood,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: _scanning
                    ? const Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(color: Colors.orange), SizedBox(height: 10), Text("AI Analyzing...")])
                    : Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, size: 50, color: Colors.orange), const Text("Tap to Scan Food")]),
              ),
            ),
            const SizedBox(height: 30),
            if (_foodCtrl.text.isNotEmpty) ...[
              TextField(controller: _foodCtrl, decoration: const InputDecoration(labelText: "Food Item", border: OutlineInputBorder())),
              const SizedBox(height: 15),
              TextField(controller: _qtyCtrl, decoration: const InputDecoration(labelText: "Quantity", border: OutlineInputBorder())),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Listed Successfully!"), backgroundColor: Colors.green));
                   Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                child: const Text("Confirm Donation"),
              )
            ]
          ],
        ),
      ),
    );
  }
}