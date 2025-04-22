import 'package:ecommerce_product_listing_app/core/di/dependency_injection.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Product Listing',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        fontFamily: 'Inter', // Setting Inter as global font
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: di.connectivityService),
          RepositoryProvider.value(value: di.imageCacheService),
        ],
        child: BlocProvider(
          create:
              (_) => ProductBloc(
                di.fetchProductsUseCase,
                imageCacheService: di.imageCacheService,
              )..add(LoadProducts()),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
