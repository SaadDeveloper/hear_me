import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:hear_me_final/utils/Utils.dart';

typedef SignInSuccessCallBack = Function();
typedef UserRecentListTableSaveCallBack = Function(String);
typedef FirebaseErrorCallBack = Function();

class FirebaseHomeUtils {
  late BuildContext context;
  late FirebaseDatabase mFirebaseDatabase;
  late FirebaseAuth firebaseAuth;
  late DatabaseReference dbRef;

  late SignInSuccessCallBack signInSuccessCallBack;
  late UserRecentListTableSaveCallBack userRecentListTableSaveCallBack;
  late FirebaseErrorCallBack firebaseErrorCallBack;

  FirebaseHomeUtils(BuildContext context) {
    this.context = context;
    mFirebaseDatabase = FirebaseDatabase.instance;
    firebaseAuth = FirebaseAuth.instance;
    dbRef = mFirebaseDatabase.reference();
  }

  checkIfUserLoggedIn(SignInSuccessCallBack signInSuccessCallBack,
      FirebaseErrorCallBack firebaseErrorCallBack) async {
    if (firebaseAuth.currentUser == null) {
      if (Preference().getLoginBool(Preference.IS_LOGIN)!) {
        String email = Preference().getString(Preference.KEY_SIGNIN_EMAIL)!;
        String password =
            Preference().getString(Preference.KEY_SIGNIN_PASSWORD)!;
        this.signInSuccessCallBack = signInSuccessCallBack;
        this.firebaseErrorCallBack = firebaseErrorCallBack;
        firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((result) {
          signInSuccessCallBack();
        }).catchError((err) {
          print(err.message);
          Utils.showErrorDialog(context, "Auto-Login Failed", voidCallback: () {
            firebaseErrorCallBack();
          });
        });
      }
    } else {
      signInSuccessCallBack();
    }
  }

  saveRecentTrackListDataOnFirebase(
      List<SongDTO> list,
      UserRecentListTableSaveCallBack userRecentListTableSaveCallBack,
      FirebaseErrorCallBack firebaseErrorCallBack) async {
    this.userRecentListTableSaveCallBack = userRecentListTableSaveCallBack;
    this.firebaseErrorCallBack = firebaseErrorCallBack;
    bool allFilesUploaded = true;
    for (SongDTO song in list) {
      bool isErr = false;
      dbRef
          .child("recent_track_list")
          .child(firebaseAuth.currentUser!.uid)
          .child("tracks")
          .child(song.song_id!)
          .set({
            "song_id": song.song_id!,
            "song_name": song.song_name!,
            "song_title": song.song_title!,
            "song_details": song.song_details!,
            "song_images_thumb": song.song_image,
            "song_duration": song.song_duration!,
            "song_favourite": song.is_favourite!,
            "song_posted_date": song.postedDate!,
            "song_path": song.song_path!,
            "song_genre": song.genre!,
            "song_language": song.language!
          })
          .then((value) => null)
          .catchError((err) {
            isErr = true;
            allFilesUploaded = false;
            firebaseErrorCallBack();
            Utils.showErrorDialog(context, err);
          });
      if (isErr) {
        break;
      }
    }
    if (allFilesUploaded) {
      userRecentListTableSaveCallBack(firebaseAuth.currentUser!.uid);
    }
  }

  Future<List<SongDTO>> getTopTracksList() async {
    List<SongDTO> topTracks = [];
    DataSnapshot snapshot = await mFirebaseDatabase
        .reference()
        .child("top_track_list")
        .child(firebaseAuth.currentUser!.uid)
        .child("tracks")
        .once();
    Map<dynamic, dynamic> yearMap = snapshot.value;
    yearMap.forEach((key, value) {
      topTracks.add(SongDTO.fromJson(Map<String, dynamic>.from(value)));
    });
    return topTracks;
  }

  Future<List<SongDTO>> getAllTracksList() async {
    List<SongDTO> allTracks = [];
    DataSnapshot snapshot = await mFirebaseDatabase
        .reference()
        .child("track_list_table")
        .child(firebaseAuth.currentUser!.uid)
        .child("tracks")
        .once();
    Map<dynamic, dynamic> yearMap = snapshot.value;
    yearMap.forEach((key, value) {
      allTracks.add(SongDTO.fromJson(Map<String, dynamic>.from(value)));
    });
    return allTracks;
  }

  Future<List<SongDTO>> getRecentTracksList() async {
    List<SongDTO> allTracks = [];
    DataSnapshot snapshot = await mFirebaseDatabase
        .reference()
        .child("recent_track_list")
        .child(firebaseAuth.currentUser!.uid)
        .child("tracks")
        .once();
    Map<dynamic, dynamic> yearMap = snapshot.value;
    yearMap.forEach((key, value) {
      allTracks.add(SongDTO.fromJson(Map<String, dynamic>.from(value)));
    });
    return allTracks;
  }
}
