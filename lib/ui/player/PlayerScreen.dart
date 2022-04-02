import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hear_me_final/custom/drawer/DrawerMenu.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/FilePickerUtils.dart';
import 'package:hear_me_final/utils/Utils.dart';
import 'package:share/share.dart';

class PlayerScreen extends StatefulWidget {
  GlobalKey<ScaffoldState> globalKey;
  final SongDTO songDTO;

  PlayerScreen(this.globalKey, this.songDTO, {Key? key}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  int valueHolder = 0;
  bool isFavourite = true;
  bool isPlaying = true;
  int points = 3;
  int totalPoints = 5;
  bool isShuffle = false;
  bool isLoop = false;
  bool isComment = false;
  bool isMusicList = false;
  dynamic data;
  final timerFinishedAudio2 = "sounds/animation_sound.aac";
  late AudioPlayer advancedPlayer;
  late AudioCache audioCache;
  Duration duration = new Duration();
  Duration position = new Duration();

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        advancedPlayer.dispose();
        /*parkhya Solutions*/
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        /*parkhya Solutions*/
        drawer: DrawerMenu(),
        body: Container(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [CColor.player_bg_1, CColor.player_bg_2],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Icon(
                          Icons.menu,
                          color: CColor.white,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Image.asset("assets/images/hear_me_logo.png")),
                    SizedBox(
                      width: 40,
                      height: 40,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          /*parkhya Solutions*/
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: double.maxFinite,
                          child: widget.songDTO.song_image!.isEmpty
                              ? Image.asset(
                                  'assets/images/placeholder.jpg',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(widget.songDTO.song_image!),
                        ),
                        _playerButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _initPlayer() async {
    try {
      advancedPlayer = new AudioPlayer();
      advancedPlayer.play(widget.songDTO.song_path!);
      advancedPlayer.onDurationChanged.listen((Duration d) {
        print('Max duration: $d');
        setState(() => duration = d);
      });
      advancedPlayer.onAudioPositionChanged.listen((Duration  p) {
        print('Current position: $p');
        setState(() => position = p);
      });

      advancedPlayer.onPlayerCompletion.listen((event) {
        setState(() {
          isPlaying = !isPlaying;
          position = Duration(seconds: 0);
        });
      });
      advancedPlayer.onPlayerError.listen((event) {
        Utils.showErrorDialog(context, 'audioPlayer error : $event', voidCallback: (){
          Navigator.pop(context);
        });
      });
    } on Exception catch (e) {
      Utils.showErrorDialog(context, "Error Occurred while playing Audio", voidCallback: (){
        Navigator.pop(context);
      });
    } catch (error) {
      Utils.showErrorDialog(context, "Error Occurred while playing Audio", voidCallback: (){
        Navigator.pop(context);
      });
    }
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }

  Widget slider() {
    return Slider.adaptive(
        activeColor: Colors.green,
        inactiveColor: Colors.grey,
        min: 0.0,
        value: position.inSeconds >= duration.inSeconds ? 0.0 : position.inSeconds.toDouble() ,
        max: duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            seekToSecond(value.toInt());
            value = value;
          });
        });
  }

  _playerButtons() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.47,
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Share.share('check out my Song',
                              subject: 'Forest by Day');
                        },
                        child: Container(
                          child: Icon(
                            Icons.share,
                            color: CColor.white,
                            size: 30,
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              isFavourite = !isFavourite;
                            });
                          },
                          child: Container(
                            child: Icon(
                              isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: CColor.white,
                              size: 30,
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  child: slider()
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          FilePickerUtils.printDuration(position)
                          /*valueHolder.toString()*/,
                          style: TextStyle(color: CColor.white, fontSize: 13),
                        ),
                      ),
                      Container(
                        child: Text(
                          FilePickerUtils.printDuration(duration),
                          style: TextStyle(color: CColor.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          Languages.of(context)!.points + ": 40",
                          style: TextStyle(color: CColor.white, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            isShuffle = !isShuffle;
                          });
                        },
                        child: Container(
                          child: Icon(
                            Icons.shuffle,
                            color: isShuffle ? CColor.white : CColor.grey,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                            child: Text(
                          /*parkhya Solutions*/
                          widget.songDTO.song_name!,
                          style: TextStyle(
                              color: CColor.light_primary, fontSize: 24),
                        )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isLoop = !isLoop;
                          });
                        },
                        child: Container(
                          child: Icon(
                            Icons.loop,
                            color: isLoop ? CColor.white : CColor.grey,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                /*Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                            child: Text(
                          "Michel Doorman",
                          style: TextStyle(color: CColor.primary, fontSize: 16),
                        )),
                      ),
                    ],
                  ),
                ),*/
                _pointSelection(),
                SizedBox(
                  height: 6,
                ),
                Container(
                  child: Text(
                    points.toString() +
                        "/" +
                        totalPoints.toString() +
                        " " +
                        Languages.of(context)!.points.toLowerCase(),
                    style: TextStyle(color: CColor.primary, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isComment = !isComment;
                    });
                  },
                  child: Container(
                      child: Image.asset(
                    'assets/icons/ic_question_ans.png',
                    height: 30,
                    width: 30,
                    color: isComment ? CColor.white : CColor.grey,
                  )),
                ),
                Expanded(
                  child: Center(
                      child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isPlaying) {
                          //Utils.showToast(context, "Paused");
                          advancedPlayer.pause();
                        } else {
                          // Utils.showToast(context, "Playing");
                          advancedPlayer.resume();
                        }
                        isPlaying = !isPlaying;
                      });
                    },
                    child: Container(
                        child: Icon(
                      !isPlaying ? Icons.play_arrow_rounded : Icons.pause,
                      color: CColor.light_primary,
                      size: 50,
                    )),
                  )),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isMusicList = !isMusicList;
                    });
                  },
                  child: Container(
                    child: Icon(
                      isMusicList
                          ? Icons.music_note
                          : Icons.music_note_outlined,
                      color: isMusicList ? CColor.white : CColor.grey,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _pointSelection() {
    return Container(
      padding: EdgeInsets.only(top: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _circleWidget(true),
          _circleWidget(true),
          _circleWidget(true),
          _circleWidget(false),
          _circleWidget(false),
        ],
      ),
    );
  }

  _circleWidget(bool isFill) {
    return Container(
      margin: EdgeInsets.all(2),
      height: 18,
      width: 18,
      decoration: isFill
          ? BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(color: CColor.light_primary, spreadRadius: 0.8)
              ],
              color: CColor.light_primary)
          : BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              boxShadow: [BoxShadow(color: CColor.white, spreadRadius: 0.8)],
              color: CColor.black),
      child: Container(),
    );
  }
}
