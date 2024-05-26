import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../models/producer.dart';
import '../helpers/database_helper.dart';
import '../models/actor.dart';
import '../models/role.dart';
import '../user_preferinces.dart';
import '../pages/actor_page.dart';
import '../pages/favorite_items_page.dart';
import '../pages/search_page.dart';
import '../widgets/animated_dialog.dart';

class MoviePage extends StatefulWidget {
  final int movieId;

  MoviePage({Key? key, required this.movieId}) : super(key: key);

  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late int userId;
  late bool isFavorite = false;

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

  void _showAnimatedDialog() {
    showDialog(
      context: context,
       builder: (context) => const AnimatedDialog(
      icon: Icons.favorite, // Pass the icon you want to display
      message: 'Movie added to favorites!',
      color: Colors.red, // Pass the message you want to display
    ),
    );
  }
   void _showAnimatedDialogDeleted() {
    showDialog(
      context: context,
       builder: (context) => const AnimatedDialog(
      icon: Icons.heart_broken, // Pass the icon you want to display
      message: 'Movie deleted from favorites!',
      color: Colors.red,  // Pass the message you want to display
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 2, 28, 70),
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('Movie not found', style: TextStyle(color: Colors.white)));
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
                            SizedBox(
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                
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
                                    icon:  const Icon(
                                      Icons.favorite,
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      size: 40,
                                    ),
                                    onPressed: () async {
                                      await DatabaseHelper().deleteFavoriteMovie(widget.movieId, userId);
                                      setState(() {
                                        isFavorite = false;
                                      });
                                     _showAnimatedDialogDeleted();
                                    },
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.favorite_border_outlined,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: () async {
                                      await DatabaseHelper().insertFavoriteMovie(widget.movieId, userId);
                                      setState(() {
                                        isFavorite = true;
                                      });
                                      _showAnimatedDialog();
                                    },
                                  ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              movie.duration,
                              style: const TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Roboto'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Year: ${movie.year}',
                          style: const TextStyle(fontSize: 14.0, color: Colors.white, fontFamily: 'Roboto'),
                        ),
                        const SizedBox(height: 2.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: genres
                              .map((genre) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(color: const Color.fromARGB(255, 71, 64, 64), width: 1.0),
                                    ),
                                    child: Text(
                                      genre.name,
                                      style: const TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Roboto'),
                                    ),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          movie.plot,
                          style: const TextStyle(fontSize: 16.0, color: Colors.white,  fontFamily: 'Roboto'),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Producers:',
                          style: TextStyle(fontSize: 16.0, color: Colors.white,  fontFamily: 'Roboto'),
                        ),
                        const SizedBox(height: 8.0),
                        _buildProducers(producers),
                        const SizedBox(height: 8.0),
                        const Text(
                          'Actors:',
                          style: TextStyle(fontSize: 16.0, color: Colors.white,  fontFamily: 'Roboto'),
                        ),
                        const SizedBox(height: 16.0),
                        _buildActors(actors),
                        const SizedBox(height: 16.0),
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
        SizedBox(
          height: 150, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: producers.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _showProducerInfoDialog(context, producers[index]);
                },
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(producers[index].photoPath),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        producers[index].name,
                        style:const TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.2),
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
            padding: const EdgeInsets.only(top: 8.0, right: 8.0), 
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), 
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.topRight, 
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
                    const SizedBox(height: 10),
                    Text(
                      producer.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto'
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Center( 
                        child: Text(
                          '${producer.bio}',
                          textAlign: TextAlign.center, 
                          style: const TextStyle(fontSize: 16, fontFamily: 'Roboto'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon:  const Icon(Icons.close),
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
    return SizedBox(
      height: 175,
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
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(actor.photoPath),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        actor.name,
                        style: const TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                      const SizedBox(height: 5.0),
                      FutureBuilder<Role>(
                        future: DatabaseHelper().getRoleForMovieActor(widget.movieId, actor.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData) {
                            return const Text('Role not found');
                          } else {
                            return Text(
                              snapshot.data!.name,
                              style: const TextStyle(fontSize: 12.0),
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

