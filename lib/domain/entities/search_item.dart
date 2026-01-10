/// Domain entity representing a search result
///
/// This is the business logic representation of a search result,
/// independent of any data source implementation.
class SearchItem {
  final String title;
  final String url;
  final String snippet;
  final String domain;
  final String? displayUrl;
  final String? faviconUrl;

  const SearchItem({
    required this.title,
    required this.url,
    required this.snippet,
    required this.domain,
    this.displayUrl,
    this.faviconUrl,
  });

  /// Create a copy with updated fields
  SearchItem copyWith({
    String? title,
    String? url,
    String? snippet,
    String? domain,
    String? displayUrl,
    String? faviconUrl,
  }) {
    return SearchItem(
      title: title ?? this.title,
      url: url ?? this.url,
      snippet: snippet ?? this.snippet,
      domain: domain ?? this.domain,
      displayUrl: displayUrl ?? this.displayUrl,
      faviconUrl: faviconUrl ?? this.faviconUrl,
    );
  }

  @override
  String toString() {
    return 'SearchItem(title: $title, url: $url, domain: $domain)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchItem &&
        other.title == title &&
        other.url == url &&
        other.snippet == snippet &&
        other.domain == domain &&
        other.displayUrl == displayUrl &&
        other.faviconUrl == faviconUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      url,
      snippet,
      domain,
      displayUrl,
      faviconUrl,
    );
  }
}

/// Domain entity representing a collection of search results with metadata
class SearchItemList {
  final List<SearchItem> items;
  final int totalResults;
  final double searchTime;
  final String query;
  final bool hasMore;
  final int? nextStartIndex;

  const SearchItemList({
    required this.items,
    required this.totalResults,
    required this.searchTime,
    required this.query,
    this.hasMore = false,
    this.nextStartIndex,
  });

  /// Check if the list is empty
  bool get isEmpty => items.isEmpty;

  /// Check if the list is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Get the number of items
  int get length => items.length;

  /// Create a copy with updated fields
  SearchItemList copyWith({
    List<SearchItem>? items,
    int? totalResults,
    double? searchTime,
    String? query,
    bool? hasMore,
    int? nextStartIndex,
  }) {
    return SearchItemList(
      items: items ?? this.items,
      totalResults: totalResults ?? this.totalResults,
      searchTime: searchTime ?? this.searchTime,
      query: query ?? this.query,
      hasMore: hasMore ?? this.hasMore,
      nextStartIndex: nextStartIndex ?? this.nextStartIndex,
    );
  }

  @override
  String toString() {
    return 'SearchItemList(query: $query, items: ${items.length}, totalResults: $totalResults, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchItemList &&
        other.items == items &&
        other.totalResults == totalResults &&
        other.searchTime == searchTime &&
        other.query == query &&
        other.hasMore == hasMore &&
        other.nextStartIndex == nextStartIndex;
  }

  @override
  int get hashCode {
    return Object.hash(
      items,
      totalResults,
      searchTime,
      query,
      hasMore,
      nextStartIndex,
    );
  }
}
