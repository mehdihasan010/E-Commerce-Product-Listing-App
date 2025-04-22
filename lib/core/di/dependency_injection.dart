import 'package:ecommerce_product_listing_app/core/services/connectivity_service.dart';
import 'package:ecommerce_product_listing_app/core/services/image_cache_service.dart';
import 'package:ecommerce_product_listing_app/core/services/network_service.dart';
import 'package:ecommerce_product_listing_app/data/datasources/remote/product_remote_datasource.dart';
import 'package:ecommerce_product_listing_app/data/models/product_hive_model.dart';
import 'package:ecommerce_product_listing_app/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_product_listing_app/domain/repositories/product_repository.dart';
import 'package:ecommerce_product_listing_app/domain/usecases/fetch_products_usecase.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DependencyInjection {
  // Singleton instance
  static final DependencyInjection _instance = DependencyInjection._internal();

  // Factory constructor
  factory DependencyInjection() => _instance;

  // Private constructor
  DependencyInjection._internal();

  // Services
  late final NetworkService networkService;
  late final ConnectivityService connectivityService;
  late final ImageCacheService imageCacheService;

  // Data sources
  late final ProductRemoteDataSource remoteDataSource;

  // Repositories
  late final ProductRepository repository;

  // Use cases
  late final FetchProductsUseCase fetchProductsUseCase;

  // Initialize all dependencies
  Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(ProductHiveModelAdapter());
    await Hive.openBox<ProductHiveModel>('products');

    // Initialize services
    networkService = NetworkService();
    connectivityService = ConnectivityService();
    imageCacheService = ImageCacheService();

    // Initialize data sources
    remoteDataSource = ProductRemoteDataSourceImpl(networkService);

    // Initialize repositories
    repository = ProductRepositoryImpl(
      remoteDataSource,
      Hive.box<ProductHiveModel>('products'),
    );

    // Initialize use cases
    fetchProductsUseCase = FetchProductsUseCase(repository);
  }

  // Clean up resources
  Future<void> dispose() async {
    await Hive.close();
  }
}

// Global instance for easy access
final di = DependencyInjection();
