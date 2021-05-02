// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/User.dart';
import './myWidgets/UserCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import './myWidgets/popUpDialog.dart';

void main() => runApp(MaterialApp(home:MyApp()));

Future<User> fetchUser() async {

  final http.Response response = await http.get("https://gorest.co.in/public-api/users/1");

    var tmp = json.decode(response.body);

    return User.fromJson(tmp['data']);
  
}



class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('User App'),
        ),
        body: FavouriteWidget(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
            //   showDialog(
            //   context: context,
            //   builder: (BuildContext context) => PopUpDialog(context:context,user:null),
            //  );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ), 
      ),
    );
  }
}

List<User> parseUsersList(String body){
  var response = json.decode(body);
  var data = response["data"] as List;
  return data.map<User>((json) => User.fromJson(json)).toList();
}

Future < List<User>> fetchUserList(int page) async{
  
  final http.Response response = await http.get("https://gorest.co.in/public-api/users?page=${page}");
  return compute(parseUsersList,response.body);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() =>_MyAppState();
}
class FavouriteWidget extends StatefulWidget{
  @override
  _FavouriteWidgetState createState() =>_FavouriteWidgetState();
}
class _FavouriteWidgetState extends State<FavouriteWidget>{
  int _pageNo = 1;
  Future<List<User>> _futureUserList ;
  var cachedUserList = <int, Future<List<User>>>{};

  @override
  void initState() {
    super.initState();

    // initial load
     _futureUserList = fetchUserList(1);
     cachedUserList[1]=_futureUserList;
  }

  void nextPage(){
    setState(() {
      _pageNo+=1;
      if(cachedUserList[_pageNo]!=null)
      {
        _futureUserList=cachedUserList[_pageNo];
      }
      else
      {
        _futureUserList =fetchUserList(_pageNo);
        cachedUserList[_pageNo]=_futureUserList;
      }
    });
  }
  
  void previousPage()
  {
    setState(() {
      if(_pageNo>1)
      {
        _pageNo-=1;
        if(cachedUserList[_pageNo]!=null)
        {
          _futureUserList=cachedUserList[_pageNo];
        }
        else
        {
          _futureUserList =fetchUserList(_pageNo);
          cachedUserList[_pageNo]=_futureUserList;
        }
      }
    });
  }

  void changePage(int page)
  {
     setState(() {
      _pageNo=page;
      if(cachedUserList[_pageNo]!=null)
      {
        _futureUserList=cachedUserList[_pageNo];
      }
      else
      {
        _futureUserList =fetchUserList(_pageNo);
        cachedUserList[_pageNo]=_futureUserList;
      }
    });
  }

  void _refreshPage(){
    setState(() {
        _futureUserList =fetchUserList(_pageNo);
        cachedUserList[_pageNo]=_futureUserList;
    });
  }
  @override
  Widget build(BuildContext context)
  {
    return new FutureBuilder<List<User>>(
          future: _futureUserList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return RefreshIndicator( 
                  child:ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed:previousPage
                            ),
                            Text('Pages    '),
                            Text(
                              '${_pageNo}',
                              style: TextStyle(color:Colors.blue[800],fontWeight: FontWeight.w900,fontSize: 20) ,
                              ),
                            new GestureDetector(
                              child: Text('${_pageNo+1}'),
                              onTap:(){ changePage(_pageNo+1); },
                            ),
                            new GestureDetector(
                              child: Text('${_pageNo+2}'),
                              onTap:(){ changePage(_pageNo+2);},
                            ),
                            new GestureDetector(
                              child: Text('${_pageNo+3}'),
                              onTap:(){ changePage(_pageNo+3);},
                            ),
                            new GestureDetector(
                              child: Text('${_pageNo+4}'),
                              onTap:(){ changePage(_pageNo+4);},
                            ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed:nextPage
                            ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: MediaQuery.of(context).size.width,
                        child: new ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder:(context,index){
                            return UserCard(context:context,user:snapshot.data[index],callback:(val){
                              cachedUserList[_pageNo].then((value) => {
                                for(int i=0;i<value.length;i++)
                                {
                                  if(value[i].id==val.id)
                                  {
                                    value[i]=val
                                  }
                                },
                                cachedUserList[_pageNo] = Future<List<User>>.value(value)
                              });
                            });
                          }
                        ),
                      ),
                    ],
                  ),
                  onRefresh:()async{ _refreshPage();},
                );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
            }
            // By default, show a loading spinner.
            return Center(child:CircularProgressIndicator());
          },
        );
  }
}