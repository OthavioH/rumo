
class UpdateDiaryModel {
  final String diaryId;
  final String ownerId;
  final String location;
  final String name;
  final String resume;
  final String coverImage;
  final List<String> images;
  final double rating;
  final bool isPrivate;
  final double latitude;
  final double longitude;

  UpdateDiaryModel({
    required this.diaryId,
    required this.ownerId,
    required this.location,
    required this.name,
    required this.coverImage,
    required this.resume,
    required this.images,
    required this.rating,
    required this.latitude,
    required this.longitude,
    this.isPrivate = false,
  });

  Map<String,dynamic> toMap() {
    return {
      "ownerId": ownerId,
      "location": location,
      "name": name,
      "resume": resume,
      "coverImage": coverImage,
      "images": images,
      "rating": rating,
      "latitude": latitude,
      "longitude": longitude,
      "isPrivate": isPrivate,
    };
  }
}