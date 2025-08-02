
class PlaceAddress {
  final String amenity;
  final String road;
  final String city;
  final String state;
  final String country;

  PlaceAddress({
    required this.amenity,
    required this.road,
    required this.city,
    required this.state,
    required this.country,
  });

  factory PlaceAddress.fromJson(Map<String, dynamic> json) {
    return PlaceAddress(
      amenity: json['amenity'] ?? '',
      road: json['road'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }
}