import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:areastudent/data/constants.dart';

class Contact  extends StatelessWidget {

  final valueName = TextEditingController();
  final valuePhone = TextEditingController();
  final valueEmail = TextEditingController();
  final valueText = TextEditingController();



  sendEmail(BuildContext context) async {

    int pos = valueEmail.text.indexOf('@');
    String emailUser = valueEmail.text.substring(0,pos);
    String emailSupplier = valueEmail.text.substring(pos+1, valueEmail.text.length-4);

    String str = "Name: " + valueName.text + "    Phone: " + valuePhone.text + "    Email: " +   emailUser + "  " + emailSupplier + "  Content: "   + valueText.text;

    final String _email = 'mailto:' +
        'areastudent2019@gmail.com' +
        '?subject=' +
        'A user needs to tell you something' +
        '&body=' +
        str;
    try {
      await launch(_email);
    } catch (e) {
      throw 'Could not Call Phone';
    }
    finally {  Navigator.of(context).pop(); }
  }





  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: new Text(
          "",
        ),
        backgroundColor: Colors.white,
      ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

             new Text(
               screen12ContactUsTitle,
               style: new TextStyle(
                   fontSize: 26.0, fontWeight: FontWeight.w900),
             ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 70.0,
                          bottom:30.0,
                        ),
                        child: new Text(screen12ContactUsBody,
                            style: new TextStyle(
                                fontSize: 22.0, color: Colors.grey)),
                      ),*/

            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextFormField(
                controller: valueName,
                decoration: new InputDecoration(
                   labelText: "Name",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                ),
              ),
            ),
            new SizedBox(height:10.0),
            new ListTile(
              leading: const Icon(Icons.phone),
              title: new TextFormField(
                keyboardType: TextInputType.number,
                controller: valuePhone,
                decoration: new InputDecoration(
                   labelText: "Phone",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                ),
              ),
            ),
             new SizedBox(height:10.0),
            new ListTile(
              leading: const Icon(Icons.email),
              title: new TextFormField(
                controller: valueEmail,
                decoration: new InputDecoration(
                   labelText: "Email",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                ),
              ),
            ),
             new SizedBox(height:10.0),
            new ListTile(
              leading: const Icon(Icons.text_fields),
              title: SingleChildScrollView(
                child: new TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  controller: valueText,
                  decoration: new InputDecoration(
                     labelText: "Text",
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ),
                ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:50.0,  top:20.0),
              child: Container(
                  width:250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),

                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFFB3F5FC),
                        Color(0xFF81D4FA),
                        Color(0xFF29B6F6),
                      ],),
                  ),
                  child: new OutlineButton(
                    borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
                    child: Text("Send", style: TextStyle(color: Colors.white, fontSize: 18), ),
                    onPressed: (){ sendEmail(context);  },
                  )),
            ),


          ],
        ),
      ),
    );
  }
}
