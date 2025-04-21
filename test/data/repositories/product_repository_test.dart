import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce_product_listing_app/data/datasources/remote/product_remote_datasource.dart';
import 'package:ecommerce_product_listing_app/data/repositories/product_repository_impl.dart';
import 'package:ecommerce_product_listing_app/data/models/product_model.dart';
import 'package:ecommerce_product_listing_app/data/models/product_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:io';
import 'product_repository_test.mocks.dart';

@GenerateMocks([ProductRemoteDataSource])
void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late Box<ProductHiveModel> box;
  late Directory tempDir;

  setUpAll(() {
    // Register adapter only once for all tests
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ProductHiveModelAdapter());
    }
  });

  setUp(() async {
    mockRemoteDataSource = MockProductRemoteDataSource();

    // Create a temporary directory and initialize Hive
    tempDir = await Directory.systemTemp.createTemp('hive_test');
    Hive.init(tempDir.path);

    // Open a new test box for each test
    box = await Hive.openBox<ProductHiveModel>('products_test');

    // Initialize repository with the test box
    repository = ProductRepositoryImpl(mockRemoteDataSource, box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
    await Hive.deleteBoxFromDisk('products_test');
    tempDir.deleteSync(recursive: true);
  });

  group('fetchProducts', () {
    final testProducts = [
      ProductModel(
        id: 1,
        title: 'Test Product',
        description: 'Test Description',
        image: 'https://example.com/image.jpg',
        price: 99.99,
        rating: 4.5,
        ratingCount: 100,
      ),
    ];

    test(
      'should return remote data when the remote call is successful',
      () async {
        // arrange
        when(
          mockRemoteDataSource.fetchProducts(),
        ).thenAnswer((_) async => testProducts);

        // act
        final result = await repository.fetchProducts();

        // assert
        expect(result, equals(testProducts));
        verify(mockRemoteDataSource.fetchProducts()).called(1);
        verifyNoMoreInteractions(mockRemoteDataSource);
      },
    );

    test('should return cached data when the remote call fails', () async {
      // arrange
      when(
        mockRemoteDataSource.fetchProducts(),
      ).thenThrow(Exception('Failed to fetch'));

      final cachedProduct = ProductHiveModel(
        id: 1,
        title: 'Cached Product',
        description: 'Cached Description',
        image: 'https://example.com/cached.jpg',
        price: 99.99,
        rating: 4.5,
        ratingCount: 100,
      );

      await box.add(cachedProduct);

      // act
      final result = await repository.fetchProducts();

      // assert
      expect(result.length, equals(1));
      expect(result.first.title, equals('Cached Product'));
      verify(mockRemoteDataSource.fetchProducts()).called(1);
    });

    test(
      'should throw exception when remote fails and cache is empty',
      () async {
        // arrange
        when(
          mockRemoteDataSource.fetchProducts(),
        ).thenThrow(Exception('Failed to fetch'));

        // act & assert
        expect(() => repository.fetchProducts(), throwsA(isA<Exception>()));
        verify(mockRemoteDataSource.fetchProducts()).called(1);
      },
    );
  });
}
