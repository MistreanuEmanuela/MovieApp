import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/movie.dart';
import 'movie_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late DatabaseHelper _databaseHelper;
  String _searchQuery = '';
  late Future<List<Movie>> _searchResultsFuture;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    _searchResultsFuture = _fetchSearchResults();
  }

  Future<List<Movie>> _fetchSearchResults() async {
    if (_searchQuery.isEmpty) {
      return [];
    }
    return await _databaseHelper.searchMovies(_searchQuery);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _searchResultsFuture = _fetchSearchResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 28, 70),
        title: Text('Search Movies'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/first_page.jpg'), // Replace 'background_image.jpg' with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: _onSearchChanged,
                ),
                SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Movie>>(
                    future: _searchResultsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                      } else {
                        final movies = snapshot.data!;
                        if (movies.isEmpty) {
                          return Center(
                            child: Text(
                              'No movies found.',
                              style: TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            final description = movie.plot.substring(0, 80); // Get first 100 letters of description
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              padding: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6.0,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Image.asset(movie.photoPath, fit: BoxFit.cover),
                                title: Text(movie.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(description),
                                    SizedBox(height: 4),
                                    Text('${movie.year} | ${movie.duration}'),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MoviePage(movieId: movie.id!),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
