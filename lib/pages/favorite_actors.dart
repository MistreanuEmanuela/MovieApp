import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../user_preferinces.dart';
import '../models/actor.dart';
import './actor_page.dart';

class FavoriteActorsPage extends StatefulWidget {
  @override
  _FavoriteActorsPageState createState() => _FavoriteActorsPageState();
}

class _FavoriteActorsPageState extends State<FavoriteActorsPage> {
  late int userId;
  late Future<List<Actor>> _actorsFuture;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    UserPreferences.getUserId().then((value) {
      setState(() {
        userId = value!;
        _actorsFuture = _fetchActors();
      });
    });
  }

  Future<List<Actor>> _fetchActors() async {
    return _databaseHelper.getFavoriteActorsForUser(userId);
  }

  Widget _buildActorList() {
    return FutureBuilder<List<Actor>>(
      future: _actorsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center( child: const  CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white)));
        } else {
          final actors = snapshot.data!;
          return ListView.builder(
            itemCount: actors.length,
            itemBuilder: (context, index) {
              return ActorItem(actor: actors[index]);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie App'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Settings':
                  // Navigate to Settings page
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                  break;
                case 'About':
                  // Navigate to About page
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
                  break;
                // Add more cases for additional menu items
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              PopupMenuItem<String>(
                value: 'About',
                child: Text('About'),
              ),
              // Add more PopupMenuItems for additional menu options
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/first_page.jpg'),
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
                Expanded(child: _buildActorList()),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActorPage(actorId: actor.id!),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
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
                    actor.photoPath,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 200,
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
                    actor.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
