import 'package:flutter/material.dart';
import '../models/User.dart';
import './PopUpDialog.dart';


class UserCard extends StatefulWidget{
  User user;
  BuildContext context;
  var callback;

  UserCard({this.context,this.user,this.callback});
  @override
  _MyUserCard createState() => _MyUserCard(homeContext:context,user: user,callback:callback);
}
class _MyUserCard extends State<UserCard>
{
  BuildContext homeContext;
  User user;
  var callback;
  _MyUserCard({this.homeContext,this.user,this.callback});
  
  String limitName(String name)
  {
      if(name.length>23)
        return name.substring(0,23)+"...";
      return name;  
  }

  String limitEmail(String email)
  {
      if(email.length>35)
        return email.substring(0,35)+"...";
      return email;  
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(0, 5),
              blurRadius: 3.0,
              spreadRadius: 1.0,
            ),
          ],
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(
        //   color: Colors.grey[300],
        //   width: 1,
        // ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left:30),
                child: Text(
                  limitName('${user.name}'),
                  style: TextStyle(fontSize: 20),
                )
              ),    
              Row(
                children: [
                  IconButton(
                    iconSize: 20,
                    icon: Icon(Icons.info_outline,color: Colors.grey[500]),
                    alignment: Alignment.centerRight,
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert,color: Colors.grey[700],),
                      onPressed:(){ 
                        showDialog(
                        context: homeContext,
                        builder: (BuildContext context) => PopUpDialog(context:context,user: user,callback: (updatedUser){
                          setState((){
                            user=updatedUser;
                            callback(updatedUser);
                          });
                        }),
                      );
                      }
                    ),
                ],
              ),    
            ],
          ),
          Container(
            margin: EdgeInsets.only(left:30),
            alignment: AlignmentDirectional.centerStart,
            child: Text(limitEmail('${user.email}'))
            ),
          Container(
            margin: EdgeInsets.only(top:10,left: 30,right:30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${user.gender}'),
                Row(
                  children: [
                    Text('${user.status}'),
                    Container(
                      height: 10,
                      width: 10,
                      margin: EdgeInsets.only(left:10),
                      decoration: BoxDecoration(
                        color:(user.status=="Active")?Colors.green:Colors.red,
                        borderRadius: BorderRadius.circular(5) 
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}