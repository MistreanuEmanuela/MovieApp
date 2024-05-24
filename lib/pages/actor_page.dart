import 'package:flutter/material.dart';
import '../models/actor.dart';
import '../helpers/database_helper.dart';
import '../models/movie.dart';
import "../user_preferinces.dart";
import "../pages/movie_page.dart";

class ActorPage extends StatefulWidget {
  final int actorId;

  ActorPage({Key? key, required this.actorId}) : super(key: key);

  @override
  _ActorPageState createState() => _ActorPageState();
}

class _ActorPageState extends State<ActorPage> {
  late int userId;
  late bool isFavorite = false;
  bool showBibliography = false;
  ScrollController _scrollController = ScrollController();
  double _bottomContainerHeight = 0;

  @override
  void initState() {
    super.initState();
    UserPreferences.getUserId().then((value) {
      setState(() {
        userId = value!;

        // Once userId is retrieved, then proceed to check preferences
        DatabaseHelper().checkPreferencesActor(userId, widget.actorId).then((isFav) {
          setState(() {
            isFavorite = isFav;
          });
        });
      });
    });

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      setState(() {
        showBibliography = false;
      });
    }
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
          SingleChildScrollView(
            controller: _scrollController,
            child: FutureBuilder<Actor>(
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
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.black.withOpacity(0.0), // Adds a semi-transparent overlay
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: isFavorite
                              ? IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: const Color.fromARGB(255, 255, 0, 0),
                                    size: 40,
                                  ),
                                  onPressed: () async {
                                    await DatabaseHelper().deleteFavoriteMovie(widget.actorId, userId);
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
                                    await DatabaseHelper().insertFavoriteMovie(widget.actorId, userId);
                                    setState(() {
                                      isFavorite = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Movie favorited')),
                                    );
                                  },
                                ),
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage(actor.photoPath),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Center(
                          child: Text(
                            actor.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.white, size: 18),
                            SizedBox(width: 4.0),
                            Text(
                              'Bio: ${actor.bio}',
                              style: TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.cake, color: Colors.white, size: 18),
                            SizedBox(width: 4.0),
                            Text(
                              'Birthdate: ${"22.02.33"}', // Assuming actor.birthdate contains the birthdate information
                              style: TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                          ],
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
                                  return MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MoviePage(movieId: movie.id!), // Assuming MoviePage is the destination page
                                          ),
                                        );
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Padding(
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
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
         AnimatedPositioned(
  duration: Duration(milliseconds: 300),
  bottom: showBibliography ? 0 : -_bottomContainerHeight,
  left: 0,
  right: 0,
  height: MediaQuery.of(context).size.height * (showBibliography ? 0.7 : 0.1), // Adjust height based on showBibliography
  child: GestureDetector(
    onTap: () {
      setState(() {
        showBibliography = !showBibliography;
      });
    },
    child: Container(
      decoration: BoxDecoration(
        color: showBibliography ? Colors.white.withOpacity(1.0) :  Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      padding: EdgeInsets.fromLTRB(16.0, showBibliography ? 16.0 : 0.0, 16.0, showBibliography ? 16.0 : 1.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(showBibliography ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
                iconSize: 32,
                onPressed: () {
                  setState(() {
                    showBibliography = !showBibliography;
                  });
                },
              ),
             
            ],
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: showBibliography ? 1.0 : 0.0,
              child: SingleChildScrollView( // Add SingleChildScrollView
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras molestie, erat ac accumsan convallis, ligula orci iaculis lectus, a semper ante eros elementum enim. Nulla facilisi. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Integer a urna ut urna feugiat vehicula. Nulla blandit enim quis mauris semper fringilla. Donec ornare imperdiet sodales. In maximus urna eget metus sodales lacinia vel et ante. Curabitur iaculis lectus nec ipsum rutrum congue. Mauris semper sit amet nunc hendrerit ultricies. Duis vitae nisl non nibh feugiat vulputate sit amet vel arcu. Etiam tristique, arcu id fermentum sagittis, felis metus rutrum turpis, a viverra purus purus at massa. Fusce vitae urna metus. Fusce nec justo non dolor posuere dictum vel eget ligula. Quisque ac interdum purus. Praesent suscipit urna sit amet lacus viverra, a ullamcorper ex cursus....',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),
        ],
      ),
    );
  }
}
