class DiaryModel {
  final String id;
  final String ownerId;
  final String name;
  final double rating;
  final String coverImage;
  final List<String> images;
  final bool isPrivate;
  final String location;
  final String resume;
  final double latitude;
  final double longitude;

  DiaryModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.rating,
    required this.coverImage,
    required this.images,
    this.isPrivate = false,
    required this.location,
    required this.resume,
    required this.latitude,
    required this.longitude,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      id: json['id'],
      ownerId: json['ownerId'],
      name: json['name'],
      rating: json['rating'],
      coverImage: json['coverImage'],
      images: List<String>.from(json['images']),
      location: json['location'],
      resume: json['resume'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isPrivate: json['isPrivate'],
    );
  }
}
