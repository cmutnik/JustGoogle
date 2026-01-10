/// API Constants for Google Custom Search API
class ApiConstants {
  ApiConstants._();

  /// Base URL for Google Custom Search API
  static const String baseUrl = 'https://www.googleapis.com/customsearch/v1';

  /// API endpoint for search
  static const String searchEndpoint = '/';

  /// Default number of results per page
  static const int defaultResultsPerPage = 10;

  /// Maximum results per page allowed by API
  static const int maxResultsPerPage = 10;

  /// Request timeout in milliseconds
  static const int requestTimeout = 30000;

  /// Cache duration in minutes
  static const int cacheDurationMinutes = 5;

  /// Rate limit - requests per day (free tier)
  static const int rateLimitPerDay = 100;

  /// Debounce duration for search input in milliseconds
  static const int searchDebounceDuration = 300;
}
