class Court {
  final String id;
  final String name;
  final String sport;
  final String address;
  final double pricePerHour;
  final String imageUrl;
  final List<String> amenities;


  const Court ({
    required this.id,
    required this.name,
    required this.sport,
    required this.address,
    required this.pricePerHour,
    required this.imageUrl,
    required this.amenities
  });
}
