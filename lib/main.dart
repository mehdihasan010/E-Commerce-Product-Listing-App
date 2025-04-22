// main.dart
import 'package:ecommerce_product_listing_app/core/di/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize all dependencies
  await di.init();

  runApp(const MyApp());
}
