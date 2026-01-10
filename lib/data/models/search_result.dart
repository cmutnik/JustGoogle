/// Model for a single search result item
class SearchResult {
  final String title;
  final String link;
  final String snippet;
  final String? displayLink;
  final String? formattedUrl;
  final Map<String, dynamic>? pagemap;

  const SearchResult({
    required this.title,
    required this.link,
    required this.snippet,
    this.displayLink,
    this.formattedUrl,
    this.pagemap,
  });

  /// Create SearchResult from JSON
  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      title: json['title'] as String? ?? '',
      link: json['link'] as String? ?? '',
      snippet: json['snippet'] as String? ?? '',
      displayLink: json['displayLink'] as String?,
      formattedUrl: json['formattedUrl'] as String?,
      pagemap: json['pagemap'] as Map<String, dynamic>?,
    );
  }

  /// Convert SearchResult to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'snippet': snippet,
      if (displayLink != null) 'displayLink': displayLink,
      if (formattedUrl != null) 'formattedUrl': formattedUrl,
      if (pagemap != null) 'pagemap': pagemap,
    };
  }

  /// Get favicon URL from pagemap
  String? get faviconUrl {
    if (pagemap == null) return null;
    try {
      final metatags = pagemap!['metatags'] as List?;
      if (metatags != null && metatags.isNotEmpty) {
        final firstMeta = metatags.first as Map<String, dynamic>;
        return firstMeta['og:image'] as String?;
      }
    } catch (e) {
      // Ignore errors in parsing pagemap
    }
    return null;
  }

  /// Get domain from link
  String get domain {
    try {
      final uri = Uri.parse(link);
      return uri.host;
    } catch (e) {
      return displayLink ?? '';
    }
  }

  @override
  String toString() {
    return 'SearchResult(title: $title, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SearchResult &&
        other.title == title &&
        other.link == link &&
        other.snippet == snippet &&
        other.displayLink == displayLink &&
        other.formattedUrl == formattedUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      title,
      link,
      snippet,
      displayLink,
      formattedUrl,
    );
  }
}
