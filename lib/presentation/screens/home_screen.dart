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
import 'package:ecommerce_product_listing_app/presentation/widgets/no_data_widget.dart';
import 'package:ecommerce_product_listing_app/presentation/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SortOption { none, priceLowToHigh, priceHighToLow, rating }

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
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, connectivityState) {
        return BlocBuilder<ProductBloc, ProductState>(
          builder: (context, productState) {
            // Check if we have no products and no internet - first launch scenario
            if (productState.products.isEmpty &&
                !productState.isLoading &&
                !connectivityState.isConnected) {
              return NoDataWidget(
                isConnected: false,
                onRetry: () => context.read<ProductBloc>().add(LoadProducts()),
              );
            }

            var filtered =
                productState.products
                    .where(
                      (p) => p.title.toLowerCase().contains(
                        productState.searchQuery,
                      ),
                    )
                    .toList();

            // Apply sorting
            switch (productState.sortOption) {
              case SortOption.priceLowToHigh:
                filtered.sort((a, b) => a.price.compareTo(b.price));
                break;
              case SortOption.priceHighToLow:
                filtered.sort((a, b) => b.price.compareTo(a.price));
                break;
              case SortOption.rating:
                filtered.sort((a, b) => b.rating.compareTo(a.rating));
                break;
              case SortOption.none:
                break;
            }

            // Show no data message if filtered is empty but not during initial loading
            if (filtered.isEmpty &&
                !productState.isLoading &&
                productState.products.isNotEmpty) {
              return Column(
                children: [
                  _buildSearchBar(context, productState),
                  Expanded(
                    child: NoDataWidget(
                      isConnected: true,
                      onRetry:
                          () => context.read<ProductBloc>().add(LoadProducts()),
                    ),
                  ),
                ],
              );
            }

            return BlocBuilder<ScrollBloc, ScrollState>(
              builder: (context, scrollState) {
                return CustomScrollView(
                  controller: scrollState.scrollController,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverToBoxAdapter(
                        child: _buildSearchBar(context, productState),
                      ),
                    ),
                    if (productState.error != null)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '${productState.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    if (productState.isLoading && productState.products.isEmpty)
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
                    if (productState.isLoadingMore)
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
      },
    );
  }

  Widget _buildSearchBar(BuildContext context, ProductState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 80,
              child: TextField(
                onTap: () {
                  if (!state.isSearchActive) {
                    context.read<ProductBloc>().add(
                      UpdateSearchActiveStatus(true),
                    );
                  }
                },
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
                  suffixIcon:
                      state.isSearchActive && state.searchQuery.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              context.read<ProductBloc>().add(
                                UpdateSearchQuery(''),
                              );
                              context.read<ProductBloc>().add(
                                UpdateSearchActiveStatus(false),
                              );
                              FocusScope.of(context).unfocus();
                            },
                          )
                          : null,
                ),
              ),
            ),
            state.isSearchActive
                ? Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: Icon(Icons.sort, color: Colors.grey.shade600),
                    onPressed: () {
                      final productBloc = context.read<ProductBloc>();
                      _showSortBottomSheet(
                        context,
                        state.sortOption,
                        productBloc,
                      );
                    },
                  ),
                )
                : const SizedBox(),
          ],
        ),
        const SizedBox(height: 10),
        state.searchQuery.isNotEmpty
            ? Center(
              child: Text(
                '${state.products.where((p) => p.title.toLowerCase().contains(state.searchQuery)).length} Items',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
            : const SizedBox(),
      ],
    );
  }

  void _showSortBottomSheet(
    BuildContext context,
    SortOption currentOption,
    ProductBloc productBloc,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(bottomSheetContext),
                  ),
                ],
              ),
              const Divider(),
              ListTile(
                title: const Text('Price - High to Low'),
                trailing: Radio<SortOption>(
                  value: SortOption.priceHighToLow,
                  groupValue: currentOption,
                  onChanged: (SortOption? value) {
                    if (value != null) {
                      productBloc.add(UpdateSortOption(value));
                      Navigator.pop(bottomSheetContext);
                    }
                  },
                ),
                onTap: () {
                  productBloc.add(UpdateSortOption(SortOption.priceHighToLow));
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                title: const Text('Price - Low to High'),
                trailing: Radio<SortOption>(
                  value: SortOption.priceLowToHigh,
                  groupValue: currentOption,
                  onChanged: (SortOption? value) {
                    if (value != null) {
                      productBloc.add(UpdateSortOption(value));
                      Navigator.pop(bottomSheetContext);
                    }
                  },
                ),
                onTap: () {
                  productBloc.add(UpdateSortOption(SortOption.priceLowToHigh));
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                title: const Text('Rating'),
                trailing: Radio<SortOption>(
                  value: SortOption.rating,
                  groupValue: currentOption,
                  onChanged: (SortOption? value) {
                    if (value != null) {
                      productBloc.add(UpdateSortOption(value));
                      Navigator.pop(bottomSheetContext);
                    }
                  },
                ),
                onTap: () {
                  productBloc.add(UpdateSortOption(SortOption.rating));
                  Navigator.pop(bottomSheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
