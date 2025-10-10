import 'dart:async';
import 'package:flutter/material.dart';
import '../services/ad_manager.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import 'movie_detail_screen.dart';

class CombinedSearchScreen extends StatefulWidget {
  const CombinedSearchScreen({super.key});

  @override
  State<CombinedSearchScreen> createState() => _CombinedSearchScreenState();
}

class _CombinedSearchScreenState extends State<CombinedSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<MovieModel> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalResults = 0;
  bool _hasMorePages = false;
  bool _isMoviesSelected = true; // true for movies, false for series

  @override
  void initState() {
    super.initState();
    _searchContent();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchContent({bool isNewSearch = true}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      if (isNewSearch) {
        _results.clear();
        _currentPage = 1;
      }
    });

    try {
      final String searchQuery = _searchController.text.trim().isEmpty
          ? (_isMoviesSelected ? "2025" : "2025")
          : _searchController.text.trim();

      final response = await ApiService.searchMovies(
        searchQuery,
        page: _currentPage,
        type: _isMoviesSelected ? 'movie' : 'series',
      );

      if (response != null) {
        setState(() {
          if (isNewSearch) {
            _results = response.search;
          } else {
            _results.addAll(response.search);
          }
          _totalResults = int.tryParse(response.totalResults) ?? 0;
          _hasMorePages = _results.length < _totalResults;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No ${_isMoviesSelected ? 'movies' : 'series'} found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            'Error searching ${_isMoviesSelected ? 'movies' : 'series'}: $e';
        _isLoading = false;
      });
    }
  }

  void _loadMoreContent() {
    if (_hasMorePages && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      _searchContent(isNewSearch: false);
    }
  }

  void _toggleContentType(bool isMovies) {
    if (_isMoviesSelected != isMovies) {
      setState(() {
        _isMoviesSelected = isMovies;
      });
      _searchContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText:
                                  'Search ${_isMoviesSelected ? 'movies' : 'TV shows'}...',
                              hintStyle: const TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (_) => _searchContent(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _searchContent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Search'),
                        ),
                      ],
                    ),
                  ),
                  // Toggle Button for Movies/TV Shows
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _toggleContentType(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isMoviesSelected
                                    ? Colors.red
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                'Movies',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isMoviesSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _toggleContentType(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isMoviesSelected
                                    ? Colors.red
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                'TV Shows',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !_isMoviesSelected
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  // Results Grid
                  Expanded(
                    child: _results.isEmpty && !_isLoading
                        ? Center(
                            child: Text(
                              'Search for ${_isMoviesSelected ? 'movies' : 'TV shows'} to get started',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent) {
                                _loadMoreContent();
                              }
                              return true;
                            },
                            child: GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount:
                                  _results.length + (_hasMorePages ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _results.length) {
                                  // Load more indicator
                                  return _hasMorePages
                                      ? Container(
                                          padding: const EdgeInsets.all(16),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink();
                                }
                                final item = _results[index];
                                return Card(
                                  elevation: 2,
                                  child: InkWell(
                                    onTap: () {
                                      AdManager().showInterstitialAd();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                                imdbId: item.imdbID,
                                                movieTitle: item.title,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: item.poster != 'N/A'
                                              ? ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(8),
                                                        topRight:
                                                            Radius.circular(8),
                                                        bottomLeft:
                                                            Radius.circular(8),
                                                        bottomRight:
                                                            Radius.circular(8),
                                                      ),
                                                  child: Image.network(
                                                    item.poster,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Colors.grey[300],
                                                          borderRadius:
                                                              const BorderRadius.only(
                                                                topLeft:
                                                                    Radius.circular(
                                                                      8,
                                                                    ),
                                                                topRight:
                                                                    Radius.circular(
                                                                      8,
                                                                    ),
                                                              ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.movie,
                                                          color: Colors.grey,
                                                          size: 40,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                8,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                8,
                                                              ),
                                                        ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.movie,
                                                    color: Colors.grey,
                                                    size: 40,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const WorkingNativeAdWidget(),
          ],
        ),
      ),
    );
  }
}
