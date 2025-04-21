import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../utils/failure.dart';
import '../utils/result.dart';

class NetworkService {
  final Dio _dio;

  NetworkService() : _dio = Dio();

  Future<Result<Failure, Response>> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters);
      return right(response);
    } on DioException catch (e) {
      return left(
        Failure(
          message: e.message ?? 'Something went wrong',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
}
