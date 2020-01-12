import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Music.dart';
import 'package:audioplayers/audioplayers.dart';

//https://codabee.com/wp-content/upload/2018/06/un.mp3
//https://codabee.com/wp-content/upload/2018/06/deux.mp3
//void main() => runApp(MyApp());

void main() {
  runApp(new MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Todo: implement build
    return new MaterialApp(
      title : "Les widgets basiques",
      theme : new ThemeData (
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: new Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _Home();
  }
}

class _Home extends State<Home> {

  List<Music> maListeDeMusic = [
    new Music('Theme Swift', 'Codabee', 'assets/un.jpg', 'https://codabee.com/wp-content/upload/2018/06/un.mp3'),
    new Music('Theme Codabee', 'new Codabee', 'assets/deux.jpg', 'https://codabee.com/wp-content/upload/2018/06/deux.mp3'),
  ];

  //---------------------------
  // Mes variables
  //---------------------------
  Music maMusiqueActuelle; // creation de l'objet maMusiqueActuelle
  Duration positionSlider = new Duration(seconds: 0);
  Duration time = new Duration(seconds: 10);
  //Duration position = new Duration();
  AudioPlayer audioPlayer;
  StreamSubscription positionSub;
  StreamSubscription stateSubscription;
  PlayerState statut = PlayerState.stopped;

  int _counter = 0;
  int _value = 6;

  @override
  void initState() {
    super.initState();
    maMusiqueActuelle = maListeDeMusic[0];

  }

  // end functions

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Vince music"),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Card(
              elevation: 10.0,
              child : new Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: new Image.asset(maMusiqueActuelle.imagePath),
                height: 250,
                color: Colors.red,
              ),
            ),
            textWithStyle(maMusiqueActuelle.titre ?? "error title", 1),
            textWithStyle(maMusiqueActuelle.artiste ?? "error artiste", 1),
            new Container( // command play / pause /
              color: Colors.blue,
              width: widthScreen,
              height: 75,
              margin: EdgeInsets.only(left: 30, right: 30),
              child: new Row (
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  commandAudioButton(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                  commandAudioButton(Icons.play_arrow, 40.0, ActionMusic.play),
                  commandAudioButton(Icons.pause, 30.0, ActionMusic.pause),
                  commandAudioButton(Icons.fast_forward, 30.0, ActionMusic.forward),
                ],
              ),
            ),
            new Container ( // time data
              width: widthScreen,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children : <Widget> [
                  Text(
                    "Temps passé",
                    style: new TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Temps restant",
                    style: new TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            new Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget> [
                textWithStyle('00:00', 1),
                textWithStyle('00:22', 1),
              ],
            ),
            new Container (
                child: Slider(
                    value: positionSlider.inSeconds.toDouble(),
                    min: 0.0,
                    max: 30.0,
                    activeColor: Colors.white,
                    inactiveColor: Colors.red,
                    onChanged: (double d) {
                      setState(() {
                        Duration newDuration = new Duration(seconds: d.toInt());
                        positionSlider = newDuration;
                        print('test $positionSlider');
                      });
                    },
                    semanticFormatterCallback: (double newValue) {
                      return '${newValue.round()} dollars';
                    }
                ),
            ),
          ],
        ),
      ),
    );
  }




  IconButton commandAudioButton(IconData icone, double taille, ActionMusic action) {
    return new IconButton(
        iconSize: 30,
        color: Colors.white,
        icon: new Icon(icone),
        onPressed: () {
          switch (action) {
            case ActionMusic.play:
              print('ActionMusic.play');
              break;
            case ActionMusic.pause:
              print('ActionMusic.pause');
              break;
            case ActionMusic.rewind:
              print('ActionMusic.rewind');
              break;
            case ActionMusic.forward:
              print('ActionMusic.forward');
              break;
            case ActionMusic.next:
              print('ActionMusic.next');
              break;
            case ActionMusic.before:
              print('ActionMusic.before');
              break;
          }
        }
    );
  }

  // design func Text
  Text textWithStyle(String data, double scale) {
    return new Text(
      data,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
      ),
    );
  }
// configurationAudioPlayer
  void configurationAudioPlayer() {
    print('configurationAudioPlayer');
    audioPlayer = new AudioPlayer();
    positionSub = audioPlayer.onAudioPositionChanged.listen( // quand la position de l'audio a changé
        (pos) => setState(() => positionSlider = pos)
    );
    stateSubscription = audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == AudioPlayerState.PLAYING) {
        setState(() {
          time = audioPlayer. ;
        });
      } else if (state == AudioPlayerState.STOPPED) {
        setState(() {
          statut = PlayerState.stopped;
        });
      }
    });
  }
}

enum ActionMusic {
  play,
  pause,
  rewind,
  forward,
  next,
  before,
}

enum PlayerState {
  playing,
  stopped,
  paused,
}