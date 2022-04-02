import 'package:flutter/material.dart';

abstract class Languages {



  static Languages? of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get errSomethingWentWrong;

  String get errEmail;

  String get errPass;

  String get password;

  String get emailAddress;

  String get forgetPassword;

  String get login;

  String get email;

  String get youDontHaveAcc;

  String get joinNow;

  String get txtReturn;

  String get questionMusic;

  String get questionLanguageMusic;

  String get forYou;

  String get chat;

  String get search;

  String get player;

  String get profile;

  String get txtNotes;

  String get txtFurther;

  String get txtResult;

  String get points;

  String get stageName;

  String get gender;

  String get age;

  String get further;

  String get doesYourVoiceSound;

  String get txtBack;

  String get txtName;

  String get txtContact;

  String get txtEmail;

  String get txtPassword;

  String get txtWhoAreYou;

  String get txtWhatAreYouSearchingFor;

  String get txtYes;

  String get txtNo;

  String get txtAreYouAlreadyUnderContract;

  String get txtAddress;

  String get txtUploadMusic;

  String get txtAge;

  String get txtMusicGenre;

  String get txtLanguage;

  String get txtIam;

  String get txtImLookingFor;

  String get txtIDontHaveAContract;

  String get txtIHaveContract;

  String get txtSaveAndGoToProfile;

  String get txtRegister;

  String get txtDummyLanguage;

  String get txtDummyMusicGenre;

  String get txtDummyid;

  String get txtID;

  String get txtMale;

  String get txtFemale;

  String get txtOther;

  String get txtAdd;

  String get txtGrid;

  String get txtFilter;

  String get txtRecentTracks;

  String get txtTrackList;

  String get txtTopTracks;

  String get txtTopUsers;

  String get txtCorporationPartner;

  String get txtTitleName;
}
