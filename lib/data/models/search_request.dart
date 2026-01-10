/// Model for search request parameters
class SearchRequest {
  final String query;
  final int startIndex;
  final int numResults;
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
    return 'SearchRequest(query: $query, startIndex: $startIndex, numResults: $numResults)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchRequest &&
        other.query == query &&
        other.startIndex == startIndex &&
        other.numResults == numResults &&
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
