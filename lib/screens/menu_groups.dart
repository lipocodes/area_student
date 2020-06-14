import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:areastudent/tools/methods.dart';
import 'group.dart';
import 'meet.dart';
import 'chats.dart';
import 'package:areastudent/tools/widgets.dart';
import 'notifications.dart';

class MenuGroups extends StatefulWidget {
  @override
  _MenuGroupsState createState() => _MenuGroupsState();
}

class _MenuGroupsState extends State<MenuGroups> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  int indexBottomBar = 0;
  String uid;
  List<String> nameGroup = [];
  List<String> descriptionGroup = [];
  List<String> iconGroup = [];
  List<List<String>> postsGroup = [];
  List<List<String>> membersGroup = [];

  Future<String> inputData() async {
    try {
      final FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String uid = user.uid.toString();
      return uid;
    } catch (e) {
      return "";
    }
  }

  Future retrieveMenuData() async {
    this.uid = await inputData();
    final QuerySnapshot result =
        await Firestore.instance.collection('groups').getDocuments();
    final List<DocumentSnapshot> snapshot = result.documents;
    for (int i = 0; i < snapshot.length; i++) {
      nameGroup.add(snapshot[i].data['name']);
      descriptionGroup.add(snapshot[i].data['description']);
      iconGroup.add(snapshot[i].data['icon']);

      List<dynamic> str1 = snapshot[i].data['members'];
      List<dynamic> str11 = snapshot[i].data['postsCreationTime'];
    
      List<String> str2 = [];
      List<String> str22 = [];
      for (int i = 0; i < str1.length; i++) {
        str2.add(str1[i].toString());
      }
      membersGroup.add(str2);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String whichGroup = snapshot[i].data['name'].toString();
      int lastVisitGroup =  prefs.getInt(whichGroup);
  

      str1 = snapshot[i].data['posts'];
      str2 = [];
      for(int i=0; i<str11.length; i++){
        str22.add(str11[i].toString());
      }
      for (int i = 0; i < str1.length; i++) {    
        //if(int.parse(str22[i]) > lastVisitGroup){
          //print("ttttttttttttttttttttt= " + str22[i].toString() +  " " + lastVisitGroup.toString());
            str2.add(str1[i].toString());
        //}
      
       
        
      }
      
      postsGroup.add(str2);

      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveMenuData();
  }

  @override
  Widget build(BuildContext context) {
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
              "Groups",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 24),
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_none,
                size: 40,
              ),
              color: Colors.black87,
              onPressed: () {
                 Navigator.of(context).push(new CupertinoPageRoute(
                  builder: (BuildContext context) => new Notifications())); 
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // this will be set when a new tab is tapped
        onTap: (int index) {
          setState(() {
            this.indexBottomBar = index;
          });
          if (this.indexBottomBar == 0) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Profile()));
          }
          else if (this.indexBottomBar == 2) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Meet(this.uid)));
          }
          else if (this.indexBottomBar == 3) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Chats()));
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.perm_identity, size: 30.0),
            title: new Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.group, size: 30.0),
            title: new Text('Groups'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, size: 30.0),
              title: Text('Meet')),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 30.0),
              title: Text('Chats'))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: nameGroup.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: GestureDetector(
                      onTap: () async{
                        await Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                new Group(nameGroup[index], iconGroup[index])));
                        this.descriptionGroup = [];
                        this.iconGroup = [];
                        this.membersGroup = [];
                        this.nameGroup = [];
                        this.postsGroup = [];
                        this.retrieveMenuData();  
                      },
                      child: ListTile(
                        leading: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.network(
                            iconGroup[index],
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text(nameGroup[index],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Column(
                            children: [
                              Text(descriptionGroup[index],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    postsGroup[index].length.toString() +
                                        " New Posts",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    membersGroup[index].length.toString() +
                                        " Members",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
