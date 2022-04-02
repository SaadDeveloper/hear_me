

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

typedef SampleCoverPhotos = List<String> Function(String);
typedef FirebaseErrorCallBack = Function();

class FirebaseMusicUploadUtils{
  late BuildContext context;
  late FirebaseDatabase mFirebaseDatabase;
  late DatabaseReference dbRef;
  late FirebaseAuth firebaseAuth;
  late FirebaseStorage firebaseStorage;
  late SampleCoverPhotos sampleCoverPhotos;
  late FirebaseErrorCallBack firebaseErrorCallBack;

  FirebaseMusicUploadUtils(BuildContext context) {
    this.context = context;
    mFirebaseDatabase = FirebaseDatabase.instance;
    firebaseStorage = FirebaseStorage.instance;
    firebaseAuth = FirebaseAuth.instance;
    dbRef = mFirebaseDatabase.reference();
  }

  Future<List<String>> getSampleCoverPhotos() async {
    List<String> musicCoverSamples = [];
    ListResult griefListResults = await firebaseStorage.ref().child("sample-covers/grief").listAll();
    griefListResults.items.map((e) async => musicCoverSamples.add(await e.getDownloadURL()));

    ListResult joyListResults = await firebaseStorage.ref().child("sample-covers/joy").listAll();
    joyListResults.items.map((e) async => musicCoverSamples.add(await e.getDownloadURL()));

    ListResult landscapeListResults = await firebaseStorage.ref().child("sample-covers/landscape").listAll();
    landscapeListResults.items.map((e) async => musicCoverSamples.add(await e.getDownloadURL()));

    ListResult summerListResults = await firebaseStorage.ref().child("sample-covers/summer").listAll();
    summerListResults.items.map((e) async => musicCoverSamples.add(await e.getDownloadURL()));

    ListResult winterListResults = await firebaseStorage.ref().child("sample-covers/winter").listAll();
    winterListResults.items.map((e) async => musicCoverSamples.add(await e.getDownloadURL()));

    return musicCoverSamples;
  }
}