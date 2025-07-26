
class CreateDiaryModel {
  final String ownerId;
  final String location;
  final String name;
  final String resume;
  final String coverImage;
  final List<String> images;
  final double rating;
  final bool isPrivate;

  CreateDiaryModel({
    required this.ownerId,
    required this.location,
    required this.name,
    required this.coverImage,
    required this.resume,
    required this.images,
    required this.rating,
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
      "isPrivate": isPrivate,
    };
  }
}