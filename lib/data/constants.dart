import 'package:flutter/material.dart';

const String screen2WelcomeTitle = "Welcome.";
const String screen2WelcomeBody = "Please create an account to continue!";
const String screen2Signup = "Signup";

const String screen3Login = "Login";
const String screen3WelcomeBack = "Welcome back!";
const String screen3PhoneNumberHint = "Enter phone number";
const String screen3PhoneNumberEmpty = "You didn't enter a number!";

const String screen4Welcome = "Welcome.";
const String screen4LetsSetup = "Let's setup an account!";
const String screen4FirstName = "First Name";
const String screen4LastName = "Last Name";
const String screen4PhoneNumber = "Phone Number";
const String screen4BirthDate = "Birth Date";
const String screen4AcademicField = "Academic Field";
const String screen4CountryCity = "Country & City";
const String screen4Man = "Man";
const String screen4Woman = "Woman";
const String screen4Signup = "Signup";
const String screen4NoFirstName = "First Name cannot be empty";
const String screen4NoLastName = "Last Name cannot be empty";
const String screen4NoPhoneNumber = "Phone Number cannot be empty";
const String screen4NoBirthDate = "Birth Date cannot be empty";
const String screen4NoAcademicField = "Academic Field cannot be empty";
const String screen4NoCOuntryCity = "Country & City cannot be empty";
const String screen4PrivacyPolicy1 = "By clicking 'Signup'  I agree to the ";
const String screen4PrivacyPolicy2 = "Terms & Conditions";
const String screen4TitlePrivacyPolicy = "Terms & Conditions";
const String screen4ContentPrivactPolicy = "Here will be the Terms & Conditions of this app."; 
const String screen4FirebaseCollectionName = "userData";
const String screen4FirebaseUserAlreadyExists = "You already have an account!";
const String screen4NoAccountYet = "You need to create an account before you can log in!";
const String screen4NoGPSAvailable = "Your GPS isn't working. Your profile is created without your location!";
const String screen4NoMore3Images = "No more than 3 images please"; 

const String screen8TitleText = "Phone Validation";
const String screen8TitleBody = "Phone Number";
const String screen8HintText = "Phone Number";
const String screen8AuthenticationButton = "Login";
const String screen8NotSufficientDigits = "Please enter 6 digits!";
const String screen8AuthenticationFailed = "Authentication failed.  Please try again!";
const String screen8TooMuchMistakes = "You have already been wrong for 3 times.";
const String screen8WrongNumber = "You entered a wrong number.  Please try again!";

const String screen10Delete = "Delete";

const List<String> screen12PopupChoices = ['Profile', 'Settings', 'Block Users', 'About Us', 'Contact Us', 'Recommend to Friend', 'Logout']; 
const String screen12Logout = "Logout";
const String screen12RecommendToFriend = "Recommend to Friend";
const String screen12ContactUs = "Contact Us";
const String screen12EditProfileWarning = "Please Click on Signup!";

const String screen12ContactUsTitle = "Contact Us";
const String screen12ContactUsBody = "Please write down your questions.";
const String screen12AboutUs = "About Us";
const String screen12AboutUsBody = "We are a team of enthusiastic app developers.";
const String screen12BlockedUsers = "Blocked Users";
const String screen12Settings = "Settings";
const String screen12EditProfile = "Edit Profile";

const String screen13DefaultProfileImage = "https://firebasestorage.googleapis.com/v0/b/area-student-d501b.appspot.com/o/userData%2Fimportant%2Fno_image_available.png?alt=media&token=5a1746c8-6376-4d95-8de5-255401c4ebd4";
const String screen13NoMore2Images = "No more than 2 images please"; 
const String screen13CreatePost = "Create";
const String screen13Warning = "You can't create a blank post!";

const screen17TooMuchImages = "No more than 2 images please!";




const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);