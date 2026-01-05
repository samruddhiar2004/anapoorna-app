import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/donation_service.dart';
import '../services/ai_service.dart';
import '../services/auth_service.dart'; // To get the current User ID

class DonationForm extends StatefulWidget {
  const DonationForm({super.key});

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers allow us to read the text inside the fields
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String? _aiSuggestion; // Stores the response from Gemini
  bool _isAnalyzing = false; // Shows loading spinner for AI
  bool _isSubmitting = false; // Shows loading spinner for Database

  @override
  void dispose() {
    // Always clean up controllers when closing the page
    _itemController.dispose();
    _qtyController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final donationService = Provider.of<DonationService>(context, listen: false);
    final aiService = Provider.of<AiService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate Food'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Food Item Name
              TextFormField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: 'Food Item (e.g., Rice, Bread)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.fastfood),
                ),
                validator: (val) => val!.isEmpty ? 'Please enter food name' : null,
              ),
              const SizedBox(height: 15),

              // 2. Quantity
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(
                  labelText: 'Quantity (e.g., 5kg, 20 plates)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (val) => val!.isEmpty ? 'Please enter quantity' : null,
              ),
              const SizedBox(height: 15),

              // 3. AI Analysis Button
              // This is where we use Google Gemini!
              ElevatedButton.icon(
                icon: _isAnalyzing 
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.auto_awesome),
                label: Text(_isAnalyzing ? "Asking Gemini..." : "Get AI Safety Tips"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[100],
                  foregroundColor: Colors.purple[800],
                ),
                onPressed: () async {
                  if (_itemController.text.isNotEmpty && _qtyController.text.isNotEmpty) {
                    setState(() => _isAnalyzing = true);
                    
                    // Call the AI Service
                    String suggestion = await aiService.analyzeFoodDonation(
                      _itemController.text, 
                      _qtyController.text
                    );

                    setState(() {
                      _aiSuggestion = suggestion;
                      _isAnalyzing = false;
                      // Auto-fill description if empty
                      if (_descController.text.isEmpty) {
                        _descController.text = suggestion;
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fill in Item and Quantity first!"))
                    );
                  }
                },
              ),

              // Display AI Result if it exists
              if (_aiSuggestion != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Text(
                    "✨ Gemini Suggests: $_aiSuggestion",
                    style: TextStyle(color: Colors.purple[900], fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              const SizedBox(height: 15),

              // 4. Description
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description / Instructions',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 30),

              // 5. Submit Button
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isSubmitting = true);

                      // Get current user ID (safely)
                      String uid = "";
                      // We subscribe to the stream once to get the value
                      final user = await authService.user.first;
                      if (user != null) {
                        uid = user.uid;
                      }

                      await donationService.addDonation(
                        donorId: uid,
                        foodItem: _itemController.text,
                        quantity: _qtyController.text,
                        description: _descController.text,
                      );

                      if (context.mounted) {
                        setState(() => _isSubmitting = false);
                        Navigator.pop(context); // Go back to Home
                      }
                    }
                  },
                  child: _isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('POST DONATION', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}