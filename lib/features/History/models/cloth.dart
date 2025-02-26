class Cloth {
  final int id;
  final String clothImage;
  final String? brand;
  final String? size;
  final String clothType;
  final String closetCategory;
  final bool isFavorite;
  final DateTime createdAt;
  final dynamic owner;
  final List<String> clothSubtypes;

  Cloth({
    required this.id,
    required this.clothImage,
    this.brand,
    this.size,
    required this.clothType,
    required this.closetCategory,
    required this.isFavorite,
    required this.createdAt,
    required this.owner,
    required this.clothSubtypes,
  });

  factory Cloth.fromJson(Map<String, dynamic> json) {
    return Cloth(
      id: json['id'],
      clothImage: json['clothImage'],
      brand: json['brand'],
      size: json['size'],
      clothType: json['cloth_type'],
      closetCategory: json['closet_category'],
      isFavorite: json['isFavorite'],
      createdAt: DateTime.parse(json['createdAt']),
      owner: json['owner'],
      clothSubtypes: json['cloth_subtypes'] != null
          ? List<String>.from(json['cloth_subtypes'])
          : [],
    );
  }
}
