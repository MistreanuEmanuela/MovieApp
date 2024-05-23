import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import 'movie_page.dart'; 
import '../user_preferinces.dart';

class FavoriteMoviesPage extends StatefulWidget {

  @override
  _FavoriteMoviesPage createState() => _FavoriteMoviesPage();
}

class _FavoriteMoviesPage extends State<FavoriteMoviesPage> {
  late int userId;
  late Future<List<Movie>> _moviesFuture;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    UserPreferences.getUserId().then((value) {
      setState(() {
        userId = value!;
        _moviesFuture = _fetchMovies();
      });
    });
  }

  Future<List<Movie>> _fetchMovies() async {
    return _databaseHelper.getFavoriteMoviesForUser(userId);
  }

  Widget _buildMovieList() {
    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
        } else {
          final movies = snapshot.data!;
          return ListView.builder(
            itemCount: (movies.length / 2).ceil(),
            itemBuilder: (context, index) {
              final startIndex = index * 2;
              final endIndex = (index * 2) + 2;
              return Row(
                children: [
                  for (var i = startIndex; i < endIndex && i < movies.length; i++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MovieItem(movie: movies[i]),
                      ),
                    ),
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Movie App'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'Settings':
                // Navigate to Settings page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                break;
              case 'About':
                // Navigate to About page
                // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                break;
              // Add more cases for additional menu items
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Settings',
              child: Text('Settings'),
            ),
            PopupMenuItem<String>(
              value: 'About',
              child: Text('About'),
            ),
            // Add more PopupMenuItems for additional menu options
          ],
        ),
      ],
    ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/first_page.jpg'), // Replace 'background_image.jpg' with your image asset
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
             
                SizedBox(height: 16.0),
                Expanded(child: _buildMovieList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MovieItem extends StatelessWidget {
  final Movie movie;

  const MovieItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviePage(movieId: movie.id!),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7), // Adjust the opacity here
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.0),
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image.asset(
                    movie.photoPath,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.8, // Adjust the width here for grid layout
                    height: 200,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    '${movie.year} | ${movie.duration}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  SizedBox(height: 5.0),
                  FutureBuilder<List<Genre>>(
                    future: DatabaseHelper().getGenresForMovie(movie.id ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final genres = snapshot.data!;
                        final genreNames = genres.map((genre) => genre.name).toList();
                        final genreString = genreNames.join(', '); // Join genre names with commas
                        return Text(
                          '$genreString',
                          style: TextStyle(fontSize: 14.0),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
