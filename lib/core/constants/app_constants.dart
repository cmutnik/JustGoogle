/// Application-wide constants
class AppConstants {
  AppConstants._();

  /// Application name
  static const String appName = 'JustGoogle';

  /// Application tagline
  static const String appTagline = 'A search engine with no AI components. Back to the basics.';

  /// Default empty state message
  static const String noResultsMessage = 'No results found. Try different keywords or filters.';

  /// Network error message
  static const String networkErrorMessage = 'Network error. Please check your connection and try again.';

  /// Rate limit error message
  static const String rateLimitMessage = 'Daily search limit reached. Please try again tomorrow.';

  /// Search hint text
  static const String searchHintText = 'Search the web...';

  /// Maximum search history items to store
  static const int maxHistoryItems = 100;

  /// Minimum query length to trigger search
  static const int minQueryLength = 1;

  /// Maximum query length
  static const int maxQueryLength = 2048;

  /// Default theme mode key (for SharedPreferences)
  static const String themeModeKey = 'theme_mode';

  /// Search history key (for SharedPreferences)
  static const String searchHistoryKey = 'search_history';

  /// Enable history key (for SharedPreferences)
  static const String enableHistoryKey = 'enable_history';

  /// Results per page key (for SharedPreferences)
  static const String resultsPerPageKey = 'results_per_page';

  /// Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;
  static const double desktopBreakpoint = 1440;
}
