import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/search_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import 'image_result_card.dart';

/// Grid layout for displaying image search results
class ImageResultsGrid extends StatefulWidget {
  const ImageResultsGrid({super.key});

  @override
  State<ImageResultsGrid> createState() => _ImageResultsGridState();
}

class _ImageResultsGridState extends State<ImageResultsGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final provider = context.read<SearchProvider>();
      if (provider.hasMore && !provider.isLoading) {
        provider.loadMore();
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        final items = provider.items;

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Search info header
            SliverToBoxAdapter(
              child: _buildSearchInfoHeader(context, provider),
            ),

            // Image grid
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1, // Square tiles
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= items.length) {
                      return const Center(
                        child: InlineLoadingIndicator(),
                      );
                    }
                    return ImageResultCard(item: items[index]);
                  },
                  childCount: items.length + (provider.hasMore ? 1 : 0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchInfoHeader(BuildContext context, SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'About ${provider.totalResults} results (${provider.searchTime.toStringAsFixed(2)} seconds)',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

/// Inline loading indicator for pagination
class InlineLoadingIndicator extends StatelessWidget {
  const InlineLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
