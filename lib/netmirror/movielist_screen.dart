import 'package:flutter/material.dart';
import '../Utils/common.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import '../widgets/native_banner_ad_widget.dart';
import 'movie_detail_screen.dart';

class MovielistScreen extends StatefulWidget {
  const MovielistScreen({super.key});

  @override
  State<MovielistScreen> createState() => _MovielistScreenState();
}

class _MovielistScreenState extends State<MovielistScreen> {
  final TextEditingController _searchController = TextEditingController(
    text: "2025",
  );
  List<MovieModel> _movies = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalResults = 0;
  bool _hasMorePages = false;

  @override
  void initState() {
    super.initState();
    _searchMovies();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchMovies({bool isNewSearch = true}) async {
    if (_searchController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a search term';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      if (isNewSearch) {
        _movies.clear();
        _currentPage = 1;
      }
    });

    try {
      final response = await ApiService.searchMovies(
        _searchController.text.trim(),
        page: _currentPage,
      );

      if (response != null) {
        setState(() {
          if (isNewSearch) {
            _movies = response.search;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Search'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search movies...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _searchMovies(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _searchMovies,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Search'),
                  ),
                ],
              ),
            ),

            // Error Message
            if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // Results Count
            if (_movies.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Found $_totalResults movies',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),

            // Movies List
            Expanded(
              child: _movies.isEmpty && !_isLoading
                  ? const Center(
                      child: Text(
                        'Search for movies to get started',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
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
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _movies.length + (_hasMorePages ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _movies.length) {
                            // Load more indicator
                            return _hasMorePages
                                ? Container(
                                    padding: const EdgeInsets.all(16),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : const SizedBox.shrink();
                          }
                          final movie = _movies[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 2,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetailScreen(
                                      imdbId: movie.imdbID,
                                      movieTitle: movie.title,
                                    ),
                                  ),
                                );
                              },
                              trailing: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 25,
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              leading: movie.poster != 'N/A'
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        movie.poster,
                                        width: 60,
                                        height: 90,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                width: 60,
                                                height: 90,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.movie,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                      ),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.movie,
                                        color: Colors.grey,
                                      ),
                                    ),
                              title: Text(
                                movie.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Year: ${movie.year}'),
                                  Text('Type: ${movie.type}'),
                                ],
                              ),
                              isThreeLine: true,
                            ),
                          );
                        },
                      ),
                    ),
            ),
            Stack(
              children: [
                Common.Qurekaid.isNotEmpty
                    ? InkWell(
                        onTap: Common.openUrl,
                        child: Image(
                          width: MediaQuery.of(context).size.width,
                          image: const AssetImage(
                            "assets/images/bannerads.png",
                          ),
                          fit: BoxFit.fill,
                        ),
                      )
                    : SizedBox(),
                Common.native_ad_id.isNotEmpty
                    ? NativeBannerAdWidget()
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
