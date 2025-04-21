import 'package:ecommerce_product_listing_app/core/services/network_service.dart';
import 'package:ecommerce_product_listing_app/core/utils/constants.dart';
import 'package:ecommerce_product_listing_app/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final NetworkService _networkService;

  ProductRemoteDataSourceImpl(this._networkService);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final url = '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}';

    final response = await _networkService.getProducts(url);

    // response is already a Result<Failure, List<ProductModel>>
    return response.match(
      (failure) => throw Exception(failure.message),
      (products) => products,
    );
  }
}
