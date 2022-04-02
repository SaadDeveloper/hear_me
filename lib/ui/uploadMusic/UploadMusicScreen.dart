
import 'dart:io';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/firebase/FirebaseMusicUploadUtils.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/ui/audioRecorder/audio_recorder.dart';
import 'package:hear_me_final/ui/audioRecorder/Recorder.dart';
import 'package:hear_me_final/ui/enterDetails/datamodel/PersonalDataModel.dart';
import 'package:hear_me_final/ui/musicforyousing/MusicForYouSing.dart';
import 'package:hear_me_final/ui/saveDetails/SaveDetailsScreen.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/CustomDialogs.dart';
import 'package:hear_me_final/utils/FilePickerUtils.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:hear_me_final/utils/SampleSongDataPopulate.dart';

class UploadMusicScreen extends StatefulWidget {
  final PersonalDataModel? personalDataModel;
  final bool fromSignup;

  const UploadMusicScreen(
      {Key? key, this.personalDataModel, required this.fromSignup})
      : super(key: key);

  @override
  _UploadMusicScreenState createState() => _UploadMusicScreenState();
}

class _UploadMusicScreenState extends State<UploadMusicScreen> {
  int? counter = 0;
  late FirebaseMusicUploadUtils firebaseMusicUploadUtils;
  FilePickerUtils filePickerUtils = new FilePickerUtils();
  List<String> sampleCoverPhoto = [];
  List<SongDTO> list = [];

