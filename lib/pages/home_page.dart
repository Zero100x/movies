import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/movie_card.dart';
import '../services/movie_service.dart';
import '../models/movie_model.dart';
import 'movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> _movies = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // For date selector
  final List<String> _dates = ['Th\n15', 'Fri\n16', 'Sat\n17', 'Sun\n18', 'Mon\n19'];
  int _selectedDateIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final movies = await OmdbService.getPopularMovies();
      setState(() {
        _movies = movies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load movies';
        _isLoading = false;
      });
    }
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedDateIndex;
          return GestureDetector(
            onTap: () => setState(() => _selectedDateIndex = index),
            child: Container(
              width: 68,
              decoration: BoxDecoration(
                color: isSelected ? Colors.pinkAccent : Colors.grey[200],
                borderRadius: BorderRadius.circular(14),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                _dates[index],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[800],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrailersRow() {
    // Use first 4 movies posters as "trailers" thumbnails
    final trailers = _movies.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trailers',
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: trailers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final m = trailers[i];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      m.poster,
                      width: 140,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 140,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie, size: 30),
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.0), Colors.black26],
                        ),
                      ),
                    ),
                    const Icon(Icons.play_circle_fill, size: 36, color: Colors.white70),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Background color like your design (soft pink)
    final bg = const Color(0xFFFCE7EF);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search row (left: field, right: small circular search icon)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 18),

              // Titles
              Text('Explore',
                  style: GoogleFonts.poppins(fontSize: 22, color: Colors.grey[800])),
              Text('Top Movies',
                  style: GoogleFonts.poppins(
                      fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black87)),

              const SizedBox(height: 16),

              // Date selector (chips)
              _buildDateSelector(),

              const SizedBox(height: 12),

              // Main horizontal list of movie cards
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage.isNotEmpty
                        ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _movies.length,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            separatorBuilder: (_, __) => const SizedBox(width: 18),
                            itemBuilder: (context, index) {
                              final movie = _movies[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MovieDetailPage(movie: movie),
                                    ),
                                  );
                                },
                                child: MovieCard(movie: movie),
                              );
                            },
                          ),
              ),

              const SizedBox(height: 12),

              // Trailers row & small bottom spacing
              if (_movies.isNotEmpty) _buildTrailersRow(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
