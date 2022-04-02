import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_broadcast_receiver/flutter_broadcast_receiver.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/ui/enterDetails/datamodel/PersonalDataModel.dart';
import 'package:hear_me_final/ui/gender/model/UserStageDetails.dart';
import 'package:hear_me_final/utils/Constant.dart';
import 'package:hear_me_final/utils/FilePickerUtils.dart';
import 'package:hear_me_final/utils/Utils.dart';
import 'package:path/path.dart' as p;

typedef RegisterCallBack = Function(UserCredential);
typedef UserDataSaveCallBack = Function(String);
typedef UserStageDetailSaveCallBack = Function(String);
typedef UserTrackListTableSaveCallBack = Function(String, List<SongDTO>);
typedef UserTopTrackListTableSaveCallBack = Function(String, List<SongDTO>);
typedef UserTopUserListTableSaveCallBack = Function(String);
typedef UserRecentListTableSaveCallBack = Function(String);
typedef UserMusicReferenceTableSaveCallBack = Function(String);
typedef UserWeeklyChartListTableSaveCallBack = Function(String);
typedef FirebaseErrorCallBack = Function(dynamic);

class FirebaseInstantiation {
  late FirebaseAuth _firebaseAuth;
  late DatabaseReference _dbRef;

  RegisterCallBack _registerCallBack;
  UserDataSaveCallBack _userDataSaveCallBack;
  UserStageDetailSaveCallBack _userStageDetailSaveCallBack;
  UserMusicReferenceTableSaveCallBack _userMusicReferenceTableSaveCallBack;
  UserTrackListTableSaveCallBack _userTrackListTableSaveCallBack;
  UserTopTrackListTableSaveCallBack _userTopTrackListTableSaveCallBack;
  UserTopUserListTableSaveCallBack _topUsersDataSaveCallBack;
  UserRecentListTableSaveCallBack _userRecentListTableSaveCallBack;
  UserWeeklyChartListTableSaveCallBack _userWeeklyChartListTableSaveCallBack;
  FirebaseErrorCallBack _firebaseErrorCallBack;

  FirebaseInstantiation(
      this._registerCallBack,
      this._userDataSaveCallBack,
      this._userStageDetailSaveCallBack,
      this._userMusicReferenceTableSaveCallBack,
      this._userTrackListTableSaveCallBack,
      this._userTopTrackListTableSaveCallBack,
      this._topUsersDataSaveCallBack,
      this._userRecentListTableSaveCallBack,
      this._userWeeklyChartListTableSaveCallBack,
      this._firebaseErrorCallBack) {
    _dbRef = FirebaseDatabase.instance.reference();
    _firebaseAuth = FirebaseAuth.instance;
  }

  String? getFirebaseAuthId(){
    return _firebaseAuth.currentUser?.uid;
  }

