import 'search_result.dart';

/// Model for the complete search response from Google Custom Search API
class SearchResponse {
  final String? kind;
  final List<SearchResult> items;
  final SearchInformation? searchInformation;
  final Queries? queries;

  const SearchResponse({
    this.kind,
    required this.items,
    this.searchInformation,
    this.queries,
  });

  /// Create SearchResponse from JSON
  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List?;
    final items = itemsList?.map((item) {
      return SearchResult.fromJson(item as Map<String, dynamic>);
    }).toList() ?? [];

    return SearchResponse(
      kind: json['kind'] as String?,
      items: items,
      searchInformation: json['searchInformation'] != null
          ? SearchInformation.fromJson(
              json['searchInformation'] as Map<String, dynamic>,
            )
          : null,
      queries: json['queries'] != null
          ? Queries.fromJson(json['queries'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert SearchResponse to JSON
  Map<String, dynamic> toJson() {
    return {
      if (kind != null) 'kind': kind,
      'items': items.map((item) => item.toJson()).toList(),
      if (searchInformation != null)
        'searchInformation': searchInformation!.toJson(),
      if (queries != null) 'queries': queries!.toJson(),
    };
  }

  /// Check if there are more results available
  bool get hasNextPage {
    return queries?.nextPage != null && queries!.nextPage!.isNotEmpty;
  }

  /// Get the start index for the next page
  int? get nextPageStartIndex {
    if (!hasNextPage) return null;
    return queries!.nextPage!.first.startIndex;
  }

  @override
  String toString() {
    return 'SearchResponse(items: ${items.length}, hasNextPage: $hasNextPage)';
  }
}

/// Model for search information metadata
class SearchInformation {
  final double searchTime;
  final String formattedSearchTime;
  final String totalResults;
  final String formattedTotalResults;

  const SearchInformation({
    required this.searchTime,
    required this.formattedSearchTime,
    required this.totalResults,
    required this.formattedTotalResults,
  });

  factory SearchInformation.fromJson(Map<String, dynamic> json) {
    return SearchInformation(
      searchTime: (json['searchTime'] as num?)?.toDouble() ?? 0.0,
      formattedSearchTime: json['formattedSearchTime'] as String? ?? '0',
      totalResults: json['totalResults'] as String? ?? '0',
      formattedTotalResults: json['formattedTotalResults'] as String? ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'searchTime': searchTime,
      'formattedSearchTime': formattedSearchTime,
      'totalResults': totalResults,
      'formattedTotalResults': formattedTotalResults,
    };
  }

  /// Get total results as integer
  int get totalResultsInt {
    return int.tryParse(totalResults) ?? 0;
  }
}

/// Model for query information (current, next, previous pages)
class Queries {
  final List<QueryInfo>? request;
  final List<QueryInfo>? nextPage;
  final List<QueryInfo>? previousPage;

  const Queries({
    this.request,
    this.nextPage,
    this.previousPage,
  });

  factory Queries.fromJson(Map<String, dynamic> json) {
    return Queries(
      request: (json['request'] as List?)
          ?.map((q) => QueryInfo.fromJson(q as Map<String, dynamic>))
          .toList(),
      nextPage: (json['nextPage'] as List?)
          ?.map((q) => QueryInfo.fromJson(q as Map<String, dynamic>))
          .toList(),
      previousPage: (json['previousPage'] as List?)
          ?.map((q) => QueryInfo.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (request != null)
        'request': request!.map((q) => q.toJson()).toList(),
      if (nextPage != null)
        'nextPage': nextPage!.map((q) => q.toJson()).toList(),
      if (previousPage != null)
        'previousPage': previousPage!.map((q) => q.toJson()).toList(),
    };
  }
}

/// Model for individual query information
class QueryInfo {
  final String title;
  final String searchTerms;
  final int count;
  final int startIndex;
  final String inputEncoding;
  final String outputEncoding;

  const QueryInfo({
    required this.title,
    required this.searchTerms,
    required this.count,
    required this.startIndex,
    required this.inputEncoding,
    required this.outputEncoding,
  });

  factory QueryInfo.fromJson(Map<String, dynamic> json) {
    return QueryInfo(
      title: json['title'] as String? ?? '',
      searchTerms: json['searchTerms'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      startIndex: json['startIndex'] as int? ?? 1,
      inputEncoding: json['inputEncoding'] as String? ?? 'utf8',
      outputEncoding: json['outputEncoding'] as String? ?? 'utf8',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'searchTerms': searchTerms,
      'count': count,
      'startIndex': startIndex,
      'inputEncoding': inputEncoding,
      'outputEncoding': outputEncoding,
    };
  }
}
