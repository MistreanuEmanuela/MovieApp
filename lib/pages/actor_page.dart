import 'package:flutter/material.dart';
import '../models/actor.dart';
import '../helpers/database_helper.dart';
import '../models/movie.dart';
import "../user_preferinces.dart";

class ActorPage extends StatefulWidget {
  final int actorId;

  ActorPage({Key? key, required this.actorId}) : super(key: key);

  @override
  _ActorPageState createState() => _ActorPageState();
}

class _ActorPageState extends State<ActorPage> {
  late int userId;

  @override
  void initState() {
    super.initState();
    UserPreferences.getUserId().then((value) {
      setState(() {
        userId = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actor Details'),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/first_page.jpg'), // Your background image here
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder<Actor>(
            future: DatabaseHelper().getActorById(widget.actorId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('Actor not found'));
              } else {
                final Actor actor = snapshot.data!;
                return SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.black.withOpacity(0.0), // Adds a semi-transparent overlay
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: AssetImage(actor.photoPath),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          actor.name,
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Bio: ${actor.bio}',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Movies:',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        FutureBuilder<List<Movie>>(
                          future: DatabaseHelper().getMoviesForActor(widget.actorId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Text('No movies found', style: TextStyle(color: Colors.white));
                            } else {
                              final movies = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: movies.map((movie) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          movie.year.toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(width: 8.0),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: Text(
                                            movie.title,
                                            style: TextStyle(fontSize: 16.0, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (await DatabaseHelper().checkPreferencesActor(userId, widget.actorId)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Actor already favorited')),
                                  );
                                } else {
                                  await DatabaseHelper().insertFavoriteActor(widget.actorId, userId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Actor favorited')),
                                  );
                                }
                              },
                              child: Text('Favorite'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await DatabaseHelper().deleteFavoriteActor(widget.actorId, userId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Actor removed from favorites')),
                                );
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