  @override
  void initState() {
    super.initState();
    String? prefDetails = Preference().getString(Preference.SONG_LIST);
    if (prefDetails != null && prefDetails.isNotEmpty) {
      List<SongDTO> prefList = List<SongDTO>.from(json.decode(prefDetails).map((model)=> SongDTO.fromJson(model)));
      setState(() {
        list.addAll(prefList);
        counter = counter! + list.length;
      });
    }
    /*firebaseMusicUploadUtils = new FirebaseMusicUploadUtils(context);
    firebaseMusicUploadUtils.getSampleCoverPhotos().then((value){
      sampleCoverPhoto.addAll(value);
    });*/
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        if(list.length > 0) {
          String detailStr = json.encode(list);
          Preference().setString(Preference.SONG_LIST, detailStr);
        }else{
          Preference().setString(Preference.SONG_LIST, "");
        }
        return new Future(() => true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CColor.black,
        body: SafeArea(
          child: Column(
            children: [
              topbarWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //========Music list=========
                      (list.length > 0) ? musicListWidget() : Container(),
                      //========upload btn=======
                      uploadBtnWidget(),
                      //=======Further btn======
                    ],
                  ),
                ),
              ),
              furtherBtnWidget(fullHeight)
            ],
          ),
        ),
      ),
    );
  }

  topbarWidget() {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              "assets/icons/ic_back.png",
              scale: 0.6,
            ),
          ),
          Expanded(
            child: Text(
              Languages.of(context)!.txtBack,
              style: TextStyle(
                  color: CColor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }

  musicListWidget() {
    return Container(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          //children: musicList,
          itemCount: counter!,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () async {
                  selectTrackOptions(index);
                },
                child: musicItem(list[index]));
          }),
    );
  }

  Widget musicItem(SongDTO songDTO) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 0),
          decoration: BoxDecoration(
            color: CColor.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                      image: songDTO.song_image!.isEmpty
                          ? DecorationImage(
                              image: AssetImage(
                                "assets/images/placeholder.jpg",
                              ),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image:
                                  Image.file(File(songDTO.song_image!)).image,
                              fit: BoxFit.cover,
                            ),
                      borderRadius: BorderRadius.circular(10)),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          songDTO.song_name!,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: CColor.white),
                        ),
                        Text(
                          songDTO.song_duration!,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: CColor.white),
                        ),
                        Visibility(
                            visible: songDTO.genre!.isNotEmpty,
                            child: Text(
                              "Genre: " + songDTO.genre!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: CColor.white),
                            )),
                        Visibility(
                            visible: songDTO.language!.isNotEmpty,
                            child: Text(
                              "Language: " + songDTO.language!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: CColor.white),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          color: CColor.txt_gray.withOpacity(0.3),
          thickness: 2,
        ),
      ],
    );
  }

  uploadBtnWidget() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                Languages.of(context)!.txtUploadMusic,
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: CColor.white),
              ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton(
                onPressed: () {
                  /*setState(() {
                    list.add(_populate.getRandomSong());
                    counter = counter! + 1;
                    //musicList.add(musicItem());
                  });*/
                  selectUploadOption();
                  // chooseCover();
                },
                backgroundColor: CColor.primary,
                child: Icon(
                  Icons.add_rounded,
                  color: CColor.white,
                  size: 40,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  furtherBtnWidget(double fullHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (list.length > 0) {
              String detailStr = json.encode(list);
              Preference().setString(Preference.SONG_LIST, detailStr);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SaveDetailsScreen(
                            personalDataModel: widget.personalDataModel,
                            songsList: list,
                            fromSignUp: widget.fromSignup,
                          )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: CColor.btn_gradient_full_opacity[1],
                  // backgroundColor: Color(0xff050A30),
                  content: Text("Upload At-least Single music"),
                ),
              );
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: CColor.primary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                Languages.of(context)!.txtFurther,
                style: TextStyle(
                    color: CColor.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ],
    );
  }

  selectTrackOptions(int index) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          children: <Widget>[
            simpleDialogOption("Add Details", () async {
              Navigator.of(dialogContext).pop();
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MusicForYouSing(
                          songsDto: list[index],
                        )),
              );
              if (result is SongDTO) {
                setState(() {
                  list[index] = result;
                });
              }
            }),
            simpleDialogOption("Add Track Cover", () async {
              Navigator.of(dialogContext).pop();
              SongDTO songs = await filePickerUtils
                  .selectTrackCoversFromGallery(list[index]);
              setState(() {
                list[index] = songs;
              });
            }),
            simpleDialogOption("Delete Track", () {
              Navigator.of(dialogContext).pop();
              setState(() {
                list.removeAt(index);
                counter = counter! - 1;
              });
            })
          ],
        );
      },
    );
  }

  selectUploadOption() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Choose for Upload Track'),
          children: <Widget>[
            simpleDialogOption("Gallery", () async {
              Navigator.of(dialogContext).pop();
              List<SongDTO> songsList =
                  await filePickerUtils.selectMediaFromGallery(context);
              CustomDialogs.hideOpenDialog(context);
              setState(() {
                list.addAll(songsList);
                counter = counter! + songsList.length;
              });
            }),
            simpleDialogOption("Record Audio", () {
              Navigator.of(dialogContext).pop();
              showRecorder(context);
            })
          ],
        );
      },
    );
  }

  Widget simpleDialogOption(String _title, VoidCallback callBack) {
    return SimpleDialogOption(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(_title),
      ),
      onPressed: callBack,
    );
  }

  Future<Null> chooseCover() async {
    String imageUrl = "";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
            contentPadding: const EdgeInsets.all(10.0),
            title: new Text(
              'SAVED !!!',
              style: new TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
            content: new Container(
              // Specify some width
              width: MediaQuery.of(context).size.width * .7,
              child: new GridView.count(
                  crossAxisCount: 4,
                  physics: new NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.0,
                  padding: const EdgeInsets.all(4.0),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  children: sampleCoverPhoto.map((String url) {
                    return GestureDetector(
                      onTap: () {
                        imageUrl = url;
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: new NetworkImage(url),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    );
                    /*new GridTile(
                    child: new Image.network(url, fit: BoxFit.cover, width: 12.0, height: 12.0,));*/
                  }).toList()),
            ));
      },
    ).then((value) {
      setState(() {
        print(imageUrl);
      });
    });
  }

  void showRecorder(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white70,
          child: Recorder(
            save: (result) async{
              Navigator.pop(context);
              if(result is Recording){
                SongDTO songDTO = await filePickerUtils.getRecordedMetadata(result, result.duration!.inMilliseconds);
                setState(() {
                  list.add(songDTO);
                  counter = counter! + 1;
                });
              }
            },
          ),
        );
      },
    );
  }
}
