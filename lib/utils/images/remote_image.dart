import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageGeneralUtils {
  static CachedNetworkImage loadImageUrlDefault(String url,
      {BoxFit fit = BoxFit.fitHeight,
      double? height,
      double width = double.infinity,
      Widget? placeholder,
      Widget? errorWidget}) {
    return CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ??
            Container(
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
        errorWidget: (context, url, error) => CircularProgressIndicator(
              color: Colors.blue,
            ));
  }
}
