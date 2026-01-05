class Donation {
  final String id;
  final String donorId;
  final String foodItem;
  final String description;
  final String quantity;
  final DateTime timestamp;
  final bool isClaimed;
  
  // --- NEW: Location Fields ---
  final double latitude;
  final double longitude;

  Donation({
    required this.id,
    required this.donorId,
    required this.foodItem,
    required this.description,
    required this.quantity,
    required this.timestamp,
    this.isClaimed = false,
    // Defaults to 0.0 if not provided
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'donorId': donorId,
      'foodItem': foodItem,
      'description': description,
      'quantity': quantity,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isClaimed': isClaimed,
      // Save location to database
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Donation.fromMap(String id, Map<String, dynamic> map) {
    return Donation(
      id: id,
      donorId: map['donorId'] ?? '',
      foodItem: map['foodItem'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
      isClaimed: map['isClaimed'] ?? false,
      // Read location from database (safely)
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
    );
  }
}