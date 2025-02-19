class ClosetItem {
  final int id;
  final String type;
  final String clothImage; // URL 형식
  final String? brand;
  final bool isFavorite;
  final List<String> clothSubtypes; // 문자열 리스트

  // id, type, clothImage는 필수값
  ClosetItem({
    required this.id,
    required this.type,
    required this.clothImage,
    this.brand,
    this.isFavorite = false,
    this.clothSubtypes = const [],
  });

  factory ClosetItem.fromJson(Map<String, dynamic> json) {
    return ClosetItem(
      id: json['id'] as int,
      type: json['type'] as String? ?? 'Top',
      clothImage: json['clothImage'] as String,
      brand: json['brand'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      clothSubtypes: (json['cloth_subtypes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
    );
  }
}
