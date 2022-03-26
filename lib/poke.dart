import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemoninfo/pokemon.dart';
import 'dart:convert';
import 'main.dart';

class Poke extends StatefulWidget {
  const Poke({Key? key}) : super(key: key);

  @override
  State<Poke> createState() => _PokeState();
}

class _PokeState extends State<Poke> {
  List<Pokemon> loadedpoke = [];
  void getData() async {
    var res = await http.get(Uri.parse(url));
    var decodedJson = jsonDecode(res.body);
    if (decodedJson['pokemon'] != null) {
      setState(() {
        for (Map pok in decodedJson['pokemon']) {
          loadedpoke.add(new Pokemon(
            name: pok['name'],
            image: pok['img'],
            weight: pok['weight'],
            height: pok['height'],
            candy: pok['candy'],
          ));
        }
      });
    }
  }

  List<Pokemon> _foundUsers = []; //This is mainly used for searching.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    _foundUsers = loadedpoke;
  }

  void _runFilter(String enteredKeyword) {
    List<Pokemon> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = loadedpoke;
    } else {
      results = loadedpoke
          .where((user) =>
              user.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokedex"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) => _runFilter(value),
                      decoration: const InputDecoration(
                          labelText: 'Search', suffixIcon: Icon(Icons.search)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: _foundUsers.isNotEmpty
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              child: GridView.builder(
                                padding: EdgeInsets.all(10),
                                itemBuilder: (_, i) => Hero(
                                  tag: _foundUsers[i].image,
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      _foundUsers[i].image))),
                                        ),
                                        Text(
                                          _foundUsers[i].name,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Height: " + _foundUsers[i].height,
                                        ),
                                        Text(
                                          "Weight: " + _foundUsers[i].weight,
                                        ),
                                        Text(
                                          "Candy: " + _foundUsers[i].candy,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                itemCount: _foundUsers.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, //Row elements
                                  childAspectRatio:
                                      0.5, //Space between the elements
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                              ),
                            )
                          : const Text(
                              'No results found',
                              style: TextStyle(fontSize: 24),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
