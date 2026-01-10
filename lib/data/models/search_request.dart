import '../../core/constants/search_types.dart';

/// Model for search request parameters
class SearchRequest {
  final String query;
  final int startIndex;
  final int numResults;
  final SearchType searchType;
  final String? dateRestrict;
  final String? siteSearch;
  final String? fileType;
  final String? exactTerms;
  final String? excludeTerms;
  final String? language;
  final String? safeSearch;

  const SearchRequest({
    required this.query,
    this.startIndex = 1,
    this.numResults = 10,
    this.searchType = SearchType.web,
    this.dateRestrict,
    this.siteSearch,
    this.fileType,
    this.exactTerms,
    this.excludeTerms,
    this.language,
    this.safeSearch,
  });

  /// Create a copy with updated fields
  SearchRequest copyWith({
    String? query,
    int? startIndex,
    int? numResults,
    SearchType? searchType,
    String? dateRestrict,
    String? siteSearch,
    String? fileType,
    String? exactTerms,
    String? excludeTerms,
    String? language,
    String? safeSearch,
  }) {
    return SearchRequest(
      query: query ?? this.query,
      startIndex: startIndex ?? this.startIndex,
      numResults: numResults ?? this.numResults,
      searchType: searchType ?? this.searchType,
      dateRestrict: dateRestrict ?? this.dateRestrict,
      siteSearch: siteSearch ?? this.siteSearch,
      fileType: fileType ?? this.fileType,
      exactTerms: exactTerms ?? this.exactTerms,
      excludeTerms: excludeTerms ?? this.excludeTerms,
      language: language ?? this.language,
      safeSearch: safeSearch ?? this.safeSearch,
    );
  }

  @override
  String toString() {
    return 'SearchRequest(query: $query, startIndex: $startIndex, numResults: $numResults, searchType: $searchType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchRequest &&
        other.query == query &&
        other.startIndex == startIndex &&
        other.numResults == numResults &&
        other.searchType == searchType &&
        other.dateRestrict == dateRestrict &&
        other.siteSearch == siteSearch &&
        other.fileType == fileType &&
        other.exactTerms == exactTerms &&
        other.excludeTerms == excludeTerms &&
        other.language == language &&
        other.safeSearch == safeSearch;
  }

  @override
  int get hashCode {
    return Object.hash(
      query,
      startIndex,
      numResults,
      searchType,
      dateRestrict,
      siteSearch,
      fileType,
      exactTerms,
      excludeTerms,
      language,
      safeSearch,
    );
  }
}
