import 'cloth.dart';
import 'body_image.dart';

class VirtualTryOnImage {
  final int id;
  final String image;
  final String title;
  final BodyImage bodyImage;
  final Cloth? topCloth;
  final Cloth? bottomCloth;
  final Cloth? dressCloth;

  VirtualTryOnImage({
    required this.id,
    required this.image,
    required this.title,
    required this.bodyImage,
    this.topCloth,
    this.bottomCloth,
    this.dressCloth,
  });

  factory VirtualTryOnImage.fromJson(Map<String, dynamic> json) {
    return VirtualTryOnImage(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      bodyImage: BodyImage.fromJson(json['body_image']),
      topCloth: json['top_cloth'] != null ? Cloth.fromJson(json['top_cloth']) : null,
      bottomCloth: json['bottom_cloth'] != null ? Cloth.fromJson(json['bottom_cloth']) : null,
      dressCloth: json['dress_cloth'] != null ? Cloth.fromJson(json['dress_cloth']) : null,
    );
  }
}
