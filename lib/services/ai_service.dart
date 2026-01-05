import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // ⚠️ IMPORTANT: Replace this with your actual API Key from Google AI Studio
  // Get one here: https://aistudio.google.com/app/apikey
  static const String _apiKey = 'AIzaSyBIWKQkfSPGtnop7FD9mdOy4aJfuZ4BbDc';

  late final GenerativeModel _model;

  AiService() {
    _model = GenerativeModel(
      model: 'gemini-pro', 
      apiKey: _apiKey,
    );
  }

  // Feature 1: Analyze Food Quality & Suggestions
  Future<String> analyzeFoodDonation(String foodItem, String quantity) async {
    try {
      final prompt = 'A user is donating "$quantity of $foodItem". '
          'Suggest the best type of recipient (e.g., Orphanage, Food Bank, Compost) '
          'and give a 1-sentence safety tip.';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      return response.text ?? "AI Analysis unavailable.";
    } catch (e) {
      return "AI Service Error: Check API Key or Internet.";
    }
  }

  // Feature 2: Smart Matching (Future expansion)
  Future<String> matchDonorToVolunteer(String donorLoc, String volunteerLoc) async {
    // You can expand this later to compare coordinates textually or logically
    return "Matching logic initiated...";
  }
}