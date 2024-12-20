import 'package:flutter/material.dart';
import 'package:random_jokes_lab/models/joke.dart';

class JokesBody extends StatelessWidget {
  final Future<List<Joke>> jokesFuture;
  final Function(Joke) onFavoriteToggle;
  final List<Joke> favoriteJokes;

  const JokesBody({
    super.key,
    required this.jokesFuture,
    required this.onFavoriteToggle,
    required this.favoriteJokes,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Joke>>(
      future: jokesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No jokes found.'));
        } else {
          final jokes = snapshot.data!;
          return ListView.builder(
            itemCount: jokes.length,
            itemBuilder: (context, index) {
              final joke = jokes[index];
              final isFavorite = favoriteJokes.contains(joke);
              return ListTile(
                title: Text(joke.punchline),
                trailing: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () => onFavoriteToggle(joke),
                ),
              );
            },
          );
        }
      },
    );
  }
}
