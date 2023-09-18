import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUri;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final PlaceholderWidgetBuilder? placeholder;
  final ImageWidgetBuilder? imageBuilder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final FilterQuality filterQuality;
  @visibleForTesting
  static BaseCacheManager? testCacheManager;

  static CachedNetworkImageProvider provider({required String imageUri}) =>
      CachedNetworkImageProvider(imageUri, cacheManager: testCacheManager);

  const CustomCachedNetworkImage({
    Key? key,
    required this.imageUri,
    this.fit,
    this.width,
    this.height,
    this.placeholder,
    this.imageBuilder,
    this.errorWidget,
    this.filterQuality = FilterQuality.low,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: placeholder,
      imageUrl: imageUri,
      fit: fit,
      width: width,
      height: height,
      errorWidget: errorWidget,
      imageBuilder: imageBuilder,
      filterQuality: filterQuality,
      cacheManager: testCacheManager,
    );
  }
}
