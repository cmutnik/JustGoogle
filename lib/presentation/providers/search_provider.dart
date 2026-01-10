import 'package:flutter/foundation.dart';
import '../../core/constants/search_types.dart';
import '../../domain/entities/search_item.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/search_web.dart';
import '../../data/models/search_request.dart';

/// State for search operations
enum SearchState {
  /// Initial state, no search performed
  initial,

  /// Search is in progress
  loading,

  /// Search completed successfully
  success,

  /// Search returned no results
  empty,

  /// Search failed with an error
  error,
}

/// Provider for managing search state and operations
class SearchProvider with ChangeNotifier {
  final SearchWeb _searchWeb;

  SearchProvider(this._searchWeb);

  // State
  SearchState _state = SearchState.initial;
  String _query = '';
  List<SearchItem> _items = [];
  int _totalResults = 0;
  double _searchTime = 0.0;
  String? _errorMessage;
  bool _hasMore = false;
  int? _nextStartIndex;
  int _currentPage = 1;
  SearchType _searchType = SearchType.web;

  // Getters
  SearchState get state => _state;
  String get query => _query;
  List<SearchItem> get items => _items;
  int get totalResults => _totalResults;
  double get searchTime => _searchTime;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  bool get isLoading => _state == SearchState.loading;
  bool get hasResults => _items.isNotEmpty;
  SearchType get searchType => _searchType;

  /// Switch between web and image search types
  Future<void> switchSearchType(SearchType newType) async {
    if (_searchType == newType) return;

    _searchType = newType;

    // If there's an active query, re-search with new type
    if (_query.isNotEmpty) {
      await search(_query);
    } else {
      // Just update the UI
      notifyListeners();
    }
  }

  /// Perform a search
  Future<void> search(String query, {SearchRequest? customRequest}) async {
    if (query.trim().isEmpty) {
      return;
    }

    _query = query.trim();
    _state = SearchState.loading;
    _errorMessage = null;
    _currentPage = 1;
    notifyListeners();

    try {
      final request = customRequest ?? SearchRequest(
        query: _query,
        searchType: _searchType,
      );
      final result = await _searchWeb.execute(request);

      _items = result.items;
      _totalResults = result.totalResults;
      _searchTime = result.searchTime;
      _hasMore = result.hasMore;
      _nextStartIndex = result.nextStartIndex;

      _state = _items.isEmpty ? SearchState.empty : SearchState.success;
      notifyListeners();
    } on NetworkException catch (e) {
      _state = SearchState.error;
      _errorMessage = e.message;
      _items = [];
      notifyListeners();
    } on RateLimitException catch (e) {
      _state = SearchState.error;
      _errorMessage = e.message;
      _items = [];
      notifyListeners();
    } on InvalidQueryException catch (e) {
      _state = SearchState.error;
      _errorMessage = e.message;
      _items = [];
      notifyListeners();
    } on ApiException catch (e) {
      _state = SearchState.error;
      _errorMessage = e.message;
      _items = [];
      notifyListeners();
    } catch (e) {
      _state = SearchState.error;
      _errorMessage = 'An unexpected error occurred: $e';
      _items = [];
      notifyListeners();
    }
  }

  /// Load more results (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || _state == SearchState.loading || _nextStartIndex == null) {
      return;
    }

    final previousState = _state;
    _state = SearchState.loading;
    notifyListeners();

    try {
      final request = SearchRequest(
        query: _query,
        startIndex: _nextStartIndex!,
        searchType: _searchType,
      );
      final result = await _searchWeb.execute(request);

      _items.addAll(result.items);
      _hasMore = result.hasMore;
      _nextStartIndex = result.nextStartIndex;
      _currentPage++;

      _state = SearchState.success;
      notifyListeners();
    } catch (e) {
      // Revert to previous state on error
      _state = previousState;
      // Optionally show a snackbar or error message
      notifyListeners();
    }
  }

  /// Clear search results and reset to initial state
  void clear() {
    _state = SearchState.initial;
    _query = '';
    _items = [];
    _totalResults = 0;
    _searchTime = 0.0;
    _errorMessage = null;
    _hasMore = false;
    _nextStartIndex = null;
    _currentPage = 1;
    _searchType = SearchType.web;
    notifyListeners();
  }

  /// Retry the last search
  Future<void> retry() async {
    if (_query.isNotEmpty) {
      await search(_query);
    }
  }
}
