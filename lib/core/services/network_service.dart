import 'package:dio/dio.dart';
import 'package:ecommerce_product_listing_app/data/models/product_hive_model.dart';
import 'package:ecommerce_product_listing_app/data/models/product_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

import '../utils/failure.dart';
import '../utils/result.dart';

class NetworkService {
  final Dio _dio;
  final _box = Hive.box<ProductHiveModel>('products');

  NetworkService() : _dio = Dio();

  Future<Result<Failure, List<ProductModel>>> getProducts(String url) async {
    print('network start');
    try {
      final response = await _dio.get(url);
      print(response);
      if (response.statusCode == 200 && response.data != null) {
        final List decoded = response.data;
        print(decoded);
        final List<ProductModel> products =
            decoded.map((json) => ProductModel.fromJson(json)).toList();

        print(products);

        // Cache to Hive
        await _box.clear();
        for (var json in decoded) {
          _box.add(ProductHiveModel.fromJson(json));
        }

        print(_box);

        return right(products);
      }

      return left(
        Failure(
          message: 'Server Error: ${response.statusCode}',
          statusCode: response.statusCode,
        ),
      );
    } on DioException catch (e) {
      //API failed → Try cache fallback
      if (_box.isNotEmpty) {
        final fallbackProducts =
            _box.values.map((e) => ProductModel.fromJson(e.toJson())).toList();
        return right(fallbackProducts);
      }

      return left(
        Failure(
          message: e.message ?? 'Dio error occurred',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      //Unknown error → Try cache fallback
      if (_box.isNotEmpty) {
        final fallbackProducts =
            _box.values.map((e) => ProductModel.fromJson(e.toJson())).toList();
        return right(fallbackProducts);
      }

      return left(Failure(message: e.toString()));
    }
  }
}
