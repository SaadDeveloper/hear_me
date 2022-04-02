import 'dart:convert';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/firebase/FirebaseInstantiation.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/ui/enterDetails/datamodel/PersonalDataModel.dart';
import 'package:hear_me_final/ui/gender/model/UserStageDetails.dart';
import 'package:hear_me_final/ui/saveDetails/SongListViewScreen.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/CustomDialogs.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:hear_me_final/utils/Utils.dart';

import '../home/HomeScreen.dart';

class SaveDetailsScreen extends StatefulWidget {
  final PersonalDataModel? personalDataModel;
  final List<SongDTO>? songsList;
  final bool fromSignUp;

  const SaveDetailsScreen({Key? key, this.personalDataModel, this.songsList, required this.fromSignUp}) : super(key: key);

  @override
  _SaveDetailsScreenState createState() => _SaveDetailsScreenState();
}

class _SaveDetailsScreenState extends State<SaveDetailsScreen> {
  late FirebaseInstantiation firebaseInstantiation;
  late UserStageDetails userStageDetails;
  String? name;
  String? contact;
  String? email;
  String? password;
  String? address;
  String? iAm;
  String? lookingFor;
  String? musicGenre;
  String? language;
  String? id;
  String? contract;
  int? age;
  String? gender;

  @override
  void initState() {
    super.initState();
    String prefDetails = Preference().getString(Preference.USER_STAGE_DETAILS)!;
    userStageDetails = UserStageDetails.fromJson(jsonDecode(prefDetails) as Map<String, dynamic>);
    name = widget.personalDataModel!.name;
    contact = widget.personalDataModel!.contact;
    address = widget.personalDataModel!.address;
    email = widget.personalDataModel!.email;
    password = widget.personalDataModel!.password;
    iAm = widget.personalDataModel!.iAm;
    lookingFor = widget.personalDataModel!.lookingFor;
    musicGenre = widget.personalDataModel!.musicGenre;
    if (musicGenre != null) {
      if (musicGenre!.trim().length > 0) {
        musicGenre = musicGenre!.replaceAll("[", "");
        musicGenre = musicGenre!.replaceAll("]", "");
      }
    }
    language = widget.personalDataModel!.language;
    if (language != null) {
      if (language!.trim().length > 0) {
        language = language!.replaceAll("[", "");
        language = language!.replaceAll("]", "");
      }
    }
    id = widget.personalDataModel!.id;
    contract = widget.personalDataModel!.contract;
    age = widget.personalDataModel!.age;
    gender = widget.personalDataModel!.gender;

  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CColor.black,
      body: SafeArea(
        child: Column(
          children: [
            //=========Topbar==========
            topbarWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: fullWidth * 0.05),
                  child: Container(
                    child: Column(
                      children: [
                        //========Details=========
                        detailsWidget(fullHeight, fullWidth),

                        new SongListViewScreen(songsList: widget.songsList, fromSignUp: widget.fromSignUp),
                        //=======Save btn======
                        saveBtn(fullHeight, fullWidth)
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )/*SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                //=========Topbar==========
                topbarWidget(),
                //========Details=========
                detailsWidget(fullHeight, fullWidth),

                new SongListViewScreen(songsList: widget.songsList,),
                //=======Save btn======
                saveBtn(fullHeight, fullWidth)
              ],
            ),
          ),
        ),
      )*/,
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
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
          )
        ],
      ),
    );
  }

