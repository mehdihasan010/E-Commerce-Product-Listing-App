import 'package:ecommerce_product_listing_app/core/services/connectivity_service.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/connectivity/connectivity_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/connectivity/connectivity_event.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/connectivity/connectivity_state.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_event.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_state.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/scroll/scroll_event.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/scroll/scroll_state.dart';
import 'package:ecommerce_product_listing_app/presentation/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SortOption { none, priceLowToHigh, rating }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showConnectivitySnackBar(BuildContext context, bool isConnected) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isConnected
              ? 'Internet connection restored!'
              : 'No internet connection. Showing cached data.',
        ),
        backgroundColor: isConnected ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  ConnectivityBloc(context.read<ConnectivityService>())
                    ..add(InitConnectivity()),
        ),
        BlocProvider(
          create:
              (context) =>
                  ScrollBloc(productBloc: context.read<ProductBloc>())
                    ..add(InitScrollController()),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: BlocListener<ConnectivityBloc, ConnectivityState>(
            listener: (context, state) {
              if (state.shouldShowMessage) {
                _showConnectivitySnackBar(context, state.isConnected);
              }
            },
            child: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        var filtered =
            state.products
                .where((p) => p.title.toLowerCase().contains(state.searchQuery))
                .toList();

        // Apply sorting
        switch (state.sortOption) {
          case SortOption.priceLowToHigh:
            filtered.sort((a, b) => a.price.compareTo(b.price));
            break;
          case SortOption.rating:
            filtered.sort((a, b) => b.rating.compareTo(a.rating));
            break;
          case SortOption.none:
            break;
        }

        return BlocBuilder<ScrollBloc, ScrollState>(
          builder: (context, scrollState) {
            return CustomScrollView(
              controller: scrollState.scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 80,
                              child: TextField(
                                onChanged: (val) {
                                  context.read<ProductBloc>().add(
                                    UpdateSearchQuery(val.toLowerCase()),
                                  );
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search Anything...',
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 20,
                              child: DropdownButton<SortOption>(
                                value: state.sortOption,
                                alignment: AlignmentDirectional.center,
                                icon: Icon(
                                  Icons.sort,
                                  color: Colors.grey.shade600,
                                ),
                                underline: const SizedBox(),
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                ),
                                items: [
                                  DropdownMenuItem(
                                    value: SortOption.none,
                                    child: Text('Sort by'),
                                  ),
                                  DropdownMenuItem(
                                    value: SortOption.priceLowToHigh,
                                    child: const Text('Price'),
                                  ),
                                  DropdownMenuItem(
                                    value: SortOption.rating,
                                    child: const Text('Rating'),
                                  ),
                                ],
                                onChanged: (SortOption? value) {
                                  if (value != null) {
                                    context.read<ProductBloc>().add(
                                      UpdateSortOption(value),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        state.searchQuery.isNotEmpty
                            ? Center(
                              child: Text(
                                '${filtered.length} Items',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                if (state.error != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${state.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                if (state.isLoading && state.products.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            ProductTile(product: filtered[index]),
                        childCount: filtered.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                    ),
                  ),
                if (state.isLoadingMore)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
