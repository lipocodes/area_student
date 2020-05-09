import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body: Column(
          //welcome title & welcome body
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: new Text(
                screen4Welcome,
                style:
                    new TextStyle(fontSize: 26.0, fontWeight: FontWeight.w900),
              ),
            ),
            new SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 70.0,
              ),
              child: new Text(screen4LetsSetup,
                  style: new TextStyle(fontSize: 22.0, color: Colors.grey)),
            ),
            new SizedBox(height: 30.0),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  new Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  new AssetImage("assets/images/avatar.png")))),
                  GestureDetector(
                    onTap: onTapProfileImage,
                    child: new CircleAvatar(
                        backgroundColor: Colors.lightBlueAccent,
                        child: new Icon(Icons.add_a_photo,
                            color: Colors.white, size: 20.0)),
                  ),
                ],
              ),
            ),
            multiImagePickerList(
                imageList: imageList,
                removeNewImage: (index) {
                  removeImage(index);
                }),
            new SizedBox(
              height: 10.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: signupInputBox(
                  labelText: screen4FirstName,
                  controller: controllerFirstName,
                  textInputType: TextInputType.text),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: signupInputBox(
                  labelText: screen4LastName,
                  controller: controllerLastName,
                  textInputType: TextInputType.text),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: signupInputBox(
                  labelText: screen4PhoneNumber,
                  controller: controllerPhoneNumber,
                  textInputType: TextInputType.phone),
            ),
            SizedBox(
              width: 500.0,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: RaisedButton(
                  onPressed: () {
                    selectDate(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 5.0,
                      bottom: 6.0,
                    ),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          this.textBirthdate,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600]),
                        )),
                  ),
                  textColor: Colors.grey,
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black45),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                ),
              ),
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
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                new Text(screen4Man),
                new SizedBox(width: 50.0),
                new Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                new Text(screen4Woman),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                controller: controllerAboutMe,
                decoration: new InputDecoration(
                    labelText: 'About',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow))),
              ),
            ),
            new SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: onPressedSignupButton,
                    child: signupButton(whichScreen: 4)),
              ],
            ),
            new SizedBox(height: 20.0),
            new Center(
              child: new Text(screen4PrivacyPolicy1),
            ),
            new Center(
                child: GestureDetector(
                    onTap: () {
                      buttonPrivacyPolicyTapped(context);
                    },
                    child: new Text(
                      screen4PrivacyPolicy2,
                      style: new TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16.0,
                        color: Colors.lightBlue,
                        decoration: TextDecoration.underline,
                      ),
                    ))),
            new SizedBox(
              height: 40.0,
            )
          ],
        ),
    );
  }
}
