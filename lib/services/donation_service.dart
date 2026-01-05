import 'package:cloud_firestore/cloud_firestore.dart';

class DonationService {
  final String? uid;
  DonationService({this.uid});

  // Collection Reference
  final CollectionReference donationCollection =
      FirebaseFirestore.instance.collection('donations');

  // Fix: Added the 'donations' getter your home screen was looking for
  Stream<QuerySnapshot> get donations {
    return donationCollection.snapshots();
  }

  // Fix: Added the 'addDonation' method
  Future<void> addDonation({
    required String foodItem,
    required String description,
    required int quantity,
    required double latitude, // Fixed the missing parameter error
    required double longitude,
  }) async {
    return await donationCollection.doc().set({
      'foodItem': foodItem,
      'description': description,
      'quantity': quantity,
      'latitude': latitude,
      'longitude': longitude,
      'status': 'available',
      'timestamp': FieldValue.serverTimestamp(),
      'donorId': uid,
    });
  }

  // Fix: Added the 'claimDonation' method
  Future<void> claimDonation(String docId) async {
    return await donationCollection.doc(docId).update({
      'status': 'claimed',
      'claimedBy': uid,
    });
  }
}