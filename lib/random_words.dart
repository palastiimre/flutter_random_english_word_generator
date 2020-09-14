import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPairs = <WordPair>[];
  final _saveWordPairs = Set<WordPair>();

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              final Iterable<ListTile> tiles =
              _saveWordPairs.map((WordPair pair) {
                return ListTile(
                  title: Text(pair.asPascalCase, style: TextStyle
                    (fontSize: 16.0))
                );
              });
              final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles
              ).toList();

              return Scaffold(
                appBar: AppBar(
                  title: Text('Mentett szópárok'),
                ),
                body: ListView(children: divided));
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Véletlen angol szópár generátor'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) return Divider();

        final index = item ~/ 2;

        if (index >= _randomWordPairs.length) {
          _randomWordPairs.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_randomWordPairs[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saveWordPairs.contains(pair);

    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        trailing: Icon(
            alreadySaved ? Icons.check_circle : Icons.check_circle_outline,
            color: alreadySaved ? Colors.green : null),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saveWordPairs.remove(pair);
            } else {
              _saveWordPairs.add(pair);
            }
          });
        });
  }
}
