import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'details_film.dart';

class MovieList extends StatefulWidget {
  @override
  MovieListState createState() {
    return new MovieListState();
  }
}

class MovieListState extends State<MovieList> {
  var movies;
  Color mainColor = const Color(0xff3C3261);

  void getData() async {
    var data = await getJson();

    setState(() {
      movies = data['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Movies',
        ),
        actions : <Widget>[
         IconButton(
             tooltip: 'Recherche',
             icon: Icon(Icons.search),
             onPressed: () async{
                     //Afficher les recherches précédentes
              await showSearch<String>(
                context: context, 
                delegate: null,
                );
                        },
           )
         ]
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new ListView.builder(
                  itemCount: movies == null ? 0 : movies.length,
                  itemBuilder: (context, i) {
                    return new FlatButton(
                      child: new MovieCell(movies, i), 
                      onPressed: () {
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (context) {
                          return new MovieDetail(movies[i]);
                        }));
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

Future<Map> getJson() async {
  var url = 'http://api.themoviedb.org/3/discover/movie?api_key=1f8ca33b93455690dc16d76243cbb877';
  var response = await http.get(url);
  return json.decode(response.body);
}


class MovieCell extends StatelessWidget {
  final movies;
  final i;
  Color mainColor = const Color(0xff3C3261);
  var image_url = 'https://image.tmdb.org/t/p/w500/';
  MovieCell(this.movies, this.i);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(0.0),
              child: new Container(
                margin: const EdgeInsets.all(16.0),
//        child: new Image.network(image_url+movies[i]['poster_path'],width: 100.0,height: 100.0),
                child: new Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.grey,
                  image: new DecorationImage(
                      image: new NetworkImage(
                          image_url + movies[i]['poster_path']),
                      fit: BoxFit.cover),
                  boxShadow: [
                    new BoxShadow(
                        color: mainColor,
                        blurRadius: 5.0,
                        offset: new Offset(2.0, 5.0))
                  ],
                ),
              ),
            ),
            new Expanded(
                child: new Container(
              margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              child: new Column(
                children: [
                  new Text(
                    movies[i]['title'],
                    style: new TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Arvo',
                        fontWeight: FontWeight.bold,
                        color: mainColor),
                  ),
                  new Padding(padding: const EdgeInsets.all(2.0)),
                  new Text(
                    movies[i]['overview'],
                    maxLines: 3,
                    style: new TextStyle(
                        color: const Color(0xff8785A4), fontFamily: 'Arvo'),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )),
          ],
        ),
        
      ],
    );
  }
}


/*class _MySearchDelegate extends SearchDelegate<String>{
  final List<String> _words;
  final List<String> _history;
  _MySearchDelegate(List<String> _words)
  :_words=words,
   _history=<String>['ha','ho','hi'],
  super();

@override
  Widget buildLeading(BuildContext context) {
    
    return IconButton(
      tooltip: 'Retour',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        this.close(context, null);
        }
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    
    return <Widget>[
      query.isEmpty
       ? IconButton(
         tooltip: 'Recherche vocale',
         icon: const Icon(Icons.mic),
         onPressed: (){
           this.query='A faire ';//A FAIRE
         },
       )
      :IconButton(
        tooltip: 'Fermer',
        icon: const Icon(Icons.clear),
        onPressed: (){
          query='';
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
   
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child : Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('movies'),
            GestureDetector(
              onTap: (){
                this.close(context, this.query);
              },
              child: Text(
                this.query,
                style:Theme.of(context)
                  .textTheme
                  .display1
                  .copyWith(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );//show the movies
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = this.query.isEmpty
      ? _history
      : _words.where((word)=> word.startsWith(query));


    return _SuggestionList(
          query : this.query,
          suggestions:suggestions.toList(),
          onSelected:(String suggestion){
            this.query=suggestion;
            this._history.insert(0, suggestion);
            showResults(context);
          }
        );
      }
    
      
    }
    

class _SuggestionList extends StatelessWidget{
      const _SuggestionList({this.suggestions,this.query,this.onSelected});
      final List<String> suggestions;
      final String query;
      final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(

    );
  }

Widget buildItem(Movie movie){

       return new Column(
         children: <Widget>[
           ListTile(
            title:Text(movie.title, style: TextStyle(color: Theme.of(context).accentColor)),
            leading: CachedNetworkImage(imageUrl: "https://image.tmdb.org/t/p/w92${movie.poster_path}",
              placeholder: Icon(Icons.movie_creation),
              height: 60.0,
            ),
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>MovieDetailScreen(movie) )
              );

            },


      ),
           Divider()
         ]

       );
  }}*/