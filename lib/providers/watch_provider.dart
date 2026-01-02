import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../data/models/watch_model.dart';
import '../data/repositories/watch_repository.dart';
import '../services/supabase_service.dart';

class WatchProvider extends ChangeNotifier {
  List<WatchModel> _allWatches = [];
  List<WatchModel> _filteredWatches = [];
  List<WatchModel> _userListings = [];
  List<WatchModel> _savedWatches = [];
  List<String> _savedWatchIds = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'Recent';
  RangeValues _priceRange = const RangeValues(0, 100000);
  List<String> _selectedConditions = [];
  bool _isLoading = true;
  String _error = '';

  List<WatchModel> get allWatches => _allWatches;
  List<WatchModel> get filteredWatches => _filteredWatches;
  List<WatchModel> get userListings => _userListings;
  List<WatchModel> get savedWatches => _savedWatches;
  List<String> get savedWatchIds => _savedWatchIds;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  RangeValues get priceRange => _priceRange;
  List<String> get selectedConditions => _selectedConditions;
  bool get isLoading => _isLoading;
  String get error => _error;

  List<WatchModel> get trendingWatches =>
      _allWatches.where((w) => w.isTrending).toList();

  int get notificationCount => 3;

  WatchProvider() {
    loadWatches();
  }

  Future<void> loadWatches() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      _allWatches = await WatchRepository.fetchAllWatches();
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load watches: $e';
      print('Error loading watches: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserListings(String userId) async {
    try {
      _userListings = await WatchRepository.fetchUserWatches(userId);
      notifyListeners();
    } catch (e) {
      print('Error loading user listings: $e');
    }
  }

  Future<void> loadSavedWatches(String userId) async {
    try {
      _savedWatches = await WatchRepository.fetchSavedWatches(userId);
      _savedWatchIds = await WatchRepository.fetchSavedWatchIds(userId);
      notifyListeners();
    } catch (e) {
      print('Error loading saved watches: $e');
    }
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

  Future<void> toggleSaved(String watchId) async {
    try {
      final userId = await SupabaseService.getUserId();
      if (userId == null) return;

      await WatchRepository.toggleSavedWatch(userId, watchId);
      
      if (_savedWatchIds.contains(watchId)) {
        _savedWatchIds.remove(watchId);
        _savedWatches.removeWhere((watch) => watch.id == watchId);
      } else {
        _savedWatchIds.add(watchId);
        final watch = await WatchRepository.fetchWatchById(watchId);
        if (watch != null) {
          _savedWatches.add(watch);
        }
      }
      
      notifyListeners();
    } catch (e) {
      print('Error toggling saved watch: $e');
    }
  }

  bool isSaved(String watchId) => _savedWatchIds.contains(watchId);

  WatchModel? getWatchById(String id) {
    try {
      return _allWatches.firstWhere((w) => w.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> refreshData() async {
    await loadWatches();
    
    final userId = await SupabaseService.getUserId();
    if (userId != null) {
      await loadUserListings(userId);
      await loadSavedWatches(userId);
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}