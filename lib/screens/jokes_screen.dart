import 'package:flutter/material.dart';
import 'package:random_jokes_lab/models/joke.dart';
import 'package:random_jokes_lab/screens/favorite_jokes_screen.dart';
import 'package:random_jokes_lab/services/api_service.dart';
import '../widgets/jokes/jokes_body.dart';

class JokesScreen extends StatefulWidget {
  final String category;

  const JokesScreen({super.key, required this.category});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  late Future<List<Joke>> jokesFuture;
  late String currentCategory;
  List<Joke> favoriteJokes = [];

  @override
  void initState() {
    super.initState();
    currentCategory = widget.category;
    jokesFuture = ApiService.fetchJokes(currentCategory);
  }

  @override
  void didUpdateWidget(covariant JokesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category) {
      setState(() {
        currentCategory = widget.category;
        jokesFuture = ApiService.fetchJokes(currentCategory);
      });
    }
  }

  void toggleFavorite(Joke joke) {
    setState(() {
      if (favoriteJokes.contains(joke)) {
        favoriteJokes.remove(joke);
      } else {
        favoriteJokes.add(joke);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes: ${widget.category}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoriteJokesScreen(favoriteJokes: favoriteJokes),
                ),
              );
            },
          ),
        ],
      ),
      body: JokesBody(
        jokesFuture: jokesFuture,
        onFavoriteToggle: toggleFavorite,
        favoriteJokes: favoriteJokes,
      ),
    );
  }
}
