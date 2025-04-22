import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheService {
  final DefaultCacheManager _cacheManager = DefaultCacheManager();

  /// Pre-download and cache images for offline use
  Future<void> precacheImages(List<String> imageUrls) async {
    for (final url in imageUrls) {
      try {
        await _cacheManager.downloadFile(url);
      } catch (e) {
        // Silently continue if an image fails to cache
        continue;
      }
    }
  }

  /// Check if image is cached
  Future<bool> isImageCached(String imageUrl) async {
    final fileInfo = await _cacheManager.getFileFromCache(imageUrl);
    return fileInfo != null;
  }

  /// Clear all cached images
  Future<void> clearCache() async {
    await _cacheManager.emptyCache();
  }
}
