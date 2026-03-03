import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import '../services/favorite_service.dart';
import '../utils/theme.dart';

class ApiProductDetailScreen extends StatelessWidget {
  final Product product;

  const ApiProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        actions: [
          IconButton(
            icon: ValueListenableBuilder<List<Product>>(
              valueListenable: FavoriteService().favorites,
              builder: (context, favs, _) {
                final isFav = favs.any((e) => e.id == product.id);
                return Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav
                      ? const Color(0xFFE74C3C)
                      : const Color(0xFFB0B0B0),
                );
              },
            ),
            onPressed: () {
              FavoriteService().toggle(product);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.softPastelGradient),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Image.network(
                product.imageUrl,
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8FB3C7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8FB3C7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  CartService().addItem(
                    CartItem(
                      product: product,
                      size: '',
                      color: '',
                      quantity: 1,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
