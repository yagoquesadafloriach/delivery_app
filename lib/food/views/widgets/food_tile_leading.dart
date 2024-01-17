import 'package:delivery_app/constants/constants.dart';
import 'package:flutter/material.dart';

class FoodTileLeading extends StatelessWidget {
  const FoodTileLeading({required this.url, super.key});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 64,
        minHeight: 64,
        maxWidth: 64,
        maxHeight: 64,
      ),
      child: Image.network(
        url ?? noFoodImage,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 40,
          ),
        ),
      ),
    );
  }
}
