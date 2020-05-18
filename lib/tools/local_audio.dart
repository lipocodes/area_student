import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';

class LocalAudio extends StatefulWidget {
  final String url;
  LocalAudio(this.url);

  @override
  _LocalAudioState createState() => _LocalAudioState(this.url);
}

class _LocalAudioState extends State<LocalAudio> {

  Duration _duration = Duration();
  Duration _position = Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  String playedAudioValue = "00:00";
  bool isPlayingNow=false;
  String url;

  _LocalAudioState(this.url);

  @override
  void initState(){
    super.initState();

    initPlayer();
  }


  void initPlayer(){

    advancedPlayer  = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler  =(d) => setState(() {
      _duration = d;
    });


    advancedPlayer.positionHandler  =(p) => setState(() {
      _position = p;
    });

  }


  String localFilePath;


  Widget _tab(List<Widget>children) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: children.map((w) => Container(child:w, padding: EdgeInsets.all(6.0),)).
              toList()
          ),
        ),
      ],
    );

  }


  Widget _btn(String txt, VoidCallback onPressed){

    return ButtonTheme(

      minWidth: 48.0,
      child: Container(
        width:100,
        height: 45,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius:   BorderRadius.circular(25), ),
          child: Text(txt),
          color: Colors.pink[900],
          textColor: Colors.white,
          onPressed: onPressed,
        ),
      ),

    );
  }


  Widget slider(){
    return Slider(

      activeColor: Colors.black,
      inactiveColor:  Colors.pink,
      value: _position.inSeconds.toDouble(),
      min: 0.0,
      max: _duration.inSeconds.toDouble(),
      onChanged: (double value) {
       
        setState(() {
          seekToSecond(value.toInt());
          value = value;
        });
      },


    );
  }




  Widget localAudio(){
    return Column(
      children: <Widget>[
        Row(children: <Widget> [
         
          //_btn('Play', () =>  advancedPlayer.play("https://firebasestorage.googleapis.com/v0/b/area-student-d501b.appspot.com/o/audio%2FUXlUwUGhs3dwYp6m7h6k9kJHlOJ3%2F2020-05-18%2015%3A01%3A42.016727?alt=media&token=df669293-6087-4638-b2d5-d6739aa9f5ff")),
          //_btn('Pause', () => advancedPlayer.pause()),
          //_btn('Resume', () => advancedPlayer.resume()),
          //_btn('Stop', () => advancedPlayer.stop()),

          IconButton(
              icon: isPlayingNow? Icon(Icons.pause) : Icon(Icons.play_arrow),
              iconSize: 30,
              color: Colors.black,
              onPressed: (() {
                if(isPlayingNow==false){
                  advancedPlayer.play(this.url);
                 isPlayingNow = true;
                }
                else {
                  advancedPlayer.stop();
                  isPlayingNow = false;
                }

              })),

          slider(),

          Text(
              _position.inSeconds.toDouble().toString(),
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.blue)
          ),

        ]),

        Center(
          child: Text("For playing again - double click on ||"),
        ),

      ],
    );
  }



  void seekToSecond(int second) {

    Duration newDuration = Duration(seconds:second);
    advancedPlayer.seek(newDuration);

  }


  @override
  Widget build(BuildContext context) {
    return localAudio();
  }
}
