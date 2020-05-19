import 'package:flutter/material.dart';

class ImageInLarge extends StatelessWidget {
  String imageUrl;
  ImageInLarge(this.imageUrl);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: null,
        actions: <Widget>[],
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    this.imageUrl),
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
