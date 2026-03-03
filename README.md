# API Application

A Flutter e-commerce mobile app demonstrating REST API integration, user authentication, and shopping cart functionality.

## Group Members
- Maynard Sabijon  
- Jolie Angela Rico  
- James Bryan Pilare  
- Rj Vallespin  

## Project Overview
This is a mobile shopping application built with Flutter that integrates with the FakeStore API. It demonstrates core mobile development concepts including REST API calls, user authentication, local data persistence, and state management.

## Features
- **User Login** - Authentication with token-based session management
- **Product Browsing** - Fetch and display products from REST API
- **Product Details** - View complete product information with ratings
- **Shopping Cart** - Add/remove items and manage quantities
- **Favorites** - Save and manage favorite products
- **Dashboard** - Intuitive home screen with navigation

## Technology Stack
| Component | Technology |
|-----------|-----------|
| Framework | Flutter |
| Language | Dart 3.10.7 |
| HTTP Client | http ^0.13.6 |
| Storage | shared_preferences ^2.0.15 |
| Design | Material Design 3 |

## Project Structure
```
lib/
├── main.dart                    # App entry point & session check
├── screens/                     # UI screens (login, home, cart, details)
├── services/                    # Business logic (API, cart, favorites)
├── models/                      # Data models (Product, CartItem)
├── widgets/                     # Reusable UI components
└── utils/                       # Theming and utilities
```

## Installation & Setup

### Prerequisites
- Flutter SDK installed
- Dart 3.10.7+
- Android Studio or VS Code

### Steps
```bash
# 1. Clone the repository
git clone <repository-url>
cd api_application

# 2. Install dependencies
flutter pub get

# 3. Run the application
flutter run
```

## How It Works

1. **Login** - User enters credentials and receives authentication token
2. **Token Storage** - Token saved to SharedPreferences for session persistence
3. **Product Fetching** - App fetches product list from FakeStore API
4. **Shopping** - User can browse products, view details, add to cart/favorites
5. **Persistence** - Cart and favorites managed locally
6. **Auto-Login** - On app restart, checks for stored token and auto-logs in

## Key Components

### Screens
- **LoginScreen** - User authentication interface
- **DashboardScreen** - Home navigation hub
- **HomeScreen** - Product shopping interface
- **ProductDetailScreen** - Detailed product view
- **CartScreen** - Shopping cart management

### Services
- **ApiService** - REST API calls to FakeStore (https://fakestoreapi.com)
- **CartService** - Cart state management and operations
- **FavoriteService** - Favorite products management

### Models
- **Product** - Contains title, price, description, image, category, rating
- **CartItem** - Product with quantity and total price calculation

## API Integration

**API Used:** FakeStore API (https://fakestoreapi.com)

**Endpoints:**
- `GET /products` - Fetch all products
- `GET /products/{id}` - Fetch single product details
- `GET /products/category/{category}` - Fetch products by category

## Building for Release

```bash
# Build Android APK
flutter build apk --release

# Build iOS app
flutter build ios --release

# Build Web version
flutter build web --release
```

## Demo

### Preview (GIF)
![Project Demo](assets/screen_record.gif)

### Full Video
[Watch full demo](assets/screen_record.mp4)

## Important Notes
- SSL certificate validation is bypassed in development mode only (remove for production)
- Uses FakeStore API for testing (no real transactions)
- Session tokens stored locally; no permanent database
- Cart and favorites stored in device memory during session

## Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev)
- [FakeStore API Docs](https://fakestoreapi.com)
- [Material Design](https://material.io/design)
