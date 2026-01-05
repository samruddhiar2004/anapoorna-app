import 'package:flutter/material.dart';
import '../models/donation_model.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // DUMMY DATA LIST
    final donations = [
      Donation(id: '1', foodName: "Paneer Butter Masala", quantity: "3 kg", distance: "0.5 km", timeAgo: "10m", isVeg: true),
      Donation(id: '2', foodName: "Wedding Cake Leftover", quantity: "10 units", distance: "1.2 km", timeAgo: "25m", isVeg: false),
      Donation(id: '3', foodName: "Fresh Bread", quantity: "20 loaves", distance: "2.8 km", timeAgo: "1h", isVeg: true),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Food"), backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final item = donations[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item.isVeg ? Colors.green[100] : Colors.red[100],
                child: Icon(Icons.fastfood, color: item.isVeg ? Colors.green : Colors.red),
              ),
              title: Text(item.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${item.quantity} • ${item.distance} away"),
              trailing: ElevatedButton(
                onPressed: () => showDialog(context: context, builder: (_) => const _MapDialog()),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text("Accept"),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MapDialog extends StatelessWidget {
  const _MapDialog();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Route to Donor"),
      content: Container(
        height: 200,
        color: Colors.blue[50],
        child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.map, size: 50, color: Colors.blue), Text("Google Map View")])),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
    );
  }
}