import 'package:autism_test_drag_drop/appcore/services/autism_game_provider.dart';
import 'package:autism_test_drag_drop/ui/pages/autism_page_game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main(List<String> args) {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_)=>AutismGameProvider())],
    child: MaterialApp(
      initialRoute: "/",
      routes: {'/': (_) =>  AutismPageGame()},
    
      theme: ThemeData(
        scaffoldBackgroundColor:  Colors.white,
          fontFamily: "Rubik",
           primarySwatch: Colors.blue,
         primaryColor: Colors.blue)
    
    ),
  ));
}
