import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../utils/theme.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _showDeliveryForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter name' : null,
                  ),
                  TextFormField(
                    controller: _addressCtrl,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter address' : null,
                  ),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter phone' : null,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8FB3C7),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Delivery details saved. Order placed.',
                              ),
                            ),
                          );
                          CartService().clear();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Place Order',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
        title: const Text(
          'Your Cart',
          style: TextStyle(color: Color(0xFF2C3E50)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.softPastelGradient),
        child: ValueListenableBuilder<List<CartItem>>(
          valueListenable: CartService().items,
          builder: (context, items, _) {
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Color(0xFF8FB3C7),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Your Cart is empty',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final it = items[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: Image.network(
                                it.product.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    it.product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  if (it.size.isNotEmpty || it.color.isNotEmpty)
                                    Text(
                                      '${it.size.isNotEmpty ? 'Size: ${it.size}' : ''}${it.size.isNotEmpty && it.color.isNotEmpty ? ' • ' : ''}${it.color.isNotEmpty ? 'Color: ${it.color}' : ''}',
                                    ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '\$${(it.product.price * it.quantity).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF8FB3C7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Color(0xFFB0B0B0),
                                  ),
                                  onPressed: () => CartService().removeItem(it),
                                ),
                                Text('x${it.quantity}'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${CartService().getTotal().toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8FB3C7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8FB3C7),
                          ),
                          onPressed: _showDeliveryForm,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              'Enter Delivery Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
