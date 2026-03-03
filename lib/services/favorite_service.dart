import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoriteService {
  FavoriteService._privateConstructor();
  static final FavoriteService _instance =
      FavoriteService._privateConstructor();
  factory FavoriteService() => _instance;

  final ValueNotifier<List<Product>> favorites = ValueNotifier<List<Product>>(
    [],
  );

  bool isFavorite(Product p) {
    return favorites.value.any((e) => e.id == p.id);
  }

  void toggle(Product p) {
    final list = List<Product>.from(favorites.value);
    final idx = list.indexWhere((e) => e.id == p.id);
    if (idx >= 0) {
      list.removeAt(idx);
      p.isFavorite = false;
    } else {
      list.add(p);
      p.isFavorite = true;
    }
    favorites.value = list;
  }
}
