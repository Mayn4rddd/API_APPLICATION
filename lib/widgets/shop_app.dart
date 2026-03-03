import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../models/product.dart';
import '../services/favorite_service.dart';
import '../widgets/product_card.dart';
import '../screens/cart_screen.dart';
import '../screens/api_product_detail_screen.dart';
import '../utils/theme.dart';

class ShoeShopApp extends StatefulWidget {
  const ShoeShopApp({super.key});

  @override
  State<ShoeShopApp> createState() => _ShoeShopAppState();
}

class _ShoeShopAppState extends State<ShoeShopApp> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    _FavoritesScreen(),
    _CartScreen(),
    _ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF8FB3C7),
          unselectedItemColor: const Color(0xFFB0B0B0),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, size: 24),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: 24),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens for Favorites, Cart, and Profile
class _FavoritesScreen extends StatefulWidget {
  @override
  State<_FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<_FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.softPastelGradient),
      child: ValueListenableBuilder<List<Product>>(
        valueListenable: FavoriteService().favorites,
        builder: (context, favs, _) {
          if (favs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Color(0xFF8FB3C7),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.58,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: favs.length,
              itemBuilder: (context, index) {
                final p = favs[index];
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
                    });
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CartScreen();
  }
}

class _ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.softPastelGradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_rounded,
              size: 80,
              color: const Color(0xFF8FB3C7).withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your account settings',
              style: TextStyle(fontSize: 14, color: Color(0xFF888888)),
            ),
          ],
        ),
      ),
    );
  }
}
