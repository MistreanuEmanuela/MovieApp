import 'package:flutter/material.dart';
import '../models/actor.dart';
import '../helpers/database_helper.dart';
import '../models/movie.dart';
import '../user_preferinces.dart'; // Fixed import path
import '../pages/movie_page.dart';
import '../widgets/animated_dialog.dart';
import '../pages/favorite_items_page.dart';
import '../pages/search_page.dart';

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
  final ScrollController _scrollController = ScrollController();
  double _bottomContainerHeight = 0;

  @override
  void initState() {
    super.initState();
    UserPreferences.getUserId().then((value) {
      setState(() {
        userId = value!;

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
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        showBibliography = false;
      });
    }
  }
  void _showAnimatedDialog() {
    showDialog(
      context: context,
       builder: (context) => AnimatedDialog(
      icon: Icons.favorite, 
      message: 'Actor added to favorites!',
      color: Colors.red, 
    ),
    );
  }
   void _showAnimatedDialogDeleted() {
    showDialog(
      context: context,
       builder: (context) => AnimatedDialog(
      icon: Icons.heart_broken,
      message: 'Actor deleted from favorites!',
      color: Colors.red,  
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
            controller: _scrollController,
            child: FutureBuilder<Actor>(
              future: DatabaseHelper().getActorById(widget.actorId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('Actor not found'));
                } else {
                  final Actor actor = snapshot.data!;
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.black.withOpacity(0.0), 
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: isFavorite
                                ? const Icon(
                                    Icons.favorite,
                                    color: Color.fromARGB(255, 255, 0, 0),
                                    size: 40,
                                  )
                                : const Icon(
                                    Icons.favorite_border_outlined,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                            onPressed: () async {
                              if (isFavorite) {
                                await DatabaseHelper().deleteFavoriteActor(widget.actorId, userId);
                              } else {
                                await DatabaseHelper().insertFavoriteActor(widget.actorId, userId);
                              }
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                              if (isFavorite){
                                _showAnimatedDialog();
                              }
                               else{
                                _showAnimatedDialogDeleted();
                              }
                            },
                          ),
                        ),
                        Center(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage(actor.photoPath),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: Text(
                            actor.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                             const  Icon(Icons.person, color: Colors.white, size: 18),
                            const SizedBox(width: 4.0),
                            Text(
                              'Bio: ${actor.bio}',
                              style: const TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        const Row(
                          children: [
                            Icon(Icons.cake, color: Colors.white, size: 18),
                            SizedBox(width: 4.0),
                            Text(
                              'Birthdate: ${'22.22.22'}', // Assuming actor.birthdate contains the birthdate information
                              style: TextStyle(fontSize: 16.0, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Movies:',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 8.0),
                        FutureBuilder<List<Movie>>(
  future: DatabaseHelper().getMoviesForActor(widget.actorId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No movies found', style: TextStyle(color: Colors.white)));
    } else {
      final movies = snapshot.data!;
      return Container(
        constraints: const BoxConstraints(maxHeight: 270),
        child: SingleChildScrollView( 
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoviePage(movieId: movies[index].id!),
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
                              movies[index].year.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              width: 8,
                              height: 8,
                              decoration:const  BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                movies[index].title,
                                style: const TextStyle(fontSize: 16.0, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index != movies.length - 1)
                    const Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(color: Colors.white),
                    ),
                ],
              );
            },
          ),
        ),
      );
    }
  },
),
  
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            bottom: showBibliography ? 0 : -_bottomContainerHeight,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * (showBibliography ? 0.7 : 0.065), // Adjust height based on showBibliography
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showBibliography = !showBibliography;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: showBibliography ? Colors.white.withOpacity(1.0) : Colors.white.withOpacity(0.2),
                  borderRadius:const  BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                padding: EdgeInsets.fromLTRB(16.0, showBibliography ? 0.0 : 0.0, 16.0, showBibliography ? 0.0 : 0.0),
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
                    const SizedBox(height: 8.0),
                    Expanded(
                      child: AnimatedOpacity(
                        duration:const  Duration(milliseconds: 300),
                        opacity: showBibliography ? 1.0 : 0.0,
                        child: const SingleChildScrollView( // Add SingleChildScrollView
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