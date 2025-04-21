import 'package:ecommerce_product_listing_app/domain/entities/product_entity.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductTile extends StatelessWidget {
  final ProductEntity product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        product.price * (1 - product.discountPercentage / 100);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Image.network(
                  product.thumbnail,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error'); // Log the error
                    return const Icon(
                      Icons.broken_image,
                      size: 140,
                    ); // Show a placeholder on error
                  },
                ),
              ),
              if (product.discountPercentage > 0)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '-${product.discountPercentage.round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap:
                      () => context.read<ProductBloc>().add(
                        ToggleFavorite(product.id),
                      ),
                  child: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: product.isFavorite ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '\$${discountedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (product.discountPercentage > 0) ...[
                      const SizedBox(width: 4),
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.orange),
                        Text(
                          product.rating?.toString() ?? 'N/A',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviews.length})',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            product.stock > 0
                                ? Colors.green[100]
                                : Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        product.stock > 0 ? 'In Stock' : 'Out of Stock',
                        style: TextStyle(
                          color:
                              product.stock > 0
                                  ? Colors.green[800]
                                  : Colors.red[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
