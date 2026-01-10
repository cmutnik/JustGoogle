import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/search_provider.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_results_list.dart';

/// Main home screen with search functionality
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
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
    );
  }

  Widget _buildContent(BuildContext context, SearchProvider provider) {
    switch (provider.state) {
      case SearchState.initial:
        return _buildInitialState(context);

      case SearchState.loading:
        // Show loading only if no results yet (first load)
        if (provider.items.isEmpty) {
          return const LoadingIndicator(message: 'Searching...');
        }
        // Otherwise show results with loading indicator at bottom
        return const SearchResultsList();

      case SearchState.success:
        return const SearchResultsList();

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

  Widget _buildInitialState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 100,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Search the web',
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
