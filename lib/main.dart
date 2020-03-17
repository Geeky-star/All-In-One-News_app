import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news_app/Model/model.dart';
import 'package:news_app/article_screen.dart';

String API_KEY = 'c7a316f97f7b4a7093e1ce592efed381';
Future<List<Source>> fetchNewsSource() async{
  final response = await http.get('http://newsapi.org/v2/sources?apiKey=${API_KEY}');
  if(response.statusCode == 200)
    {
      List sources = jsonDecode(response.body)['sources'];
        return sources.map((source) => new Source.fromJson(source)).toList();
    }
  else
    {
      throw Exception('Failed to load source list');
    }
}
void main() => runApp(new SourceScreen());

class SourceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SourceScreenState();
}

class SourceScreenState extends State<SourceScreen>{

  var list_sources;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState(){
    super.initState();
    refreshListSource();
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'DAILY NEWS',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FutureBuilder<List<Source>>(
            future: list_sources,
            builder: (context, snapshot){
              if(snapshot.hasError)
                {
                  return Text('Error: ${snapshot.error}');
                }
              else if(snapshot.hasData){
                List<Source> sources = snapshot.data;
                return new ListView(
                  children: sources.map((source)=> GestureDetector(
                    onTap: () {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleScreen(source:source)));

                    },
                    child: Card(
                      elevation: 1.0,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            width: 100.0,
                            height: 140.0,
                            child: Image.asset("assets/news.png"),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                                        child: Text('${source.name}',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                      ),
                                    )
                                  ],
                                ),

                                Container(
                                  child: Text('${source.description}',style: TextStyle(color: Colors.grey, fontSize: 15.0,fontWeight: FontWeight.bold),),
                                ),

                                Container(
                                  child: Text('category: ${source.category}',style: TextStyle(color: Colors.blue, fontSize: 18.0,fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ),
                          )
                        ],

                      ),
                    ),
                  )
                  ).toList()
                );
              }

              return CircularProgressIndicator();
            },
          )
        ),
      ),
    );

   }

   Future<Null> refreshListSource() async {
    refreshKey.currentState?.show(atTop: false);

    setState(() {
      list_sources = fetchNewsSource();
    });

    return null;
   }
}
