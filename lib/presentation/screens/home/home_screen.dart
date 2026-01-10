import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/search_types.dart';
import '../../providers/search_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_results_display.dart';

/// Main home screen with search functionality
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.appName),
          bottom: TabBar(
            onTap: (index) {
              final searchType = index == 0 ? SearchType.web : SearchType.image;
              context.read<SearchProvider>().switchSearchType(searchType);
            },
            tabs: const [
              Tab(text: 'Web'),
              Tab(text: 'Images'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Search bar
            const SearchBarWidget(),

            // Content area (results, loading, error, or initial state)
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  return _buildContent(context, provider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SearchProvider provider) {
    switch (provider.state) {
      case SearchState.initial:
        return _buildInitialState(context, provider);

      case SearchState.loading:
        // Show loading only if no results yet (first load)
        if (provider.items.isEmpty) {
          return const LoadingIndicator(message: 'Searching...');
        }
        // Otherwise show results with loading indicator at bottom
        return const SearchResultsDisplay();

      case SearchState.success:
        return const SearchResultsDisplay();

      case SearchState.empty:
        return EmptySearchResults(
          query: provider.query,
          onClear: provider.clear,
        );

      case SearchState.error:
        return ErrorDisplay(
          message: provider.errorMessage ?? 'An error occurred',
          onRetry: provider.retry,
        );
    }
  }

  Widget _buildInitialState(BuildContext context, SearchProvider provider) {
    // Update icon and text based on current search type
    final icon = provider.searchType == SearchType.web
        ? Icons.search
        : Icons.image_search;

    final text = provider.searchType == SearchType.web
        ? 'Search the web'
        : 'Search for images';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Text(
              AppConstants.appTagline,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
