import 'dart:convert';

// ClosetItem 모델 수정 (toJson 메서드 추가)
enum ClosetCategory {
  myClothes,  // 내옷
  wishlist,   // 위시리스트
  donation,   // 기부함
}

enum ClothType {
  Top,        // 상의
  Bottom,     // 하의
  Dress,      // 원피스
}

class ClosetItem {
  final int id;
  final ClosetCategory closetCategory; // 내옷, 위시리스트, 기부함 구분
  final ClothType clothType;           // 상의, 하의, 원피스 구분
  final String clothImage;             // URL 형식 이미지
  final String? size;
  final String? brand;
  final bool isFavorite;
  final List<String> clothSubtypes;    // 상세 유형(예: 후드티, 니트 등)

  ClosetItem({
    required this.id,
    required this.closetCategory,
    required this.clothType,
    required this.clothImage,
    this.brand,
    this.size,
    this.isFavorite = false,
    this.clothSubtypes = const [],
  });

  factory ClosetItem.fromJson(Map<String, dynamic> json) {
    ClosetCategory category;
    switch (json['closet_category'] as String) {
      case 'myClothes':
        category = ClosetCategory.myClothes;
        break;
      case 'wishlist':
        category = ClosetCategory.wishlist;
        break;
      case 'donation':
        category = ClosetCategory.donation;
        break;
      default:
        category = ClosetCategory.myClothes;
    }

    ClothType type;
    switch (json['cloth_type'] as String) {
      case 'Top':
        type = ClothType.Top;
        break;
      case 'Bottom':
        type = ClothType.Bottom;
        break;
      case 'Dress':
        type = ClothType.Dress;
        break;
      default:
        type = ClothType.Top;
    }

    return ClosetItem(
      id: json['id'] as int,
      closetCategory: category,
      clothType: type,
      clothImage: json['clothImage'] as String,
      brand: json['brand'] as String?,
      size: json['size'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      clothSubtypes: (json['cloth_subtypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'closet_category': closetCategory.toString().split('.').last,
      'cloth_type': clothType.toString().split('.').last,
      'clothImage': clothImage,
      'brand': brand,
      'size': size,
      'isFavorite': isFavorite,
      'cloth_subtypes': clothSubtypes,
    };
  }
}