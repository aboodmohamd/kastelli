import 'package:kastelli/features/home/data/models/banner_image_model.dart';

class DashboardModel {
  final String title;
  final List<BannerImageModel> topBanners;
  final List<BannerImageModel> footerBanners;

  DashboardModel({
    required this.title,
    required this.topBanners,
    required this.footerBanners,
  });

  BannerImageModel? get middleImage =>
      footerBanners.isNotEmpty ? footerBanners.first : null;

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final banners = json['banners'] is Map ? json['banners'] as Map : {};

    return DashboardModel(
      title: json['title']?.toString() ?? '',
      topBanners: _imagesOf(banners['top_banner']),
      footerBanners: _imagesOf(banners['footer_banner']),
    );
  }

  static List<BannerImageModel> _imagesOf(dynamic groups) {
    if (groups is! List) return [];

    return groups
        .whereType<Map>()
        .expand((group) =>
            group['images'] is List ? group['images'] as List : const [])
        .whereType<Map<String, dynamic>>()
        .map(BannerImageModel.fromJson)
        .where((image) => image.imageUrl.isNotEmpty)
        .toList();
  }
}
