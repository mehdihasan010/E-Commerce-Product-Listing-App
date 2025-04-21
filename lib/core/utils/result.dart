import 'package:fpdart/fpdart.dart';

typedef Result<L, R> = Either<L, R>;

// Extension to make it easier to create failure cases with a message
extension ResultExtension<R> on Either<String, R> {
  static Either<String, R> failure<R>(String message, [dynamic error]) {
    return left(message);
  }
}