  detailsWidget(double fullHeight, double fullWidth) {
    return Column(
      children: [
        //======Name & id=========
        Container(
          margin: EdgeInsets.only(top: fullHeight * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    style: TextStyle(
                        color: CColor.txt_primary_trans,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "(" + id! + ")",
                    style: TextStyle(
                        color: CColor.txt_primary_trans,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  )
                  /*gender == Languages.of(context)!.txtMale
                      ? Image.asset("assets/icons/img.png")
                      : Image.asset("assets/icons/img.png")*/
                ],
              ),
              /*Text(
                Languages.of(context)!.txtID + ": " + id!,
                style: TextStyle(
                    color: CColor.txt_primary_trans,
                    fontSize: 12,
                    fontWeight: FontWeight.normal),
              )*/
            ],
          ),
        ),
        //========details=======
        Container(
          margin: EdgeInsets.only(top: fullHeight * 0.05, left: 15, right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //===gender=====
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: fullWidth * 0.25,
                          child: Text(
                            Languages.of(context)!.gender + " :",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: CColor.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        gender == Languages.of(context)!.txtMale
                            ? Image.asset("assets/icons/ic_male_white.png")
                            : Image.asset("assets/icons/img.png")
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: fullWidth * 0.25,
                          child: Text(
                            Languages.of(context)!.age + " :",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: CColor.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            age.toString(),
                            style: TextStyle(
                                color: CColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //======music genre=========
                  musicGenre != null ? Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: fullWidth * 0.25,
                          child: Text(
                            Languages.of(context)!.txtMusicGenre + " :",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: CColor.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            musicGenre!,
                            style: TextStyle(
                                color: CColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ): Container(),
                  //======language=========
                  language != null ? Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: fullWidth * 0.25,
                          child: Text(
                            Languages.of(context)!.txtLanguage + " :",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color: CColor.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            language!,
                            style: TextStyle(
                                color: CColor.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ): Container(),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  saveBtn(double fullHeight, double fullWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: fullHeight * 0.05, bottom: 20),
          width: fullWidth * 0.9,
          height: 50,
          decoration: BoxDecoration(
            color: CColor.primary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Material(
            color: CColor.transparent,
            child: InkWell(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => HomeScreen()));
                  registerToFb();
                },
                child: Center(
                  child: Text(
                    Languages.of(context)!.txtRegister.toUpperCase(),
                    style: TextStyle(
                        color: CColor.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        ),
      ],
    );
  }

  void registerToFb() {
    firebaseInstantiation = new FirebaseInstantiation((user){
      widget.personalDataModel!.id = user.user!.uid;
      firebaseInstantiation.saveUserDataOnFirebase(widget.personalDataModel);
    },(id){
      userStageDetails.id = id;
      firebaseInstantiation.saveUserStageDataOnFirebase(userStageDetails);
    }, (id){
      firebaseInstantiation.saveUserMusicPreferencesDataOnFirebase(widget.personalDataModel);
    }, (id){
      removeFormPreferences();
      Preference().setLoginBoo(Preference.IS_LOGIN, true);
      Preference().setString(Preference.KEY_SIGNIN_EMAIL, widget.personalDataModel!.email!);
      Preference().setString(Preference.KEY_SIGNIN_PASSWORD, widget.personalDataModel!.password!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          // backgroundColor: Color(0xff050A30),
          content: Text("Registration Completed"),
        ),
      );
      CustomDialogs.hideOpenDialog(context);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen(fromSignup: true,)));
      // firebaseInstantiation.saveUserTrackListDataOnFirebase(widget.personalDataModel!.id!, widget.songsList!);
    }, (id, songsList){
      // firebaseInstantiation.saveTopTrackListDataOnFirebase(id, songsList);
    }, (id, songsList){
      // firebaseInstantiation.saveWeeklyTrackListDataOnFirebase(id, songsList);
    }, (id){

    }, (id){

    }, (id){

    }, (err){
      CustomDialogs.hideOpenDialog(context);
      Utils.showErrorDialog(context, err);
    });
    firebaseInstantiation.registerToFirebase(email, password);
    CustomDialogs.showProgressDialog(context, "Registering user....");
    /*firebaseAuth
        .createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        )
        .then(
            (result) async => dbRef.child("user").child(result.user!.uid).set({
                  "email": email!,
                  "age": age!,
                  "name": name!,
                  "contact": contact!,
                  "address": address!,
                  "gender": gender!,
                  "musicGenre": musicGenre!,
                }).then((res) {
                  print("Sign up successfull.");
                  Preference().setLoginBoo(Preference.IS_LOGIN, true);
                  Preference().setString(Preference.KEY_EMAIL, email!);
                  Preference().setString(Preference.KEY_NAME, name!);
                  Preference().setString(Preference.KEY_CONTACT, contact!);
                  Preference().setString(Preference.KEY_ADDRESS, address!);
                  Preference().setString(Preference.KEY_GENDER, gender!);
                  // Preference().setString(Preference.KEY_FURTHER, farther);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                }))
        .catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });*/
  }

  removeFormPreferences(){
    Preference().setString(Preference.KEY_STAGE_NAME, "");
    Preference().setString(Preference.KEY_DAY, "1");
    Preference().setString(Preference.KEY_MONTH, "1");
    Preference().setString(Preference.KEY_YEAR, "1960");
    Preference().setString(Preference.KEY_VOICE, "");
    Preference().setString(Preference.KEY_GENDER, "");
    // Preference().setString(Preference.SONG_LIST, "");
    Preference().setString(Preference.USER_PERSONAL_DETAILS, "");
    Preference().setString(Preference.USER_STAGE_DETAILS, "");
    Preference().setString(Preference.KEY_MUSIC_TYPE, "");
    Preference().setString(Preference.LANGUAGE, "");
  }
}
