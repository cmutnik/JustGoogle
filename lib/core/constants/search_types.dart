/// Types of search supported by Google Custom Search API
enum SearchType {
  /// Web search (default)
  web,

  /// Image search
  image;

  /// Get the API value for this search type
  ///
  /// Returns the value to be used in the Google Custom Search API's
  /// searchType parameter. Web search returns empty string (no parameter needed),
  /// while image search returns 'image'.
  String get apiValue {
    switch (this) {
      case SearchType.web:
        return ''; // No searchType parameter for web search
      case SearchType.image:
        return 'image';
    }
  }

  /// Get a display name for this search type
  String get displayName {
    switch (this) {
      case SearchType.web:
        return 'Web';
      case SearchType.image:
        return 'Images';
    }
  }
}
