import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ecommerce_product_listing_app/presentation/widgets/product_tile.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_state.dart';
import 'package:ecommerce_product_listing_app/domain/entities/product_entity.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([ProductBloc])
void main() {
  late MockProductBloc mockBloc;

  setUp(() {
    mockBloc = MockProductBloc();

    // Setup default state
    when(
      mockBloc.state,
    ).thenReturn(ProductState(products: [], isLoading: false, error: null));

    // Handle image loading in tests
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('ProductTile toggles favorite when heart icon is tapped', (
    WidgetTester tester,
  ) async {
    final testProduct = ProductEntity(
      id: 1,
      title: 'Test Product',
      description: 'Test Description',
      image: 'https://example.com/image.jpg',
      price: 99.99,
      rating: 4.5,
      ratingCount: 100,
      isFavorite: false,
    );

    // Provide a fake network image
    final imageProvider = NetworkImage(testProduct.image);
    imageProvider.resolve(ImageConfiguration.empty);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: Scaffold(body: ProductTile(product: testProduct)),
        ),
      ),
    );

    // Verify initial favorite state
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    final initialIcon = tester.widget<Icon>(find.byIcon(Icons.favorite));
    expect(initialIcon.color, equals(Colors.grey.shade300));

    // Tap the favorite icon
    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();

    // Verify that ToggleFavorite event was added to the bloc
    verify(mockBloc.add(any)).called(1);
  });
}
