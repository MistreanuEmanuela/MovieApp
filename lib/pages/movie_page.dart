import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../models/producer.dart'; // Import Producer model
import '../helpers/database_helper.dart';
import '../models/actor.dart';
import '../models/role.dart';
import '../user_preferinces.dart';
import '../pages/actor_page.dart';
class MoviePage extends StatefulWidget {
  final int movieId;

  MoviePage({Key? key, required this.movieId}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}


class _MoviePageState extends State<MoviePage> {
  late int userId ;
  late bool isFavorite =false;

  @override
 void initState() {
  super.initState();
  
  // Retrieve userId first
  UserPreferences.getUserId().then((value) {
    setState(() {
      userId = value!;
      
      // Once userId is retrieved, then proceed to check preferences
      DatabaseHelper().checkPreferences(userId, widget.movieId).then((isFav) {
        setState(() {
          isFavorite = isFav;
        });
      });
    });
  });
}

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
                  DatabaseHelper().getMovieById(widget.movieId),
                  DatabaseHelper().getGenresForMovie(widget.movieId),
                  DatabaseHelper().getProducersForMovie(widget.movieId),
                  DatabaseHelper().getActorsForMovie(widget.movieId),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('Movie not found', style: TextStyle(color: Colors.white)));
                  } else {
                    final Movie movie = snapshot.data![0] as Movie;
                    final List<Genre> genres = snapshot.data![1] as List<Genre>;
                    final List<Producer> producers = snapshot.data![2] as List<Producer>;
                    final List<Actor> actors = snapshot.data![3] as List<Actor>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //   // context,
                                  //   // MaterialPageRoute(
                                  //   //   builder: (context) => MovieImagePage(movieId: movie.id),
                                  //   // ),
                                  // );
                                },
                                child: Image.asset(
                                  movie.photoPath,
                                  fit: BoxFit.cover,
                                  height: 300,
                                ),
                              ),
                            ),
                            isFavorite
                                ? IconButton(
                                      icon: Icon(
                                      Icons.favorite,
                                      color: const Color.fromARGB(255, 255, 0, 0),
                                      size: 40,
                                    ),
                                    onPressed: () async {
                                      await DatabaseHelper().deleteFavoriteMovie(widget.movieId, userId);
                                      setState(() {
                                        isFavorite = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Movie deleted')),
                                      );
                                    },
                                  )
                                : IconButton(
                                     icon: Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: () async {
                                      await DatabaseHelper().insertFavoriteMovie(widget.movieId, userId);
                                      setState(() {
                                        isFavorite = true;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Movie favorited')),
                                      );
                                    },
                                  ),
                          ],
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
                        SizedBox(height: 16.0),
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
    return Stack(
      children: [
        Container(
          height: 150, // Adjust the height according to your needs
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: producers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showProducerInfoDialog(context, producers[index]);
                },
                child: Container(
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
                ),
              );
            },
          ),
        ),
        // Overlay to dim the background
        Container(
          color: Colors.black.withOpacity(0.2), // Adjust opacity as needed
        ),
      ],
    );
  }
void _showProducerInfoDialog(BuildContext context, Producer producer) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.only(top: 8.0, right: 8.0), // Add padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.topRight, // Align Stack to top right
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 0),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(producer.photoPath),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    producer.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Center( // Centering the text horizontally and vertically
                      child: Text(
                        '${producer.bio}',
                        textAlign: TextAlign.center, // Align text to center
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
Widget _buildActors(List<Actor> actors) {
  return Container(
    height: 170,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: actors.map((actor) {
          return SizedBox(
            width: 160,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActorPage(actorId: actor.id!),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(actor.photoPath),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      actor.name,
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                    SizedBox(height: 5.0),
                    FutureBuilder<Role>(
                      future: DatabaseHelper().getRoleForMovieActor(widget.movieId, actor.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return Text('Role not found');
                        } else {
                          return Text(
                            snapshot.data!.name,
                            style: TextStyle(fontSize: 12.0),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ),
  );
}


}
