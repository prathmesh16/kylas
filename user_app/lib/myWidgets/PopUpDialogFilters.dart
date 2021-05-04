import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopUpDialogFilters extends StatefulWidget
{
  final BuildContext context;
  var callback;
  HashMap<String,String> filters;

  PopUpDialogFilters({this.context,this.callback,this.filters});

  @override
  _MyPopUpDialogFilters createState() => _MyPopUpDialogFilters(context: context,callback:callback,filters:filters);
}

class _MyPopUpDialogFilters extends State<PopUpDialogFilters>
{
  final BuildContext context;
  HashMap<String,String> filters;
  var callback;

_MyPopUpDialogFilters({this.context,this.callback,this.filters});

  String _genderFilter = "None";
  String _statusFilter = "None";
  @override
  void initState() {
    super.initState();
    // for(int i=0;i<filters.length;i++)
    // {
    //   if(filters[i][0]=="gender")
    //   {
    //     _genderFilter=filters[i][1];
    //   }
    //   if(filters[i][0]=="status")
    //   {
    //     _statusFilter=filters[i][1];
    //   }
    // }
    filters.forEach((key, value) {
      if(key == "status")
        _statusFilter=value;
      if(key == "gender")
        _genderFilter=value;  
    });
  }

  void handleGenderFilter(String value)
  {
    if(value == "None")
    {
      filters.remove("gender");
    }
    else
    {
      filters["gender"]=value;
    }
    setState(() {
      _genderFilter = value;
    });
  }
  
  void handleStatusFilter(String value)
  {
    if(value == "None")
    {
      filters.remove("status");
    }
    else
    {
      filters["status"]=value;
    }
    setState(() {
      _statusFilter = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
     title: const Text("Filters"),
     content: Container(
       width: MediaQuery.of(context).size.width,
       child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Gender"),
            Row(
              children: <Widget>[
                Radio<String>(
                    value: "Male",
                    groupValue: _genderFilter,
                    onChanged: (String value) {
                     handleGenderFilter(value);
                    },
                  ),
                Text('Male  ',style: TextStyle(
                  fontSize: 12
                ),),
                Radio<String>(
                    value: "Female",
                    groupValue: _genderFilter,
                    onChanged: (String value) {
                     handleGenderFilter(value);
                    },
                  ),
                Text('Female ',style: TextStyle(
                  fontSize: 12
                ),),
                Radio<String>(
                    value: "None",
                    groupValue: _genderFilter,
                    onChanged: (String value) {
                      handleGenderFilter(value);
                    },
                  ),
                Text('None',style: TextStyle(
                  fontSize: 12
                ),),
              ],
            ),
            Text("Status"),
            Row(
              children: <Widget>[
                Radio<String>(
                    value: "Active",
                    groupValue: _statusFilter,
                    onChanged: (String value) {
                      handleStatusFilter(value);
                      
                    },
                  ),
                Text('Active',style: TextStyle(
                  fontSize: 12
                ),),
                Radio<String>(
                    value: "Inactive",
                    groupValue: _statusFilter,
                    onChanged: (String value) {
                      handleStatusFilter(value);
                    },
                  ),
                Text('Inactive',style: TextStyle(
                  fontSize: 12
                ),),
                Radio<String>(
                    value: "None",
                    groupValue: _statusFilter,
                    onChanged: (String value) {
                      handleStatusFilter(value);
                    },
                  ),
                Text('None',style: TextStyle(
                  fontSize: 12
                ),),
              ],
            )
          ],
       ),
     ),
     actions:<Widget> [
       new TextButton(
          onPressed : (){
              callback(filters);
              Navigator.of(context).pop();
            },
          style: TextButton.styleFrom(
            primary:Theme.of(context).primaryColor
          ),
          child: const Text('Apply'),
        ),
        new TextButton(
          onPressed : (){
               Navigator.of(context).pop();
            },
          style: TextButton.styleFrom(
            primary:Theme.of(context).primaryColor
          ),
          child: const Text('Close'),
        ),
     ],
    ) ;
  }
} 