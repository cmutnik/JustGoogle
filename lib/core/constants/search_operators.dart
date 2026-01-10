/// Google Search Operators
///
/// This class defines all supported Google search operators
/// that can be used to refine and filter search results.
class SearchOperators {
  SearchOperators._();

  /// Exact phrase match
  /// Usage: "flutter tutorial"
  static const String exactPhrase = '""';

  /// Exclude term
  /// Usage: flutter -dart
  static const String exclude = '-';

  /// Logical OR
  /// Usage: flutter OR react
  static const String or = 'OR';

  /// Wildcard
  /// Usage: flutter * framework
  static const String wildcard = '*';

  /// Site-specific search
  /// Usage: site:flutter.dev
  static const String site = 'site:';

  /// File type filter
  /// Usage: filetype:pdf
  static const String fileType = 'filetype:';

  /// Search in page title
  /// Usage: intitle:tutorial
  static const String inTitle = 'intitle:';

  /// All terms in page title
  /// Usage: allintitle:flutter tutorial
  static const String allInTitle = 'allintitle:';

  /// Search in URL
  /// Usage: inurl:documentation
  static const String inUrl = 'inurl:';

  /// All terms in URL
  /// Usage: allinurl:flutter docs
  static const String allInUrl = 'allinurl:';

  /// Search in page text
  /// Usage: intext:example
  static const String inText = 'intext:';

  /// All terms in page text
  /// Usage: allintext:flutter example
  static const String allInText = 'allintext:';

  /// Find related pages
  /// Usage: related:flutter.dev
  static const String related = 'related:';

  /// View cached version
  /// Usage: cache:flutter.dev
  static const String cache = 'cache:';

  /// Dictionary definition
  /// Usage: define:framework
  static const String define = 'define:';

  /// Numeric range
  /// Usage: price:\$100..\$500
  static const String numericRange = '..';
}

/// Supported file types for filtering
class FileTypes {
  FileTypes._();

  static const String pdf = 'pdf';
  static const String doc = 'doc';
  static const String docx = 'docx';
  static const String xls = 'xls';
  static const String xlsx = 'xlsx';
  static const String ppt = 'ppt';
  static const String pptx = 'pptx';
  static const String txt = 'txt';
  static const String rtf = 'rtf';
  static const String odt = 'odt';
  static const String ods = 'ods';
  static const String odp = 'odp';
  static const String csv = 'csv';
  static const String html = 'html';
  static const String xml = 'xml';
  static const String json = 'json';

  /// Get all supported file types
  static List<String> get all => [
        pdf,
        doc,
        docx,
        xls,
        xlsx,
        ppt,
        pptx,
        txt,
        rtf,
        odt,
        ods,
        odp,
        csv,
        html,
        xml,
        json,
      ];

  /// Get display name for file type
  static String getDisplayName(String fileType) {
    switch (fileType.toLowerCase()) {
      case pdf:
        return 'PDF Document';
      case doc:
      case docx:
        return 'Word Document';
      case xls:
      case xlsx:
        return 'Excel Spreadsheet';
      case ppt:
      case pptx:
        return 'PowerPoint Presentation';
      case txt:
        return 'Text File';
      case rtf:
        return 'Rich Text Format';
      case odt:
        return 'OpenDocument Text';
      case ods:
        return 'OpenDocument Spreadsheet';
      case odp:
        return 'OpenDocument Presentation';
      case csv:
        return 'CSV File';
      case html:
        return 'HTML File';
      case xml:
        return 'XML File';
      case json:
        return 'JSON File';
      default:
        return fileType.toUpperCase();
    }
  }
}

/// Date range presets for filtering
enum DateRange {
  /// Past hour
  pastHour,

  /// Past 24 hours
  pastDay,

  /// Past week
  pastWeek,

  /// Past month
  pastMonth,

  /// Past year
  pastYear,

  /// Custom date range
  custom,

  /// No date filter
  none,
}

extension DateRangeExtension on DateRange {
  /// Get display name for date range
  String get displayName {
    switch (this) {
      case DateRange.pastHour:
        return 'Past Hour';
      case DateRange.pastDay:
        return 'Past 24 Hours';
      case DateRange.pastWeek:
        return 'Past Week';
      case DateRange.pastMonth:
        return 'Past Month';
      case DateRange.pastYear:
        return 'Past Year';
      case DateRange.custom:
        return 'Custom Range';
      case DateRange.none:
        return 'Any Time';
    }
  }

  /// Get API parameter value for Google Custom Search API
  /// Uses the 'dateRestrict' parameter format
  String? get apiValue {
    switch (this) {
      case DateRange.pastHour:
        return 'h1';
      case DateRange.pastDay:
        return 'd1';
      case DateRange.pastWeek:
        return 'w1';
      case DateRange.pastMonth:
        return 'm1';
      case DateRange.pastYear:
        return 'y1';
      case DateRange.custom:
      case DateRange.none:
        return null;
    }
  }
}
