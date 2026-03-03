import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/theme.dart';
import 'widgets/shop_app.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> _loggedInFuture;

  @override
  void initState() {
    super.initState();
    _loggedInFuture = _checkLoggedIn();
  }

  Future<bool> _checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loggedInFuture,
      builder: (context, snapshot) {
        Widget home;
        if (snapshot.connectionState == ConnectionState.waiting) {
          home = const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          home = Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          final loggedIn = snapshot.data ?? false;
          home = loggedIn ? const ShoeShopApp() : const LoginScreen();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shoe Shop',
          theme: AppTheme.lightTheme,
          home: home,
        );
      },
    );
  }
}
