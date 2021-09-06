import 'package:flutter/material.dart';
import 'log_utils.dart';
import '../../ui/resources/app_assets.dart';

class ImageUtils {
  const ImageUtils._internal();

  static Widget getNetworkImage(
    String? imageUrl, {
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return FadeInImage.assetNetwork(
      placeholder: AppAssets.image_placeholder,
      width: width,
      height: height,
      imageErrorBuilder: (context, error, stackTrace) {
        LogUtils.error('ImageUtils', 'getNetworkImage', error.toString());
        return _getErrorImage(
          width: width,
          height: height,
          fit: fit,
        );
      },
      image: imageUrl ?? '',
      fit: fit ?? BoxFit.fill,
    );
  }

  static Widget getLocalImage(
    String? imagePath, {
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Image.asset(
      imagePath ?? AppAssets.image_placeholder,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        LogUtils.error('ImageUtils', 'getLocalImage', error.toString());
        return _getErrorImage(
          width: width,
          height: height,
          fit: fit,
        );
      },
      fit: fit ?? BoxFit.fill,
    );
  }

  static Widget _getErrorImage({
    double? width,
    double? height,
    BoxFit? fit,
  }) {
    return Image.asset(
      AppAssets.image_placeholder,
      width: width,
      height: height,
      fit: fit ?? BoxFit.fill,
    );
  }
}
