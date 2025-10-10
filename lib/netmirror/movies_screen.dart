import 'dart:async';
import 'package:flutter/material.dart';
import '../services/ad_manager.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import 'movie_detail_screen.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  List<MovieModel> _movies = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalResults = 0;
  bool _hasMorePages = false;
  Timer? _carouselTimer;
  int _carouselIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _searchMovies();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _searchMovies({bool isNewSearch = true}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      if (isNewSearch) {
        _movies.clear();
        _currentPage = 1;
      }
    });

    try {
      final String searchQuery = "movie";

      final response = await ApiService.searchMovies(
        searchQuery,
        page: _currentPage,
        type: 'movie',
      );

      if (response != null) {
        setState(() {
          if (isNewSearch) {
            _movies = response.search;
            _carouselIndex = 0;
            _pageController?.dispose();
            _pageController = null;
            _startCarouselTimer();
          } else {
            _movies.addAll(response.search);
          }
          _totalResults = int.tryParse(response.totalResults) ?? 0;
          _hasMorePages = _movies.length < _totalResults;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No movies found';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching movies: $e';
        _isLoading = false;
      });
    }
  }

  void _loadMoreMovies() {
    if (_hasMorePages && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      _searchMovies(isNewSearch: false);
    }
  }

  void _startCarouselTimer() {
    _carouselTimer?.cancel();
    if (_movies.isNotEmpty) {
      final carouselMovies = _movies.take(10).toList();
      if (carouselMovies.length > 1) {
        _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
          if (mounted && _pageController != null) {
            final nextIndex = (_carouselIndex + 1) % carouselMovies.length;
            _pageController!.animateToPage(
              nextIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  Widget _buildCarousel() {
    if (_movies.isEmpty) return const SizedBox.shrink();

    final carouselMovies = _movies.take(10).toList();
    if (carouselMovies.isEmpty) return const SizedBox.shrink();

    _pageController ??= PageController(
      initialPage: _carouselIndex,
      viewportFraction: 0.85,
    );

    return Container(
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _carouselIndex = index;
          });
        },
        itemCount: carouselMovies.length,
        itemBuilder: (context, index) {
          final movie = carouselMovies[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  movie.poster != 'N/A'
                      ? Image.network(
                          movie.poster,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.movie,
                                color: Colors.grey,
                                size: 60,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.movie,
                            color: Colors.grey,
                            size: 60,
                          ),
                        ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              child: Container(
                color: Colors.black,
                child: Column(
                  children: [
                    if (_errorMessage.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    Expanded(
                      child: _movies.isEmpty && !_isLoading
                          ? const Center(
                              child: Text(
                                'Search for movies to get started',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : NotificationListener<ScrollNotification>(
                              onNotification: (ScrollNotification scrollInfo) {
                                if (scrollInfo.metrics.pixels ==
                                    scrollInfo.metrics.maxScrollExtent) {
                                  _loadMoreMovies();
                                }
                                return true;
                              },
                              child: CustomScrollView(
                                slivers: [
                                  SliverToBoxAdapter(child: _buildCarousel()),
                                  SliverPadding(
                                    padding: const EdgeInsets.all(16),
                                    sliver: SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio: 0.6,
                                          ),
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) {
                                          if (index == _movies.length) {
                                            return _hasMorePages
                                                ? const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.red,
                                                        ),
                                                  )
                                                : const SizedBox.shrink();
                                          }
                                          final movie = _movies[index];
                                          return Card(
                                            elevation: 2,
                                            child: InkWell(
                                              onTap: () {
                                                AdManager()
                                                    .showInterstitialAd();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MovieDetailScreen(
                                                          imdbId: movie.imdbID,
                                                          movieTitle:
                                                              movie.title,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: movie.poster != 'N/A'
                                                        ? ClipRRect(
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    8,
                                                                  ),
                                                              topRight:
                                                                  Radius.circular(
                                                                    8,
                                                                  ),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                    8,
                                                                  ),
                                                              bottomRight:
                                                                  Radius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            child: Image.network(
                                                              movie.poster,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (
                                                                    context,
                                                                    error,
                                                                    stackTrace,
                                                                  ) {
                                                                    return Container(
                                                                      width: double
                                                                          .infinity,
                                                                      decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .grey[300],
                                                                        borderRadius: const BorderRadius.only(
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
                                                                        Icons
                                                                            .movie,
                                                                        color: Colors
                                                                            .grey,
                                                                        size:
                                                                            40,
                                                                      ),
                                                                    );
                                                                  },
                                                            ),
                                                          )
                                                        : Container(
                                                            width:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[300],
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
                                                              color:
                                                                  Colors.grey,
                                                              size: 40,
                                                            ),
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        childCount:
                                            _movies.length +
                                            (_hasMorePages ? 1 : 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const WorkingNativeAdWidget(),
        ],
      ),
    );
  }
}
