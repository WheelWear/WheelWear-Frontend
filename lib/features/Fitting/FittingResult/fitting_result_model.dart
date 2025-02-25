import 'dart:convert';
import 'package:wheelwear_frontend/features/Closet/models/closet_item.dart';

/// BodyImage 모델: 응답 데이터의 body_image 객체를 파싱합니다.
class BodyImage {
  final int id;
  final String gender;
  final int chestCircumference;
  final int shoulderWidth;
  final int armLength;
  final int waistCircumference;
  final String owner;
  final String bodyImage;
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
      id: json['id'] as int,
      gender: json['gender'] as String,
      chestCircumference: json['chest_circumference'] as int,
      shoulderWidth: json['shoulder_width'] as int,
      armLength: json['arm_length'] as int,
      waistCircumference: json['waist_circumference'] as int,
      owner: json['owner'] as String,
      bodyImage: json['body_image'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isFavorite: json['is_favorite'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'chest_circumference': chestCircumference,
      'shoulder_width': shoulderWidth,
      'arm_length': armLength,
      'waist_circumference': waistCircumference,
      'owner': owner,
      'body_image': bodyImage,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'is_favorite': isFavorite,
    };
  }
}

/// VirtualTryOnImage 모델 수정
class VirtualTryOnImage {
  final String image;
  final String title;
  final BodyImage? bodyImage;
  final int? vtonImage;
  final ClosetItem? topCloth;
  final ClosetItem? bottomCloth;
  final ClosetItem? dressCloth;
  final bool isFavorite;
  final bool saved;

  VirtualTryOnImage({
    required this.image,
    required this.title,
    this.bodyImage,
    this.vtonImage,
    this.topCloth,
    this.bottomCloth,
    this.dressCloth,
    required this.isFavorite,
    required this.saved,
  });

  /// JSON 데이터를 받아 객체로 변환합니다.
  factory VirtualTryOnImage.fromJson(Map<String, dynamic> json) {
    return VirtualTryOnImage(
      image: json['image'] as String,
      title: json['title'] as String,
      bodyImage: json['body_image'] != null
          ? BodyImage.fromJson(json['body_image'])
          : null,
      vtonImage: json['vton_image'] as int?,
      topCloth: json['top_cloth'] != null
          ? ClosetItem.fromJson(json['top_cloth'])
          : null,
      bottomCloth: json['bottom_cloth'] != null
          ? ClosetItem.fromJson(json['bottom_cloth'])
          : null,
      dressCloth: json['dress_cloth'] != null
          ? ClosetItem.fromJson(json['dress_cloth'])
          : null,
      isFavorite: json['is_favorite'] as bool,
      saved: json['saved'] as bool,
    );
  }

  /// 객체를 JSON 형태(Map)로 변환합니다.
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'title': title,
      'body_image': bodyImage?.toJson(),
      'vton_image': vtonImage,
      'top_cloth': topCloth?.toJson(),
      'bottom_cloth': bottomCloth?.toJson(),
      'dress_cloth': dressCloth?.toJson(),
      'is_favorite': isFavorite,
      'saved': saved,
    };
  }
}
