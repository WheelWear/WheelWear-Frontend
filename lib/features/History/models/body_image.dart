class BodyImage {
  final int id;
  final String gender;
  final int chestCircumference;
  final int shoulderWidth;
  final int armLength;
  final int waistCircumference;
  final String owner;
  final String bodyImage; // URL
  final String title;
  final DateTime createdAt;
  final bool isFavorite;

  BodyImage({
    required this.id,
    required this.gender,
    required this.chestCircumference,
    required this.shoulderWidth,
    required this.armLength,
    required this.waistCircumference,
    required this.owner,
    required this.bodyImage,
    required this.title,
    required this.createdAt,
    required this.isFavorite,
  });

  factory BodyImage.fromJson(Map<String, dynamic> json) {
    return BodyImage(
      id: json['id'],
      gender: json['gender'],
      chestCircumference: json['chest_circumference'],
      shoulderWidth: json['shoulder_width'],
      armLength: json['arm_length'],
      waistCircumference: json['waist_circumference'],
      owner: json['owner'],
      bodyImage: json['body_image'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      isFavorite: json['is_favorite'],
    );
  }
}
