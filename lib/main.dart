import 'package:flutter/material.dart';
import 'package:pokemoninfo/poke.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(SplashScreen());
}

var url =
    "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, //For removing the debug bar
        home: AnimatedSplashScreen(
          animationDuration: Duration(milliseconds: 300),
          splash: Container(
            child: Image.asset(
              "assets/images/pikachu.png",
              fit: BoxFit.cover,
            ),
          ),
          nextScreen: MyApp(),
          splashTransition: SplashTransition.scaleTransition,
        ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Poke(),
    );
  }
}
