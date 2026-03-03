import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import '../utils/theme.dart';
import '../widgets/product_card.dart';
import 'api_product_detail_screen.dart';

/// A generic list screen that shows all products in a given category.
///
/// This screen is usable from anywhere in the app; it loads products from
/// the FakeStore API and applies a category filter.  If the category is
/// `'All'` the entire catalog is displayed.
class ProductListScreen extends StatefulWidget {
  final String category;
  const ProductListScreen({super.key, required this.category});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ApiService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        title: Text(widget.category),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.softPastelGradient),
        child: FutureBuilder<List<Product>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: \\${snapshot.error}'));
            }

            final all = snapshot.data ?? [];
            final filtered = widget.category == 'All'
                ? all
                : all.where((p) => p.category == widget.category).toList();

            if (filtered.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final p = filtered[index];
                  return ProductCard(
                    product: p,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ApiProductDetailScreen(product: p),
                        ),
                      );
                    },
                    onFavoriteChanged: (isFav) {
                      setState(() {
                        p.isFavorite = isFav;
                        FavoriteService().toggle(p);
                      });
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
