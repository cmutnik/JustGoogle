import '../entities/search_item.dart';
import '../../data/models/search_request.dart';

/// Abstract repository interface for search operations
///
/// This defines the contract that any search data source must implement.
/// It follows the Repository pattern from Clean Architecture.
abstract class SearchRepository {
  /// Search the web with the given parameters
  ///
  /// Returns a [SearchItemList] on success or throws an exception on failure.
  ///
  /// Throws:
  /// - [NetworkException] when there's a network error
  /// - [ApiException] when the API returns an error
  /// - [RateLimitException] when API rate limit is exceeded
  Future<SearchItemList> search(SearchRequest request);

  /// Get search suggestions based on query
  ///
  /// This can be used for autocomplete functionality.
  /// Returns a list of suggestion strings.
  Future<List<String>> getSuggestions(String query);
}

/// Exception thrown when there's a network error
class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when the API returns an error
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Exception thrown when rate limit is exceeded
class RateLimitException implements Exception {
  final String message;

  RateLimitException(this.message);

  @override
  String toString() => 'RateLimitException: $message';
}

/// Exception thrown when the query is invalid
class InvalidQueryException implements Exception {
  final String message;

  InvalidQueryException(this.message);

  @override
  String toString() => 'InvalidQueryException: $message';
}
