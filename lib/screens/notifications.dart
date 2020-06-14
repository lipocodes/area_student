import 'package:flutter/material.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:flutter/cupertino.dart';


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveNotifications().then((value) {
      setState(() {
          

      });
    });
    
  }

  @override
  Widget build(BuildContext context) {

  // if(notificationCreationTime == null || notificationCreationTime.length == 0 ) return Container();

    return Scaffold(
             appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
           title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              new Text(
                "Notifications",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 24),
              ),
           
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body:notifications(), //it is in widgets.dart
    );
  }
}



