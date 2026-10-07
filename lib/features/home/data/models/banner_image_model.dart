class BannerImageModel {
  final String id;
  final String url;
  final String title;
  final String categoryId;
  final String imageUrl;

  BannerImageModel({
    required this.id,
    required this.url,
    required this.title,
    required this.categoryId,
    required this.imageUrl,
  });

  factory BannerImageModel.fromJson(Map<String, dynamic> json) {
    return BannerImageModel(
      id: json['id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      categoryId: json['category_id']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? '',
    );
  }
}
