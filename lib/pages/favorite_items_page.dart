import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/actor.dart';
import '../models/movie.dart';
import './actor_page.dart';
import './movie_page.dart';
import '../user_preferinces.dart';
import '../models/genre.dart';

class FavoriteItemsPage extends StatefulWidget {
  @override
  _FavoriteItemsPageState createState() => _FavoriteItemsPageState();
}

class _FavoriteItemsPageState extends State<FavoriteItemsPage> {
  late int userId;
  late Future<List<Actor>> _actorsFuture;
  late Future<List<Movie>> _moviesFuture;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    UserPreferences.getUserId().then((value) {
      setState(() {
        userId = value!;
        _actorsFuture = _fetchActors();
        _moviesFuture = _fetchMovies();
      });
    });
  }

  Future<List<Actor>> _fetchActors() async {
    return _databaseHelper.getFavoriteActorsForUser(userId);
  }

  Future<List<Movie>> _fetchMovies() async {
    return _databaseHelper.getFavoriteMoviesForUser(userId);
  }

  Widget _buildActorList() {
    return FutureBuilder<List<Actor>>(
      future: _actorsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
        } else {
          final actors = snapshot.data!;
          return GridView.builder(
            itemCount: actors.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              return ActorItem(actor: actors[index]);
            },
          );
        }
      },
    );
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
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: MovieItem(movie: movies[index]),
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
                SizedBox(height: 8.0),
                Text(
                  'Favorite Actors',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Expanded(child: _buildActorList()),
                SizedBox(height: 8.0),
                Text(
                  'Favorite Movies',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Expanded(child: _buildMovieList()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActorItem extends StatelessWidget {
  final Actor actor;

  const ActorItem({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActorPage(actorId: actor.id!),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 10.0),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 40.0,
                backgroundImage: AssetImage(actor.photoPath),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                actor.name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 5.0),
          ],
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
                    width: MediaQuery.of(context).size.width, // Adjust the width here for single layout
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
