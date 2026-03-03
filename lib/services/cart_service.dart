import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class CartService {
  CartService._privateConstructor();
  static final CartService _instance = CartService._privateConstructor();
  factory CartService() => _instance;

  final ValueNotifier<List<CartItem>> items = ValueNotifier<List<CartItem>>([]);

  void addItem(CartItem item) {
    final idx = items.value.indexWhere(
      (i) =>
          i.product.id == item.product.id &&
          i.size == item.size &&
          i.color == item.color,
    );
    if (idx >= 0) {
      // replace the item with a new instance to trigger ValueNotifier listeners
      final newList = List<CartItem>.from(items.value);
      final existing = newList[idx];
      newList[idx] = CartItem(
        product: existing.product,
        size: existing.size,
        color: existing.color,
        quantity: existing.quantity + item.quantity,
      );
      items.value = newList;
    } else {
      items.value = [...items.value, item];
    }
  }

  void removeItem(CartItem item) {
    items.value = items.value.where((i) => i != item).toList();
  }

  double getTotal() {
    return items.value.fold(
      0.0,
      (sum, it) => sum + it.product.price * it.quantity,
    );
  }

  void clear() {
    items.value = [];
  }
}
