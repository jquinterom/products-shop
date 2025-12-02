import 'package:flutter/material.dart';
import 'package:teslo_app/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        spacing: 16,
        children: [
          _ImageViewer(images: product.images),

          Text(product.title, textAlign: TextAlign.center),

          Text(product.price.toString()),
        ],
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;

  const _ImageViewer({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FadeInImage.assetNetwork(
        placeholder: 'assets/loaders/bottle-loader.gif',
        image: images.first,
        fit: BoxFit.cover,
        height: 250,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 200),
      ),
    );
  }
}
