import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import './pages/register_page.dart'; // Import the register page
import './pages/login_page.dart';
import './insert_data.dart';
import './pages/homepage.dart';
import './pages/movie_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    routes: {
        '/register': (context) => RegisterPage(), // Add route for register page
        '/login':(context) => LoginPage(),
         '/homepage':(context) => HomePage(),
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
 @override
  void initState() {
    super.initState();
    initializeApp(); // Call initializeApp() when the widget is initialized
  }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
void initializeApp() async {
  await insertInitialData();
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
    ),
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/first_page.png'), // Path to your background image
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           
            SizedBox(height: 20), // Adding some spacing between elements
              SizedBox(height: 20), // Adding some spacing between elements
            SizedBox(
          width: MediaQuery.of(context).size.width * 0.6, // Making the button 60% width
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0), // Adding vertical padding
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login'); // Navigate to register page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Setting the button color to yellow
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0), // Adding vertical padding inside the button
                child: Text('SING UP', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ),
            SizedBox(height: 20), // Adding some spacing between elements
            SizedBox(
          width: MediaQuery.of(context).size.width * 0.6, // Making the button 60% width
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0), // Adding vertical padding
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register'); // Navigate to register page
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow, // Setting the button color to yellow
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0), // Adding vertical padding inside the button
                child: Text('SING IN', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ),
          ],
        ),
      ),
    ),

  );
}
}

class MoviePageArguments {
  final int movieId;

  MoviePageArguments(this.movieId);
}