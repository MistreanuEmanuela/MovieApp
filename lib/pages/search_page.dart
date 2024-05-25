import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/movie.dart';
import 'movie_page.dart';
import '../pages/favorite_items_page.dart';


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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/first_page.jpg'),
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
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
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
                            return FutureBuilder<bool>(
                              future: _databaseHelper.checkPreferences(1, movie.id!),
                              builder: (context, isFavSnapshot) {
                                if (isFavSnapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (isFavSnapshot.hasError) {
                                  return Text('Error: ${isFavSnapshot.error}');
                                } else {
                                  bool isFav = isFavSnapshot.data ?? false;
                                  var description = movie.plot.length > 80
                                      ? movie.plot.substring(0, 80) + "..."
                                      : movie.plot;
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
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(5.0),
                                      leading: Container(
                                        height: 200.0,
                                        width: 80.0,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 161, 38, 38),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: FractionallySizedBox(
                                          heightFactor: 2.0,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10.0),
                                            child: Image.asset(
                                              movie.photoPath,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        movie.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            description,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(114, 114, 114, 1),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${movie.year} | ${movie.duration}',
                                            style: TextStyle(
                                              color: Color.fromRGBO(114, 114, 114, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: isFav
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : SizedBox(), // If not a favorite, show an empty SizedBox to maintain alignment
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
                                }
                              },
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