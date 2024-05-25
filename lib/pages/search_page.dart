import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/movie.dart';
import 'movie_page.dart';
import '../pages/favorite_movies.dart';
import '../pages/favorite_actors.dart';

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
     leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white, // Set icon color to white
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
    
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white, // Set icon color to white
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SearchPage(),
              //   ),
              // );
            },
          ),
          IconButton(
            icon: Icon(Icons.movie),
            color: Colors.white, // Set icon color to white
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteMoviesPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person_3_rounded),
            color: Colors.white, // Set icon color to white
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteActorsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/first_page.jpg'), // Replace with your image asset
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
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(
                            'No movies found.',
                            style: TextStyle(fontSize: 18.0, color: Colors.white),
                          ),
                        );
                      } else {
                        final movies = snapshot.data!;
                        return ListView.builder(
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            var description = movie.plot.length > 80 ? movie.plot.substring(0, 80) + "..." : movie.plot;
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
                                contentPadding: const EdgeInsets.all(5.0),
                                leading: Container(
                                  height: 100.0, // Changed height to 100.0
                                  width: 70.0,   // Adjust the width as desired
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Added this line
                                    borderRadius: BorderRadius.circular(10.0), // Added this line
                                  ),
                                  child: FractionallySizedBox(
                                    heightFactor: 1.0, // Full height of the container
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0), // Adjust this value to match the movie container
                                      child: Image.asset(
                                        movie.photoPath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  movie.title,
                                  style: TextStyle(fontSize: 20, color: Colors.black), // Increase font size and change text color to black
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      description,
                                      style: const TextStyle(color: Color.fromRGBO(114, 114, 114, 1)), // Change text color to grey
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${movie.year} | ${movie.duration}',
                                      style: TextStyle(color: Color.fromRGBO(114, 114, 114, 1)), // Change text color to grey
                                    ),
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
