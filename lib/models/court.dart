enum Sport {
  football('Футбол'),
  tennis('Теннис'),
  basketball('Баскетбол'),
  volleyball('Волейбол');

  final String label;
  const Sport(this.label);
}

class Court {
  final String id;
  final String name;
  final Sport sport;
  final String district;
  final String address;
  final double pricePerHour;
  final String imageUrl; // used from L5
  final List<String> amenities;

  const Court({
    required this.id,
    required this.name,
    required this.sport,
    required this.district,
    required this.address,
    required this.pricePerHour,
    required this.imageUrl,
    required this.amenities,
  });
}