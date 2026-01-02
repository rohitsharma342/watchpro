import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/models/watch_model.dart';
import '../data/repositories/static_data.dart';

class WatchProvider extends ChangeNotifier {
  List<WatchModel> _allWatches = [];
  List<WatchModel> _filteredWatches = [];
  List<WatchModel> _userListings = [];
  List<String> _savedWatchIds = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'Recent';
  RangeValues _priceRange = const RangeValues(0, 100000);
  List<String> _selectedConditions = [];
  bool _isLoading = true;

  List<WatchModel> get allWatches => _allWatches;
  List<WatchModel> get filteredWatches => _filteredWatches;
  List<WatchModel> get userListings => _userListings;
  List<String> get savedWatchIds => _savedWatchIds;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  RangeValues get priceRange => _priceRange;
  List<String> get selectedConditions => _selectedConditions;
  bool get isLoading => _isLoading;

  List<WatchModel> get trendingWatches =>
      _allWatches.where((w) => w.isTrending).toList();

  List<WatchModel> get savedWatches =>
      _allWatches.where((w) => _savedWatchIds.contains(w.id)).toList();

  int get notificationCount => 3;

  WatchProvider() {
    loadWatches();
  }

  Future<void> loadWatches() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    _allWatches = StaticData.watches;
    _userListings = StaticData.userListings;
    _savedWatchIds = List.from(StaticData.savedWatchIds);
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _applyFilters();
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFilters();
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    _priceRange = range;
    _applyFilters();
    notifyListeners();
  }

  void setConditions(List<String> conditions) {
    _selectedConditions = conditions;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _sortBy = 'Recent';
    _priceRange = const RangeValues(0, 100000);
    _selectedConditions = [];
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredWatches = _allWatches.where((watch) {
      if (_selectedCategory != 'All' && watch.category != _selectedCategory) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!watch.title.toLowerCase().contains(query) &&
            !watch.brand.toLowerCase().contains(query) &&
            !watch.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      if (watch.price < _priceRange.start || watch.price > _priceRange.end) {
        return false;
      }

      if (_selectedConditions.isNotEmpty &&
          !_selectedConditions.contains(watch.condition)) {
        return false;
      }

      return true;
    }).toList();

    switch (_sortBy) {
      case 'Price: Low to High':
        _filteredWatches.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        _filteredWatches.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Recent':
      default:
        _filteredWatches.sort((a, b) => b.listedDate.compareTo(a.listedDate));
        break;
    }
  }

  void toggleSaved(String watchId) {
    if (_savedWatchIds.contains(watchId)) {
      _savedWatchIds.remove(watchId);
    } else {
      _savedWatchIds.add(watchId);
    }
    notifyListeners();
  }

  bool isSaved(String watchId) => _savedWatchIds.contains(watchId);

  WatchModel? getWatchById(String id) {
    try {
      return _allWatches.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }
}
