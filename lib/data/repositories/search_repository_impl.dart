import 'package:dio/dio.dart';
import '../../domain/entities/search_item.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/remote/search_api_client.dart';
import '../models/search_request.dart';
import '../models/search_response.dart';
import '../models/search_result.dart';

/// Implementation of SearchRepository using Google Custom Search API
class SearchRepositoryImpl implements SearchRepository {
  final SearchApiClient _apiClient;

  SearchRepositoryImpl(this._apiClient);

  @override
  Future<SearchItemList> search(SearchRequest request) async {
    try {
      // Call the API
      final response = await _apiClient.search(
        query: request.query,
        startIndex: request.startIndex,
        num: request.numResults,
        dateRestrict: request.dateRestrict,
        siteSearch: request.siteSearch,
        fileType: request.fileType,
        exactTerms: request.exactTerms,
        excludeTerms: request.excludeTerms,
        lr: request.language,
        safe: request.safeSearch,
      );

      // Parse the response
      final searchResponse = SearchResponse.fromJson(response);

      // Convert data models to domain entities
      final items = searchResponse.items
          .map((result) => _mapSearchResultToItem(result))
          .toList();

      return SearchItemList(
        items: items,
        totalResults: searchResponse.searchInformation?.totalResultsInt ?? 0,
        searchTime: searchResponse.searchInformation?.searchTime ?? 0.0,
        query: request.query,
        hasMore: searchResponse.hasNextPage,
        nextStartIndex: searchResponse.nextPageStartIndex,
      );
    } on DioException catch (e) {
      // Handle Dio exceptions
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          'Network error. Please check your internet connection.',
        );
      }

      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final message = e.response!.data?.toString() ?? e.message ?? 'Unknown error';

        if (statusCode == 429 || statusCode == 403) {
          throw RateLimitException(
            'API rate limit exceeded. Please try again later.',
          );
        }

        throw ApiException(message, statusCode);
      }

      throw NetworkException(e.message ?? 'Network error occurred');
    } on Exception catch (e) {
      // Handle other exceptions
      final message = e.toString();

      if (message.contains('API credentials not configured')) {
        throw ApiException(
          'API credentials not configured. Please add your Google API key and Search Engine ID to the .env file.',
        );
      }

      if (message.contains('Search query cannot be empty')) {
        throw InvalidQueryException('Search query cannot be empty');
      }

      if (message.contains('quota exceeded') ||
          message.contains('rate limit') ||
          message.contains('API quota')) {
        throw RateLimitException(
          'Daily search limit reached. Please try again tomorrow.',
        );
      }

      throw ApiException(message);
    }
  }

  @override
  Future<List<String>> getSuggestions(String query) async {
    // For now, return an empty list
    // In the future, this could integrate with Google Autocomplete API
    // or return suggestions from local search history
    return [];
  }

  /// Convert SearchResult (data model) to SearchItem (domain entity)
  SearchItem _mapSearchResultToItem(SearchResult result) {
    return SearchItem(
      title: result.title,
      url: result.link,
      snippet: result.snippet,
      domain: result.domain,
      displayUrl: result.formattedUrl ?? result.displayLink,
      faviconUrl: result.faviconUrl,
    );
  }
}
