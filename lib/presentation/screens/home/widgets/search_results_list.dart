import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/search_provider.dart';
import 'search_result_card.dart';
import '../../../widgets/common/loading_indicator.dart';

/// Widget to display a list of search results with infinite scroll
class SearchResultsList extends StatefulWidget {
  const SearchResultsList({super.key});

  @override
  State<SearchResultsList> createState() => _SearchResultsListState();
}

class _SearchResultsListState extends State<SearchResultsList> {
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

        return ListView.separated(
          controller: _scrollController,
          itemCount: items.length + (provider.hasMore ? 1 : 0) + 1, // +1 for header
          separatorBuilder: (context, index) {
            if (index == 0) return const SizedBox.shrink();
            return const Divider(height: 1);
          },
          itemBuilder: (context, index) {
            // Header with search info
            if (index == 0) {
              return _buildSearchInfoHeader(context, provider);
            }

            // Adjust index for actual items
            final itemIndex = index - 1;

            // Loading indicator for pagination
            if (itemIndex >= items.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: InlineLoadingIndicator(),
                ),
              );
            }

            // Search result item
            return SearchResultCard(item: items[itemIndex]);
          },
        );
      },
    );
  }

  Widget _buildSearchInfoHeader(BuildContext context, SearchProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'About ${provider.totalResults} results (${provider.searchTime.toStringAsFixed(2)} seconds)',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
