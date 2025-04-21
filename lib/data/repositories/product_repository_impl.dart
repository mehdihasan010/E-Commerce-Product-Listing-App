import 'package:ecommerce_product_listing_app/data/datasources/remote/product_remote_datasource.dart';
import 'package:ecommerce_product_listing_app/data/models/product_model.dart';
import 'package:ecommerce_product_listing_app/domain/entities/product_entity.dart';
import 'package:ecommerce_product_listing_app/domain/repositories/product_repository.dart';
import 'package:hive/hive.dart';
import '../models/product_hive_model.dart';

class ProductRepositoryImpl extends ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final Box<ProductHiveModel> _box = Hive.box<ProductHiveModel>('products');

  ProductRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ProductEntity>> fetchProducts() async {
    try {
      final remoteProducts = await _remoteDataSource.fetchProducts();

      // cache to Hive
      await _box.clear();
      for (var product in remoteProducts) {
        _box.add(ProductHiveModel.fromJson(product.toJson()));
      }

      return remoteProducts;
    } catch (_) {
      // fallback from cache
      if (_box.isNotEmpty) {
        return _box.values
            .map((e) => ProductModel.fromJson(e.toJson()))
            .toList();
      } else {
        rethrow;
      }
    }
  }
}
