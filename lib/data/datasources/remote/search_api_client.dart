import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../core/constants/api_constants.dart';

/// API client for Google Custom Search
class SearchApiClient {
  late final Dio _dio;
  late final String _apiKey;
  late final String _searchEngineId;

  SearchApiClient() {
    _apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
    _searchEngineId = dotenv.env['GOOGLE_SEARCH_ENGINE_ID'] ?? '';

    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.requestTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.requestTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors for logging and error handling
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        logPrint: (obj) {
          // In production, consider using a proper logging framework
          // For now, we'll use debugPrint which is acceptable in Flutter
          debugPrint('[API] $obj');
        },
      ),
    );
  }

  /// Search the web with the given query
  ///
  /// Parameters:
  /// - [query]: The search query string (required)
  /// - [startIndex]: The index of the first result to return (1-indexed, default: 1)
  /// - [num]: Number of results to return (1-10, default: 10)
  /// - [dateRestrict]: Restricts results based on date (e.g., 'd1' for past day, 'w1' for past week)
  /// - [siteSearch]: Restricts results to URLs from a specific site
  /// - [fileType]: Restricts results to files of a specified type
  /// - [exactTerms]: Identifies a phrase that all results must contain
  /// - [excludeTerms]: Identifies a word or phrase that should not appear in any results
  /// - [lr]: Language restrict - restricts search to documents in a particular language
  /// - [safe]: Safe search setting ('active', 'off')
  ///
  /// Returns a Map containing the API response
  /// Throws [DioException] on network or API errors
  Future<Map<String, dynamic>> search({
    required String query,
    int startIndex = 1,
    int num = ApiConstants.defaultResultsPerPage,
    String? dateRestrict,
    String? siteSearch,
    String? fileType,
    String? exactTerms,
    String? excludeTerms,
    String? lr,
    String? safe,
  }) async {
    try {
      // Validate API credentials
      if (_apiKey.isEmpty || _searchEngineId.isEmpty) {
        throw Exception(
          'API credentials not configured. Please add GOOGLE_API_KEY and GOOGLE_SEARCH_ENGINE_ID to .env file.',
        );
      }

      // Validate query
      if (query.trim().isEmpty) {
        throw Exception('Search query cannot be empty');
      }

      // Validate pagination
      if (startIndex < 1) {
        throw Exception('Start index must be >= 1');
      }

      if (num < 1 || num > ApiConstants.maxResultsPerPage) {
        throw Exception(
          'Number of results must be between 1 and ${ApiConstants.maxResultsPerPage}',
        );
      }

      // Build query parameters
      final queryParameters = <String, dynamic>{
        'key': _apiKey,
        'cx': _searchEngineId,
        'q': query.trim(),
        'start': startIndex,
        'num': num,
      };

      // Add optional parameters if provided
      if (dateRestrict != null && dateRestrict.isNotEmpty) {
        queryParameters['dateRestrict'] = dateRestrict;
      }

      if (siteSearch != null && siteSearch.isNotEmpty) {
        queryParameters['siteSearch'] = siteSearch;
      }

      if (fileType != null && fileType.isNotEmpty) {
        queryParameters['fileType'] = fileType;
      }

      if (exactTerms != null && exactTerms.isNotEmpty) {
        queryParameters['exactTerms'] = exactTerms;
      }

      if (excludeTerms != null && excludeTerms.isNotEmpty) {
        queryParameters['excludeTerms'] = excludeTerms;
      }

      if (lr != null && lr.isNotEmpty) {
        queryParameters['lr'] = lr;
      }

      if (safe != null && safe.isNotEmpty) {
        queryParameters['safe'] = safe;
      }

      // Make the API request
      final response = await _dio.get(
        ApiConstants.searchEndpoint,
        queryParameters: queryParameters,
      );

      // Check if response is successful
      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Unexpected response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle different types of errors
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Connection timeout. Please check your internet connection.');
      }

      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Network error. Please check your internet connection.');
      }

      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final errorData = e.response!.data;

        // Handle specific HTTP error codes
        switch (statusCode) {
          case 400:
            throw Exception('Invalid request: ${_extractErrorMessage(errorData)}');
          case 401:
            throw Exception('Invalid API key. Please check your credentials in .env file.');
          case 403:
            throw Exception(
              'API quota exceeded or access forbidden. You may have reached your daily limit.',
            );
          case 429:
            throw Exception('Too many requests. Please try again later.');
          case 500:
          case 502:
          case 503:
            throw Exception('Google API server error. Please try again later.');
          default:
            throw Exception(
              'API error ($statusCode): ${_extractErrorMessage(errorData)}',
            );
        }
      }

      // Rethrow the exception if we couldn't handle it
      rethrow;
    } catch (e) {
      // Handle any other errors
      throw Exception('Unexpected error: $e');
    }
  }

  /// Extract error message from API response
  String _extractErrorMessage(dynamic errorData) {
    if (errorData is Map<String, dynamic>) {
      if (errorData.containsKey('error')) {
        final error = errorData['error'];
        if (error is Map<String, dynamic>) {
          return error['message'] ?? 'Unknown error';
        }
        return error.toString();
      }
    }
    return 'Unknown error';
  }

  /// Close the Dio client
  void dispose() {
    _dio.close();
  }
}
