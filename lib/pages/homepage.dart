import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import 'movie_page.dart'; 
import '../pages/favorite_actors.dart';
import '../pages/search_page.dart';
import '../user_preferinces.dart';
import '../pages/favorite_items_page.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Genre> _genres = [];
  late Future<List<Movie>> _moviesFuture;
  late DatabaseHelper _databaseHelper;
  late Future<List<Movie>> _movieFavFuture;
  String _selectedGenre = 'All';
  late int userId;

  @override
  void initState() {
    super.initState();
    UserPreferences.getUserId().then((value) {
      setState(() {
        userId = value!;
      });
    });
    _databaseHelper = DatabaseHelper();
    _fetchGenres();
    _moviesFuture = _fetchMovies();
    _movieFavFuture = _databaseHelper.getTopMovies();

  }

 



  Future<void> _fetchGenres() async {
    final genres = await _databaseHelper.getAllGenres();
    setState(() {
      _genres = genres;
    });
  }

  Future<List<Movie>> _fetchMovies() async {
    List<Movie> movies;
    if (_selectedGenre == 'All') {
      movies = await _databaseHelper.movies();
    } else {
      movies = await _databaseHelper.getMoviesByGenre(_selectedGenre);
    }
    
    // Filter out duplicates
    movies = movies.toSet().toList(); // Convert to Set to remove duplicates, then back to List
    
    return movies;
  }

  Widget _buildGenreButtons() {
    List<Widget> buttons = [];

    buttons.add(
      ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedGenre = 'All';
            _moviesFuture = _fetchMovies();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedGenre == 'All' ? Colors.yellow : null,
        ),
        child: Text('All'),
      ),
    );

    for (Genre genre in _genres) {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedGenre = genre.name;
              _moviesFuture = _fetchMovies();
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedGenre == genre.name ? Colors.yellow : null,
          ),
          child: Text(genre.name),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: buttons.map((button) => Padding(padding: EdgeInsets.symmetric(horizontal: 4.0), child: button)).toList(),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      MovieItem(movie: movies[i], userId: userId),
                      SizedBox(width: 8.0), // Adjust spacing between movies if needed
                      if (i + 1 < movies.length) MovieItem(movie: movies[i + 1], userId: userId,),
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
      appBar:  AppBar(
      backgroundColor: const Color.fromARGB(255, 2, 28, 70),
      leading: IconButton(
        icon: Icon(Icons.exit_to_app), // Changed to exit icon
        color: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Are you sure you want to disconnect?"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                    
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/'); // Close the dialog
                    },
                    child: Text("Yes"),
                  ),
                ],
              );
            },
          );
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
                Text(
                  'Top Movies',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                _buildTopMoviesSection(),
                SizedBox(height: 16.0),
                _buildGenreButtons(),
                SizedBox(height: 16.0),
                Expanded(child: _buildMovieList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopMoviesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 260.0, // Height of the favorite movie item
          child: FutureBuilder<List<Movie>>(
            future: _movieFavFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
              } else {
                final movies = snapshot.data!;
                if (movies.isNotEmpty) {
                  return PageView.builder(
                    itemCount: movies.length,
                    physics: BouncingScrollPhysics(), // Custom physics for partial visibility
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MoviePage(movieId: movie.id!),
                            ),
                          );
                        },
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.asset(
                                    movie.photoPath,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width * 0.85, // Adjusted width for center visibility
                                    height: 230.0, // Height of the image
                                  ),
                                ),
                                // Title
                                Positioned(
                                  bottom: 10.0,
                                  left: 10.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white), // Bigger title
                                      ),
                                      FutureBuilder<List<Genre>>(
                                        future: _databaseHelper.getGenresForMovie(movie.id!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return SizedBox(); // Return an empty container while waiting for data
                                          } else if (snapshot.hasError) {
                                            return SizedBox(); // Return an empty container if there's an error
                                          } else {
                                            final genres = snapshot.data!;
                                            return Wrap(
                                              spacing: 4.0, // Adjust spacing between boxes
                                              runSpacing: 3.0, // Adjust spacing between rows
                                              children: genres.map((genre) {
                                                return Container(
                                                  padding: EdgeInsets.all(4.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.withOpacity(0.7),
                                                    borderRadius: BorderRadius.circular(4.0),
                                                  ),
                                                  child: Text(
                                                    genre.name,
                                                    style: TextStyle(fontSize: 12.0, color: Colors.white),
                                                  ),
                                                );
                                              }).toList(),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'No favorite movies yet.',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  );
                }
              }
            },
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class MovieItem extends StatefulWidget {
  final Movie movie;
  final int userId; // Add userId as a parameter

  const MovieItem({Key? key, required this.movie, required this.userId}) : super(key: key);

  @override
  _MovieItemState createState() => _MovieItemState();
}

class _MovieItemState extends State<MovieItem> {
  late bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    bool favorite = await DatabaseHelper().checkPreferences(widget.userId, widget.movie.id!);
    setState(() {
      isFavorite = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviePage(movieId: widget.movie.id!),
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
                        widget.movie.photoPath,
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
                        widget.movie.title,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '${widget.movie.year} | ${widget.movie.duration}',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      SizedBox(height: 5.0),
                      FutureBuilder<List<Genre>>(
                        future: DatabaseHelper().getGenresForMovie(widget.movie.id ?? 0),
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
            if (isFavorite ?? false) // Ensure isFavorite is not null before accessing its value
            Positioned(
                top: 10,
                right: 20,
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 32, // Adjust the size here, for example
                ),
              ),
          ],
        ),
      ),
    );
  }
}