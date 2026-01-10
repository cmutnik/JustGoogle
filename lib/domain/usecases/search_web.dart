import '../entities/search_item.dart';
import '../repositories/search_repository.dart';
import '../../data/models/search_request.dart';

/// Use case for searching the web
///
/// This encapsulates the business logic for executing a search.
/// It follows the Use Case pattern from Clean Architecture.
class SearchWeb {
  final SearchRepository _repository;

  SearchWeb(this._repository);

  /// Execute a search with the given parameters
  ///
  /// Returns a [SearchItemList] containing the search results.
  ///
  /// Throws various exceptions on failure:
  /// - [NetworkException] for network errors
  /// - [ApiException] for API errors
  /// - [RateLimitException] for rate limit errors
  /// - [InvalidQueryException] for invalid queries
  Future<SearchItemList> execute(SearchRequest request) async {
    // Validate the query
    if (request.query.trim().isEmpty) {
      throw InvalidQueryException('Search query cannot be empty');
    }

    // Delegate to the repository
    return await _repository.search(request);
  }

  /// Execute a simple search with just a query string
  ///
  /// This is a convenience method for basic searches.
  Future<SearchItemList> executeSimple(String query, {int page = 1}) async {
    final startIndex = ((page - 1) * 10) + 1;
    final request = SearchRequest(
      query: query,
      startIndex: startIndex,
      numResults: 10,
    );
    return await execute(request);
  }
}
