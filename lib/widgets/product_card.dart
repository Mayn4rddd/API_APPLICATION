import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteChanged;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteChanged,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () {},
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with favorite button
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    color: const Color(0xFFF5F5F5),
                  ),
                  child: Center(
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.shopping_bag_outlined,
                          size: 60,
                          color: Colors.grey[300],
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      widget.onFavoriteChanged?.call(isFavorite);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? const Color(0xFFE74C3C)
                            : const Color(0xFFB0B0B0),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8FB3C7),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: const Color(0xFFF39C12),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${widget.product.rating}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF555555),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
