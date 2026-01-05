import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anapoorna/services/auth_service.dart';
import 'package:anapoorna/screens/home_screen.dart';
import 'package:anapoorna/screens/authenticate/authenticate.dart'; // Assuming you have a login screen here

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the user data from the provider
    final user = Provider.of<User?>(context);

    // Return either Home or Authenticate widget
    if (user == null) {
      // Replace with your actual Login/Register screen widget
      return const Scaffold(body: Center(child: Text("Please Login (Authenticate Screen)"))); 
    } else {
      return const HomeScreen();
    }
  }
}