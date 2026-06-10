class Lugar {
  Lugar({
    required this.image,
    required this.name,
    required this.location,
    required this.description,
    this.isFavorite = false,
    this.likes = 41,
  });

  final String image;
  final String name;
  final String location;
  final String description;

  bool isFavorite;
  int likes;
}