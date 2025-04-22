import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_bloc.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_event.dart';
import 'package:ecommerce_product_listing_app/presentation/blocs/product/product_state.dart';
import 'package:ecommerce_product_listing_app/presentation/widgets/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SortOption { none, priceLowToHigh, rating }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  String query = '';
  SortOption currentSort = SortOption.none;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      context.read<ProductBloc>().add(LoadMoreProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            var filtered =
                state.products
                    .where((p) => p.title.toLowerCase().contains(query))
                    .toList();

            // Apply sorting
            switch (currentSort) {
              case SortOption.priceLowToHigh:
                filtered.sort((a, b) => a.price.compareTo(b.price));
                break;
              case SortOption.rating:
                filtered.sort((a, b) => b.rating.compareTo(a.rating));
                break;
              case SortOption.none:
                break;
            }

            return CustomScrollView(
              controller: _scrollController,
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
                              flex: 80, // 80% of the available width
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    query = val.toLowerCase();
                                  });
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
                                alignment: AlignmentDirectional.center,
                                icon: Icon(
                                  Icons.sort,
                                  color: Colors.grey.shade600,
                                ),
                                // isExpanded: true,
                                underline:
                                    const SizedBox(), // This removes the underline
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
                                    setState(() => currentSort = value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        query.isNotEmpty
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
