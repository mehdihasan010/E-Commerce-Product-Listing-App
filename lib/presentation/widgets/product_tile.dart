import 'package:ecommerce_product_listing_app/domain/entities/product_entity.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_event.dart';
import 'package:ecommerce_product_listing_app/presentation/widgets/cached_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductTile extends StatelessWidget {
  final ProductEntity product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CachedImageWidget(
                imageUrl: product.image,
                width: 160,
                height: 160,
                fit: BoxFit.fill,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              Positioned(
                top: 4,
                right: 12,
                child: GestureDetector(
                  onTap:
                      () => context.read<ProductBloc>().add(
                        ToggleFavorite(product.id),
                      ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.favorite,
                      color:
                          product.isFavorite
                              ? Colors.red
                              : Colors.grey.shade300,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Reduced from 12
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced from 8
                  Row(
                    children: [
                      Expanded(
                        // Wrap price row in Expanded
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14, // Reduced from 20
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4), // Reduced from 8
                            Flexible(
                              child: Text(
                                '\$40.25',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '15% OFF',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8), // Reduced from 12
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 12, // Reduced from 16
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4), // Reduced from 4
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4), // Reduced from 8
                      Text(
                        '(${product.ratingCount})',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
