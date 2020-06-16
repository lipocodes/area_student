import 'package:flutter/material.dart';
import 'package:areastudent/tools/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

 List<int> filteredUser;

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




  searchUsers() {
  
   String  searchText = convertUpperCase(controllerSearchUsers.text);
   filteredUser = []; 
 

  for(int i=0; i<notificationCreatorName.length; i++){
    String str = notificationCreatorName[i];
    if(str.contains(searchText)){
      filteredUser.add(i);
    }
  }

  retrieveNotifications().then((value) {
      setState(() {
          

      });
    });
}




Widget notifications() {
  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      color: Colors.black,
    ),
    itemCount: notificationIcon.length,
    itemBuilder: (context, index) {
    
        return GestureDetector(
          onTap: () {
            onTapNotification(index, context);
          },
          child: Column(
            children: [
              if(index==0) TextField(
                controller: controllerSearchUsers,
                onChanged: (r) {searchUsers();},
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Look for someone...'),
              ),
              if(controllerSearchUsers.text.length==0 || filteredUser.contains(index)) Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  new Container(
                    width: 64.0,
                    height: 64.0,
                    child: CachedNetworkImage(
                      imageUrl: notificationIcon[index],
                      imageBuilder: (context, imageProvider) => Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(notificationCreatorName[index],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Row(
                        children: [
                          Text(notificationOperation[index],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 10.0),
                  SizedBox(
                    width: 40.0,
                    child: Text(
                      timestampToTimeGap(notificationCreationTime[index]),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
    },
  );
}




}



