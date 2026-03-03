import 'dart:io';

/// An [HttpOverrides] implementation that ignores bad/expired
/// SSL certificates. This is strictly intended for use in
/// development and testing environments and must never be used
/// in production code.
class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}
