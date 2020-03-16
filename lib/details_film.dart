import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class MovieDetail extends StatelessWidget {
  final movie;
  var image_url = 'https://image.tmdb.org/t/p/w500/';
  MovieDetail(this.movie);
  Color mainColor = const Color(0xff3C3261);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(fit: StackFit.expand, children: [
        new Image.network(//charge une image a partir d'un url
          image_url + movie['poster_path'],
          fit: BoxFit.cover,//place l'image sur tout l'ecran du tel
        ),
        new BackdropFilter(
          filter: new ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),//creates an image filter
          child: new Container(
            color: Colors.black.withOpacity(0.5),//change l'opacité de la photo
          ),
        ),
        new SingleChildScrollView(
          child: new Container(
            margin: const EdgeInsets.all(20.0),
            child: new Column(
              children: <Widget>[
                new Container(
                  alignment: Alignment.center,
                  child: new Container(
                    width: 400.0,
                    height: 400.0,
                  ),
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(10.0),
                      image: new DecorationImage(
                          image: new NetworkImage(
                              image_url + movie['poster_path']),
                          fit: BoxFit.cover),
                      boxShadow: [//met la photo dans le box et emmet une ombre pour le box 
                        new BoxShadow(
                            color: Colors.black,
                            blurRadius: 20.0,
                            offset: new Offset(0.0, 10.0))
                      ]),
                ),
                new Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 0.0),
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                          child: new Text(
                        movie['title'],//affiche le titre du film
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                            fontFamily: 'Arvo'),
                      )
                      ),
                      new Text(
                        '${movie['vote_average']}/10',//affiche le rating
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontFamily: 'Arvo'),
                      )
                    ],
                  ),
                ),
                new Text(movie['overview'],style: new TextStyle(color: Colors.white, fontFamily: 'Arvo')),//affiche le descriptif
              ],
            ),
          ),
        )
      ]),
    );
  }
}