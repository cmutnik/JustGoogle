import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/search_types.dart';
import '../../../providers/search_provider.dart';
import 'search_results_list.dart';
import 'image_results_grid.dart';

/// Widget that displays either web results list or image results grid
/// based on the current search type
class SearchResultsDisplay extends StatelessWidget {
  const SearchResultsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        // Choose display based on search type
        switch (provider.searchType) {
          case SearchType.web:
            return const SearchResultsList();
          case SearchType.image:
            return const ImageResultsGrid();
        }
      },
    );
  }
}
