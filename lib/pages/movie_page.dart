import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../models/producer.dart'; // Import Producer model
import '../helpers/database_helper.dart';
import '../models/actor.dart';

class MoviePage extends StatelessWidget {
  final int movieId;

  const MoviePage({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/first_page.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              color: Colors.black.withOpacity(0.6),
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: Future.wait([
                  DatabaseHelper().getMovieById(movieId),
                  DatabaseHelper().getGenresForMovie(movieId),
                  DatabaseHelper().getProducersForMovie(movieId),
                  DatabaseHelper().getActorsForMovie(movieId),// Fetch producers
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('Movie not found', style: TextStyle(color: Colors.white)));
                  } else {
                    final Movie movie = snapshot.data![0] as Movie;
                    final List<Genre> genres = snapshot.data![1] as List<Genre>;
                    final List<Producer> producers = snapshot.data![2] as List<Producer>; // Get producers
                    final List<Actor> actors = snapshot.data![3] as List<Actor>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Image.asset(
                            movie.photoPath,
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              movie.title,
                              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '${movie.duration}',
                              style: TextStyle(fontSize: 18.0, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Year: ${movie.year}',
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        SizedBox(height: 2.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: genres
                              .map((genre) => Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: const Color.fromARGB(255, 71, 64, 64), width: 1.0),
                                    ),
                                    child: Text(
                                      genre.name,
                                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                                    ),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          movie.plot,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Producers:',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        _buildProducers(producers),
                        SizedBox(height: 16.0),
                        Text(
                          'Actors:',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        _buildActors(actors),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProducers(List<Producer> producers) {
    return Container(
      height: 150, // Adjust the height according to your needs
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: producers.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(producers[index].photoPath),
                ),
                SizedBox(height: 8.0),
                Text(
                  producers[index].name,
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActors(List<Actor> actors) {
    return Container(
      height: 150, // Adjust the height according to your needs
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: actors.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(actors[index].photoPath),
                ),
                SizedBox(height: 8.0),
                Text(
                  actors[index].name,
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
