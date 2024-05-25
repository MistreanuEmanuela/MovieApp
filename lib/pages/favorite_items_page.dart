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
  return SizedBox(
    height: 50, // Adjust the height as needed
    child: FutureBuilder<List<Actor>>(
      future: _actorsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
        } else {
          final actors = snapshot.data!;
          return ListView(
            scrollDirection: Axis.vertical,
            children: [
              for (int i = 0; i < actors.length; i += 3)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Row(
                    children: [
                      ActorItem(actor: actors[i]),
                      SizedBox(width: 1.0), // Adjust spacing between movies if needed
                      if (i + 1 < actors.length) ActorItem(actor: actors[i + 1]),
                      if (i + 2 < actors.length) ActorItem(actor: actors[i + 2]),

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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
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
                      SizedBox(width: 8.0), // Adjust spacing between movies if needed
                      if (i + 1 < movies.length) MovieItem(movie: movies[i + 1]),
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
      appBar:AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 28, 70),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
    IconButton(
      icon: Icon(Icons.search),
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
      icon: Icon(Icons.favorite_outlined),
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
    width: 250, // Adjust this value as needed
     child: Center(
          child: GestureDetector(
            onTap: () {
              // Navigate to homepage when image is tapped
              Navigator.pushNamed(context, '/homepage');
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 50.0), // Adjust this value as needed
          Image.asset(
            'assets/images/image.png', // Change this to the path of your logo image
            width: 150.0, // Adjust the width as needed
          ),
          SizedBox(width: 0.0), // Adjust this value as needed
        ],
      ),
    ),
     ),
  ),
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ShrikhandRegular',
                      color: Colors.white,
                    ),
                  ),
                SizedBox(height: 8.0),
                Expanded(child: _buildActorList()),
                SizedBox(height: 8.0),
                  Text(
                    'Favorite Movies',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ShrikhandRegular',
                      color: Colors.white,
                    ),
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
    assert(context != null);
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
        borderRadius: BorderRadius.circular(10.0), // Match container's border radius
        child: Container(
          width: 120.0, 
          height: 170,// Adjust the width as needed
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7), // Adjust the opacity here
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.0),
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 50.0, // Adjust the radius as needed
                  backgroundImage: AssetImage(actor.photoPath),
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  actor.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
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
            builder: (context) => MoviePage(movieId:  movie.id!),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(2.0),
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
                  margin: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Image.asset(
                        movie.photoPath,
                        fit: BoxFit.cover,
                        width: 160.0, // Fixed width for each movie item
                        height: 220.0,
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
                      // Text(
                      //   '${widget.movie.year} | ${widget.movie.duration}',
                      //   style: TextStyle(fontSize: 14.0),
                      // ),
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
                            return SizedBox(
                              width: 160.0, // Maximum width for genre text
                              child: Text(
                                '$genreString',
                                style: TextStyle(fontSize: 14.0),
                              ),
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
            
          ],
        ),
      ),
    );
  }
}
