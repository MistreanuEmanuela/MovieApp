import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/actor.dart';
import '../models/movie.dart';
import './actor_page.dart';
import './movie_page.dart';
import '../user_preferinces.dart';
import '../models/genre.dart';
import '../pages/search_page.dart';

class FavoriteItemsPage extends StatefulWidget {
  @override
  _FavoriteItemsPageState createState() => _FavoriteItemsPageState();
}

class _FavoriteItemsPageState extends State<FavoriteItemsPage> {
  late int userId;
late Future<List<Actor>> _actorsFuture = Future.value([]);
late Future<List<Movie>> _moviesFuture = Future.value([]);
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
    return SizedBox(
      height: 50, // Adjust the height as needed
      child: FutureBuilder<List<Actor>>(
        future: _actorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.white)));
          } else {
            final actors = snapshot.data!;
            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                for (int i = 0; i < actors.length; i += 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        ActorItem(actor: actors[i]),
                        const SizedBox(width: 4.0),
                        if (i + 1 < actors.length)
                          ActorItem(actor: actors[i + 1]),
                        const SizedBox(width: 4.0),
                        if (i + 2 < actors.length)
                          ActorItem(actor: actors[i + 2]),
                      ],
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMovieList() {
    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white)));
        } else {
          final movies = snapshot.data!;
          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (int i = 0; i < movies.length; i += 2)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(
                    children: [
                      MovieItem(movie: movies[i]),
                      const SizedBox(width: 8.0),
                      if (i + 1 < movies.length)
                        MovieItem(movie: movies[i + 1]),
                    ],
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 28, 70),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outlined),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteItemsPage(),
                ),
              );
            },
          ),
        ],
        title: SizedBox(
          width: 250,
          child: Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/homepage');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 50.0),
                  Image.asset(
                    'assets/images/image.png',
                    width: 150.0,
                  ),
                  const SizedBox(width: 0.0),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/first_page.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8.0),
                const Text(
                  'Favorite Actors',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(child: _buildActorList()),
                const SizedBox(height: 8.0),
                const Text(
                  'Favorite Movies',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: 110.0,
          height: 150,
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 45.0,
                  backgroundImage: AssetImage(actor.photoPath),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  actor.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 2.0),
            ],
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
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7), // Adjust the opacity here
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Image.asset(
                        movie.photoPath,
                        fit: BoxFit.cover,
                        width: 145.0,
                        height: 200.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      FutureBuilder<List<Genre>>(
                        future:
                            DatabaseHelper().getGenresForMovie(movie.id ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final genres = snapshot.data!;
                            final genreNames =
                                genres.map((genre) => genre.name).toList();
                            final genreString = genreNames.join(', ');
                            return SizedBox(
                              width: 140.0,
                              child: Text(
                                genreString,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
