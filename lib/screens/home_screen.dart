import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:anapoorna/services/auth_service.dart';
import 'package:anapoorna/services/donation_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final DonationService donationService = DonationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anapoorna Home'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Logout'),
            onPressed: () async {
              await auth.signOut();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: donationService.donations, // This now exists in the service
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              // Get data safely
              Map<String, dynamic> donation = 
                  data[index].data()! as Map<String, dynamic>;
              String docId = data[index].id;

              return Card(
                child: ListTile(
                  title: Text(donation['foodItem'] ?? 'Unknown Item'),
                  subtitle: Text("Qty: ${donation['quantity']}"),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // This method now exists in the service
                      donationService.claimDonation(docId); 
                    },
                    child: const Text("Claim"),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
           // Navigate to your DonationForm here
           // Navigator.push(context, MaterialPageRoute(builder: (_) => DonationForm()));
        },
      ),
    );
  }
}