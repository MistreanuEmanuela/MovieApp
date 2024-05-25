import 'package:flutter/material.dart';
import './pages/register_page.dart'; 
import './pages/login_page.dart';
import './insert_data.dart';
import './pages/homepage.dart';
import './pages/movie_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 50, 10, 119)),
        useMaterial3: true,
          textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Roboto'),
          bodyMedium: TextStyle(fontFamily: 'Roboto'),
          headlineLarge: TextStyle(fontFamily: 'Roboto'),
          headlineMedium: TextStyle(fontFamily: 'Roboto'),
          headlineSmall: TextStyle(fontFamily: 'Roboto'),
          titleLarge: TextStyle(fontFamily: 'Roboto'),
          titleMedium: TextStyle(fontFamily: 'Roboto'),
          titleSmall: TextStyle(fontFamily: 'Roboto'),
          labelLarge: TextStyle(fontFamily: 'Roboto'),
          labelMedium: TextStyle(fontFamily: 'Roboto'),
          labelSmall: TextStyle(fontFamily: 'Roboto'),
          bodySmall: TextStyle(fontFamily: 'Roboto'),
          displayLarge: TextStyle(fontFamily: 'Roboto'),
          displayMedium: TextStyle(fontFamily:  'Roboto'),
          displaySmall: TextStyle(fontFamily: 'Roboto'),
        ),
      ),
      home: const MyHomePage(title: 'Movie App'),
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/homepage': (context) => HomePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/moviepage') {
          final args = settings.arguments as MoviePageArguments;
          return MaterialPageRoute(
            builder: (context) {
              return MoviePage(movieId: args.movieId);
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    initializeApp();
  }


  void initializeApp() async {
    // await insertInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/first_page.png'),
            fit: BoxFit.cover,
          ),
        ),
        
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "DON'T WAIT",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Find the best movie to watch",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ShrikhandRegular',
                      color: Color.fromARGB(255, 175, 175, 175),
                    ),
                  ),
                  const SizedBox(height: 80), 
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                        child: const Text('LOGIN', style: TextStyle(fontSize: 20, fontFamily: 'Roboto')), 
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, 
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.yellow, width: 2), // Add border color
                          padding: const EdgeInsets.symmetric(vertical: 15.0), // Increase padding
                        ),
                        child: const Text(
                          'REGISTER',
                          style: TextStyle(fontSize: 20, color: Colors.yellow, fontFamily: 'Roboto'), // Increase font size and change text color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoviePageArguments {
  final int movieId;

  MoviePageArguments(this.movieId);
}
