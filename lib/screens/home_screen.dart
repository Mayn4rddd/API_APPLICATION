import 'package:flutter/material.dart';
import 'package:api_application/services/api_service.dart';

import '../models/product.dart';
import '../services/favorite_service.dart';
import '../utils/theme.dart';
import 'api_product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  String _search = '';
  late Future<List<dynamic>> _combinedFuture; // [List<Product>, List<String>]

  @override
  void initState() {
    super.initState();
    _combinedFuture = Future.wait([
      ApiService.fetchProducts(),
      ApiService.fetchCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.softPastelGradient),
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 80,
              floating: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            color: Color(0xFF8FB3C7),
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Main Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: InputDecoration(
                        hintText: 'Search product',
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFB0B0B0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        hintStyle: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Products + banner + categories are loaded from API
                  FutureBuilder<List<dynamic>>(
                    future: _combinedFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 240,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError) {
                        return SizedBox(
                          height: 240,
                          child: Center(
                            child: Text('Error: ${snapshot.error}'),
                          ),
                        );
                      }

                      final products =
                          (snapshot.data?[0] ?? []) as List<Product>;
                      final apiCategories =
                          (snapshot.data?[1] ?? []) as List<String>;

                      // build category list (include All)
                      final categories = ['All', ...apiCategories];

                      // banner removed; no promotional container

                      // Category chips
                      Widget chips = SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = selectedCategory == category;
                            final display = category == 'All'
                                ? 'All'
                                : (category[0].toUpperCase() +
                                      category.substring(1));
                            return FilterChip(
                              label: Text(
                                display,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF8FB3C7),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (value) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: const Color(0xFF8FB3C7),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFF8FB3C7)
                                    : const Color(
                                        0xFF8FB3C7,
                                      ).withValues(alpha: 0.3),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            );
                          },
                        ),
                      );

                      // Filter products by search & category
                      final filtered = products.where((p) {
                        final matchesSearch =
                            _search.isEmpty ||
                            p.name.toLowerCase().contains(
                              _search.toLowerCase(),
                            );
                        final matchesCategory =
                            selectedCategory == 'All' ||
                            p.category == selectedCategory;
                        return matchesSearch && matchesCategory;
                      }).toList();

                      // Product grid
                      Widget grid = GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.62,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final p = filtered[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ApiProductDetailScreen(product: p),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            p.imageUrl,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (context, child, progress) {
                                                  if (progress == null) {
                                                    return child;
                                                  }
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stack) {
                                                  return Container(
                                                    color: Colors.grey[200],
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              p.name,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '\$${p.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        FavoriteService().toggle(p);
                                      },
                                      child:
                                          ValueListenableBuilder<List<Product>>(
                                            valueListenable:
                                                FavoriteService().favorites,
                                            builder: (context, favs, _) {
                                              final isFav = favs.any(
                                                (e) => e.id == p.id,
                                              );
                                              return Icon(
                                                isFav
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isFav
                                                    ? const Color(0xFFE74C3C)
                                                    : const Color(0xFFB0B0B0),
                                              );
                                            },
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // banner removed
                          chips,
                          const SizedBox(height: 24),
                          const Text(
                            'Popular',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          const SizedBox(height: 12),
                          grid,
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 20),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
