import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/movie.dart';
import '../models/genre.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = DatabaseHelper().moviesByYearDesc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie App'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/first_page.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
            child: FutureBuilder<List<Movie>>(
              future: _moviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final movies = snapshot.data!;
                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5.0,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                movie.photoPath,
                                fit: BoxFit.cover,
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            SizedBox(height: 10.0),
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
                                  return Wrap(
                                    spacing: 5.0,
                                    children: genres
                                        .map(
                                          (genre) => Chip(
                                            label: Text(
                                              genre.name,
                                              style: TextStyle(fontSize: 12.0),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Movie App',
    home: HomePage(),
  ));
}
