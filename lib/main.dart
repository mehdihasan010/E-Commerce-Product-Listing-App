// main.dart
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/datasources/remote/product_remote_datasource.dart';
import 'data/models/product_hive_model.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/usecases/fetch_products_usecase.dart';
import 'presentation/screens/home_screen.dart';
import 'core/services/network_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProductHiveModelAdapter());
  await Hive.openBox<ProductHiveModel>('products');

  final networkService = NetworkService();
  final remoteDataSource = ProductRemoteDataSourceImpl(networkService);
  final repository = ProductRepositoryImpl(remoteDataSource, Hive.box<ProductHiveModel>('products'));
  final useCase = FetchProductsUseCase(repository);

  runApp(MyApp(useCase: useCase));
}

class MyApp extends StatelessWidget {
  final FetchProductsUseCase useCase;

  const MyApp({super.key, required this.useCase});

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
      home: BlocProvider(
        create: (_) => ProductBloc(useCase)..add(LoadInitialProducts()),
        child: const HomeScreen(),
      ),
    );
  }
}
