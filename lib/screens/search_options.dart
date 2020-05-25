import 'package:flutter/material.dart';
import 'package:areastudent/tools/methods.dart';
import 'package:flutter/cupertino.dart';
import 'menu_groups.dart';
import 'profile.dart';
import 'package:areastudent/data/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchOptions extends StatefulWidget {
  @override
  _SearchOptionsState createState() => _SearchOptionsState();
}

class _SearchOptionsState extends State<SearchOptions> {
  int indexBottomBar = 0;
  double selectedDistance;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String textAcademicField = "All Fields";
  int _radioValue = 0;
  String gender;
  SharedPreferences prefs;  
  String prefGender;
  String prefAcademicField;
  int prefDistance;
  

  List<String> academicFields = [
    'All Fields',
    'Agriculture',
    'Anthropology',
    'Archeology',
    'Architecture',
    'Arts',
    'Astronomy',
    'Biology',
    'Business',
    'Chemistry',
    'CS',
    'Culinary',
    'Economics',
    'Education',
    'Engineering',
    'Environmental',
    'Geography',
    'History',
    'Journalism',
    'Languages',
    'Librarianship',
    'Literature',
    'Law',
    'Mathematics',
    'Medicine',
    'Military',
    'Philosophy',
    'Physics',
    'Political',
    'Psychology',
    'Religion',
    'Social-Work',
    'Sociology',
    'Space',
    'Statistics',
    'Transportation',
  ];


   updateSearchPrefs() async {
     //print(selectedDistance.toString() +  "  " + textAcademicField +  " " + gender);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('searchSelectedDistance', this.selectedDistance.floor());
    await prefs.setString('searchSelectedAcademicField', this.textAcademicField);
    await prefs.setString('searchSelectedGender', this.gender);
    Navigator.of(context).pop();
   }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          gender = "Male";
          print("Man");
          break;
        case 1:
          gender = "Female";
          print("Woman");
          break;
        case 2:
          gender = "Both";
          print("Both");
          break;  
      }
    });
  }


  retrievePrefs() async {
    this.prefs = await SharedPreferences.getInstance();   
    gender =  prefs.getString('searchSelectedGender') ?? "Both";
    if(gender=="Male") _radioValue = 0; else if(gender=="Female") _radioValue = 1; else _radioValue=2;
    textAcademicField = prefs.getString('searchSelectedAcademicField') ?? "All Fields";
    int temp =  prefs.getInt('searchSelectedDistance') ?? 500;
    selectedDistance = temp.toDouble();
    setState(() {
      
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrievePrefs();
  }

  @override
  Widget build(BuildContext context) {
  if(gender==null || textAcademicField==null || selectedDistance==null) return Container();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            new Text(
              "Search Options",
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
                showSnackBar(
                    "In the future - Inbox will be here!", scaffoldKey);
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        onTap: (int index) {
          setState(() {
            this.indexBottomBar = index;
          });

          if (this.indexBottomBar == 0) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new Profile()));
          } else if (this.indexBottomBar == 1) {
            Navigator.of(context).push(new CupertinoPageRoute(
                builder: (BuildContext context) => new MenuGroups()));
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
              icon: Icon(Icons.home, size: 30.0), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, size: 30.0),
              title: Text('Meet')),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 30.0),
              title: Text('Chats'))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Maximum Distance: " +
                    selectedDistance.round().toString() +
                    " Kilometers",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Slider(
            min: 0,
            max: 500,
            value: selectedDistance,
            onChanged: (newValue) {
              setState(() {
                print(newValue.toString());
                this.selectedDistance = newValue;
              });
            },
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Filter by Academic Field",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.grey[100],
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black45),
                ),
              ),
              child: SizedBox(
                width: 500.0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: new DropdownButton<String>(
                      underline: SizedBox(),
                      iconSize: 2,
                      hint: new Text(
                        this.textAcademicField,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[600]),
                      ),
                      items: academicFields.map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          this.textAcademicField = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              new Radio(
                value: 0,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(screen4Man),
              new SizedBox(width: 15.0),
              new Radio(
                value: 1,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(screen4Woman),
              new SizedBox(width: 15.0),
              new Radio(
                value: 2,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(screen4Both),
            ],
          ),
          SizedBox(height: 15.0),
          RaisedButton(
            onPressed:
                updateSearchPrefs, //the click event is impolemented in the screen classes
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFB3F5FC),
                      Color(0xFF81D4FA),
                      Color(0xFF29B6F6),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              padding: const EdgeInsets.fromLTRB(110, 12, 110, 12),
              child: new Text("Save",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