  registerToFirebase(String? email, String? password) {
    _firebaseAuth
        .createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        )
        .then((value) => _registerCallBack(value))
        .catchError((err) {
      _firebaseErrorCallBack(err);
    });
  }

  saveUserDataOnFirebase(PersonalDataModel? personalDataModel) {
    _dbRef
        .child("user_data")
        .child(personalDataModel!.id!)
        .set({
          "email": personalDataModel.email!,
          "age": personalDataModel.age!,
          "name": personalDataModel.name!,
          "contact": personalDataModel.contact!,
          "address": personalDataModel.address!,
          "gender": personalDataModel.gender!,
          "iam": personalDataModel.iAm!,
          "lookingfor": personalDataModel.lookingFor
        })
        .then((value) => _userDataSaveCallBack(personalDataModel.id!))
        .catchError((err) {
          _firebaseErrorCallBack(err);
        });
  }

  saveTopUserDataOnFirebase(PersonalDataModel? personalDataModel) async {
    _dbRef
        .child("top_user_data")
        .child(personalDataModel!.id!)
        .set({
          "email": personalDataModel.email!,
          "age": personalDataModel.age!,
          "name": personalDataModel.name!,
          "contact": personalDataModel.contact!,
          "address": personalDataModel.address!,
          "gender": personalDataModel.gender!,
          "iam": personalDataModel.iAm!,
          "lookingfor": personalDataModel.lookingFor
        })
        .then((value) => _topUsersDataSaveCallBack(personalDataModel.id!))
        .catchError((err) {
          _firebaseErrorCallBack(err);
        });
  }

  saveUserStageDataOnFirebase(UserStageDetails? userStageDetails) {
    _dbRef
        .child("user_stage_details")
        .child(userStageDetails!.id!)
        .set({
          "stage_name": userStageDetails.userStageName!,
          "user_voice_sound": userStageDetails.userVoiceSound!,
          "date_of_birth": userStageDetails.dateOfBirth!,
          "gender": userStageDetails.gender!
        })
        .then((value) => _userStageDetailSaveCallBack(userStageDetails.id!))
        .catchError((err) {
          _firebaseErrorCallBack(err);
        });
  }

  saveUserMusicPreferencesDataOnFirebase(PersonalDataModel? personalDataModel) {
    _dbRef
        .child("music_preferences")
        .child(personalDataModel!.id!)
        .set({
          "music_language": personalDataModel.language!,
          "music_prefer_genres": personalDataModel.musicGenre!,
        })
        .then((value) =>
            _userMusicReferenceTableSaveCallBack(personalDataModel.id!))
        .catchError((err) {
          _firebaseErrorCallBack(err);
        });
  }

  saveUserTrackListDataOnFirebase(String id, List<SongDTO> list) async {
    bool allFilesUploaded = true;
    int count = 1;
    for (SongDTO song in list) {
      BroadcastReceiver().publish<String>(Constant.BROADCAST_CHANNEL,
          arguments: count.toString());
      print("Firebase - Track loop $count");
      late String? downloadUrl;
      if (song.song_image != null && song.song_image!.isEmpty) {
        downloadUrl = "";
      } else {
        downloadUrl = await uploadFileFromStorage(song.song_image!);
      }
      bool isErr = false;
      if (downloadUrl != null) {
        String? downloadSongUrl = await uploadAudioFile(song.song_path!);
        if (downloadSongUrl != null) {
          song.song_image = downloadUrl;
          song.song_path = downloadSongUrl;
          _dbRef
              .child("track_list_table")
              .child(id)
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
                _firebaseErrorCallBack(err);
              });
        } else {
          allFilesUploaded = false;
          _firebaseErrorCallBack("Song Uploading Failed");
          break;
        }
      } else {
        allFilesUploaded = false;
        _firebaseErrorCallBack("Song Uploading Failed");
        break;
      }
      if (isErr) {
        break;
      }
      count++;
    }
    if (allFilesUploaded) {
      _userTrackListTableSaveCallBack(id, list);
    }
  }

  saveTopTrackListDataOnFirebase(String id, List<SongDTO> list) async {
    bool allFilesUploaded = true;
    for (SongDTO song in list) {
      bool isErr = false;
      _dbRef
          .child("top_track_list")
          .child(id)
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
            _firebaseErrorCallBack(err);
          });
      if (isErr) {
        break;
      }
    }
    if (allFilesUploaded) {
      _userTopTrackListTableSaveCallBack(id, list);
    }
  }

  saveRecentTrackListDataOnFirebase(String id, List<SongDTO> list) async {
    bool allFilesUploaded = true;
    for (SongDTO song in list) {
      bool isErr = false;
      _dbRef
          .child("recent_track_list")
          .child(id)
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
            _firebaseErrorCallBack(err);
          });
      if (isErr) {
        break;
      }
    }
    if (allFilesUploaded) {
      _userRecentListTableSaveCallBack(id);
    }
  }

  saveWeeklyTrackListDataOnFirebase(String id, List<SongDTO> list) async {
    bool allFilesUploaded = true;
    for (SongDTO song in list) {
      bool isErr = false;
      _dbRef
          .child("weekly_track_list")
          .child(id)
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
            _firebaseErrorCallBack(err);
          });
      if (isErr) {
        break;
      }
    }
    if (allFilesUploaded) {
      _userWeeklyChartListTableSaveCallBack(id);
    }
  }

  Future<String?> uploadFileFromStorage(String filePath) async {
    var file = File(filePath);
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("images/${FilePickerUtils.getName(p.basename(filePath))}");
    UploadTask uploadTask = await Future.value(storageReference.putFile(file));
    String? downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String?> uploadFileFromAssets(String filePath) async {
    String imageName = filePath
        .substring(filePath.lastIndexOf("/"), filePath.lastIndexOf("."))
        .replaceAll("/", "");

    final Directory systemTempDir = Directory.systemTemp;
    final byteData = await rootBundle.load(filePath);

    final file = File('${systemTempDir.path}/$imageName.jpeg');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    Reference storageReference =
        FirebaseStorage.instance.ref().child("images/$imageName");
    UploadTask uploadTask = await Future.value(storageReference.putFile(file));
    String? downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String?> uploadAudioFile(String filePath) async {
    /*String audioName = filePath
        .substring(filePath.lastIndexOf("/"), filePath.lastIndexOf("."))
        .replaceAll("/", "");

    final Directory systemTempDir = Directory.systemTemp;
    final byteData = await rootBundle.load(filePath);

    final file = File('${systemTempDir.path}/$audioName.mp3');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));*/
    var file = File(filePath);
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("audio/${FilePickerUtils.getName(p.basename(filePath))}");
    UploadTask uploadTask = await Future.value(storageReference.putFile(file));
    String? downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
}
