import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/User.dart';
import './myWidgets/UserCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import './myWidgets/PopUpDialogAddUser.dart';

void main() => runApp(MaterialApp(home:MyApp()));

//converting response data into json list
List<User> parseUsersList(String body){
  var response = json.decode(body);
  var data = response["data"] as List;
  return data.map<User>((json) => User.fromJson(json)).toList();
}

//GET request to fetch users list
Future < List<User>> fetchUserList(int page) async{
  
  final http.Response response = await http.get("https://gorest.co.in/public-api/users?page=${page}");
  return compute(parseUsersList,response.body);
}
//Application 
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() =>_MyAppState();
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
        body: MainScreen(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
              context: context,
              builder: (BuildContext context) => PopUpDialogAddUser(context:context),
             );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ), 
      ),
    );
  }
}

//MainScreen (Scroll View with paging and users data)
class MainScreen extends StatefulWidget{
  @override
  _MainScreenState createState() =>_MainScreenState();
}
class _MainScreenState extends State<MainScreen>{
  int pageNo = 1;
  int totalPages ;
  Future<List<User>> _futureUserList ;

  //storage to cache users data
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
      pageNo+=1;
      if(cachedUserList[pageNo]!=null)
      {
        _futureUserList=cachedUserList[pageNo];
      }
      else
      {
        _futureUserList =fetchUserList(pageNo);
        cachedUserList[pageNo]=_futureUserList;
      }
    });
  }
  
  void previousPage()
  {
    setState(() {
      if(pageNo>1)
      {
        pageNo-=1;
        if(cachedUserList[pageNo]!=null)
        {
          _futureUserList=cachedUserList[pageNo];
        }
        else
        {
          _futureUserList =fetchUserList(pageNo);
          cachedUserList[pageNo]=_futureUserList;
        }
      }
    });
  }

  void changePage(int page)
  {
     setState(() {
      pageNo=page;
      if(cachedUserList[pageNo]!=null)
      {
        _futureUserList=cachedUserList[pageNo];
      }
      else
      {
        _futureUserList =fetchUserList(pageNo);
        cachedUserList[pageNo]=_futureUserList;
      }
    });
  }

  void _refreshPage(){
    setState(() {
        _futureUserList =fetchUserList(pageNo);
        cachedUserList[pageNo]=_futureUserList;
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
                      //Paging Row implementation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed:previousPage
                            ),
                            Text('Pages    '),
                            Container(
                              height: 28,
                              width: 25,
                              child: Text(
                                '${pageNo}',
                                style: TextStyle(color:Colors.blue[800],fontWeight: FontWeight.w900,fontSize: 20) ,
                                ),
                            ),
                            new GestureDetector(
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Text('${pageNo+1}')
                                ),
                              onTap:(){ changePage(pageNo+1); },
                            ),
                            new GestureDetector(
                             child: Container(
                                height: 20,
                                width: 20,
                                child: Text('${pageNo+2}')
                                ),
                              onTap:(){ changePage(pageNo+2);},
                            ),
                            new GestureDetector(
                             child: Container(
                                height: 20,
                                width: 20,
                                child: Text('${pageNo+3}')
                                ),
                              onTap:(){ changePage(pageNo+3);},
                            ),
                            new GestureDetector(
                              child: Container(
                                height: 20,
                                width: 20,
                                child: Text('${pageNo+4}')
                                ),
                              onTap:(){ changePage(pageNo+4);},
                            ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed:nextPage
                            ),
                        ],
                      ),
                      //ListView of users data
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        width: MediaQuery.of(context).size.width,
                        child: new ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder:(context,index){
                            return UserCard(context:context,user:snapshot.data[index],callback:(val){
                              cachedUserList[pageNo].then((value) => {
                                for(int i=0;i<value.length;i++)
                                {
                                  if(value[i].id==val.id)
                                  {
                                    value[i]=val
                                  }
                                },
                                cachedUserList[pageNo] = Future<List<User>>.value(value)
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