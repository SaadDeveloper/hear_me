import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_broadcast_receiver/flutter_broadcast_receiver.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:hear_me_final/custom/drawer/DrawerMenu.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/custom/tabbar/CustomTabBar.dart';
import 'package:hear_me_final/firebase/FirebaseHomeUtils.dart';
import 'package:hear_me_final/firebase/FirebaseInstantiation.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/serviceUtils/FirstTaskHandler.dart';
import 'package:hear_me_final/ui/login/LogInScreen.dart';
import 'package:hear_me_final/ui/player/PlayerScreen.dart';
import 'package:hear_me_final/ui/selectmusicforsing/SelectMusicForSing.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/Constant.dart';
import 'package:hear_me_final/utils/Preference.dart';

void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class HomeScreen extends StatefulWidget {
  final bool fromSignup;

  const HomeScreen(
      {Key? key, required this.fromSignup})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isFavorite = false;
  int currentIndex = 0;
  String editableText = "";
  dynamic data;
  List<SongDTO> toptrack = [];
  List<SongDTO> topUsers = [];
  List<SongDTO> trackList = [];
  List<SongDTO> kooperationpartner = [];
  List<SongDTO> recentTracks = [];
  late FirebaseHomeUtils firebaseHomeUtils;
  late FirebaseInstantiation _firebaseInstantiation;
  PageController pageController = PageController(initialPage: 0);
  TabController? _tabController;
  final globalKey = GlobalKey<ScaffoldState>();
  ReceivePort? _receivePort;

  bool isFilterOn = true;

  @override
  void initState() {
    super.initState();
    data = '';
    toptrack = [];
    topUsers = [];
    kooperationpartner = [];
    firebaseHomeUtils = FirebaseHomeUtils(context);
    if(widget.fromSignup){
      _initForegroundTask();
    }else{
      getTrackLists();
    }
    _tabController = TabController(length: 3, vsync: this);
  }

  void getTrackLists(){
    firebaseHomeUtils.checkIfUserLoggedIn((){
      firebaseHomeUtils.getTopTracksList().then((value){
        setState(() {
          toptrack.addAll(value);
        });
      });
      firebaseHomeUtils.getAllTracksList().then((value){
        setState(() {
          trackList.addAll(value);
        });
      });
      firebaseHomeUtils.getRecentTracksList().then((value){
        setState(() {
          recentTracks.addAll(value);
        });
      });
    }, (){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogInScreen()),
      );
    });
  }

  void _initForegroundTask() async{
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription: 'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: true,
      ),
      printDevLog: true,
    );
    _startForegroundTask();
  }

  void _startForegroundTask() async {
    if (await FlutterForegroundTask.isRunningService) {
      _receivePort = await FlutterForegroundTask.restartService();
    } else {
      _receivePort = await FlutterForegroundTask.startService(
        notificationTitle: 'Uploading Tracks...',
        notificationText: '0 of 0',
        callback: startCallback,
      );
    }
    List<SongDTO> tracks = _uploadTracks();
    FlutterForegroundTask.updateService(
        notificationTitle: 'Uploading Tracks...',
        notificationText: '1 of ${tracks.length}');
    BroadcastReceiver().subscribe<String>(Constant.BROADCAST_CHANNEL,
            (String message) {
          FlutterForegroundTask.updateService(
              notificationTitle: 'Uploading Tracks...',
              notificationText: '$message of ${tracks.length}');
        });
    /*_receivePort?.listen((message) {
      if(message is bool){
        if(message){
          getTrackLists();
        }
      }else if(message is int){
        FlutterForegroundTask.updateService(
            notificationTitle: 'Uploading Tracks...',
            notificationText: '$message of ${tracks.length + 1}');
      }
    });*/
  }

  List<SongDTO> _uploadTracks(){
    _firebaseInstantiation = new FirebaseInstantiation(
            (user) {},
            (id) {},
            (id) {},
            (id) {},
            (id, songsList) {
          _firebaseInstantiation.saveTopTrackListDataOnFirebase(id, songsList);
        },
            (id, songsList) {
          _firebaseInstantiation.saveWeeklyTrackListDataOnFirebase(
              id, songsList);
        },
            (id) {},
            (id) {},
            (id) {
          Preference().setString(Preference.SONG_LIST, "");
              print("Home Screen - All Files uploaded");
          FlutterForegroundTask.stopService();
          getTrackLists();
        }, (err) {
      FlutterForegroundTask.stopService();
    });

    String? prefDetails = Preference().getString(Preference.SONG_LIST);
    if (prefDetails != null && prefDetails.isNotEmpty) {
      List<SongDTO> prefList = List<SongDTO>.from(
          json.decode(prefDetails).map((model) => SongDTO.fromJson(model)));
      _firebaseInstantiation.saveUserTrackListDataOnFirebase(
          _firebaseInstantiation.getFirebaseAuthId()!, prefList);
      return prefList;
    }else{
      FlutterForegroundTask.stopService();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        key: globalKey,
        drawer: DrawerMenu(),
        body: Container(
          padding: EdgeInsets.only(top: 30),
          color: CColor.pure_black,
          child: Column(
            children: [
              _topBar(), //context
              _forYouWidget(),
              _customTabBarView(),
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _categoryAllTracksList(),
                      _categoryTopTracks(),
                      _categoryRecentTracks(),
                      _categoryTopUser(),
                      _categoryCorporation()
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: CColor.pure_black,
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: CColor.bg_black, blurRadius: 10),
                  ],
                ),
                child: ClipRRect(
                  child: bottomItems(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _topBar() {
    //BuildContext context
    return Container(
      width: double.infinity,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                globalKey.currentState!.openDrawer();
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
            SizedBox(
              width: 40,
              height: 40,
            ),
            Expanded(child: Image.asset("assets/images/hear_me_logo.png")),
            InkWell(
              onTap: () {
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectMusicForSing((value) {
                              editableText = value;
                              toptrack.clear();
                              mFirebaseDatabase
                                  .reference()
                                  .child("top_track")
                                  .once()
                                  .then((DataSnapshot snapshot) {
                                print('Data : ${snapshot.value}');
                                Map<dynamic, dynamic> yearMap = snapshot.value;
                                yearMap.forEach((key, value) {
                                  print("${value['song_catalog']}");
                                  setState(() {
                                    if (value['song_catalog']
                                        .contains(editableText)) {
                                      toptrack.add(SongDTO.fromJson(value));
                                    }
                                  });
                                });
                                print("${toptrack.length}");
                              });
                              topUsers.clear();
                              mFirebaseDatabase
                                  .reference()
                                  .child("top_user")
                                  .once()
                                  .then((DataSnapshot snapshot) {
                                print('Data : ${snapshot.value}');
                                Map<dynamic, dynamic> yearMap = snapshot.value;
                                yearMap.forEach((key, value) {
                                  print("$value");
                                  setState(() {
                                    if (value['song_catalog']
                                        .contains(editableText)) {
                                      topUsers.add(SongDTO.fromJson(value));
                                    }
                                  });
                                });
                                print("${topUsers.length}");
                              });
                              topUsers.clear();
                              mFirebaseDatabase
                                  .reference()
                                  .child("kooperationpartner")
                                  .once()
                                  .then((DataSnapshot snapshot) {
                                print('Data : ${snapshot.value}');
                                Map<dynamic, dynamic> yearMap = snapshot.value;
                                yearMap.forEach((key, value) {
                                  print("$value");
                                  setState(() {
                                    if (value['song_catalog']
                                        .contains(editableText)) {
                                      kooperationpartner
                                          .add(SongDTO.fromJson(value));
                                    }
                                  });
                                });
                                print("${kooperationpartner.length}");
                              });

                              return editableText = value;
                            })));*/
              },
              child: Container(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.search,
                  color: CColor.white,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isFilterOn = !isFilterOn;
                });
              },
              child: Container(
                height: 40,
                width: 40,
                child: Icon(
                  Icons.filter_alt,
                  color: isFilterOn ? CColor.white : CColor.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _forYouWidget() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 15, bottom: 15),
      alignment: Alignment.centerLeft,
      child: Text(
        Languages.of(context)!.forYou,
        style: TextStyle(
            color: CColor.white, fontSize: 21, fontWeight: FontWeight.w500),
      ),
    );
  }

  _customTabBarView() {
    return Container(
        padding: EdgeInsets.only(bottom: 10, left: 10),
        width: double.infinity,
        child: CustomTab(
          tabController: _tabController!,
          tabs: [
            Tab(
              child: Container(
                width: 200,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    //color: selctedPos != 0 ? Colur.white :Colors.transparent, //TODo Uncomment this line for white color while tab is unselected
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: CColor.primary, width: 1)),
                child: Center(
                  child: Text(
                    "Recent",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                width: 200,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    // color: selctedPos != 1 ? Colur.white :Colors.transparent, //TODo Uncomment this line for white color while tab is unselected
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: CColor.primary, width: 1)),
                child: Center(
                  child: Text("Weekly",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ),
            ),
            Tab(
              child: Container(
                width: 200,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    //color: selctedPos != 0 ? Colur.white :Colors.transparent, //TODo Uncomment this line for white color while tab is unselected
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: CColor.primary, width: 1)),
                child: Center(
                  child: Text(
                    "Daily",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  BottomNavigationBar bottomItems() {
    return BottomNavigationBar(
      backgroundColor: CColor.pure_black,
      onTap: (int index) {
        setState(() {
          currentIndex = index;
        });
      },
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      elevation: 20.0,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: Icon(
                  currentIndex == 0
                      ? Icons.chat_bubble
                      : Icons.chat_bubble_outline,
                  size: 25,
                  color: currentIndex == 0 ? CColor.primary : CColor.grey,
                ),
              ),
            ],
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: Icon(
                  currentIndex == 1 ? Icons.search : Icons.search,
                  size: 25,
                  color: currentIndex == 1 ? CColor.primary : CColor.grey,
                ),
              ),
            ],
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: Icon(
                  currentIndex == 2
                      ? Icons.music_note_rounded
                      : Icons.music_note_outlined,
                  size: 25,
                  color: currentIndex == 2 ? CColor.primary : CColor.grey,
                ),
              ),
            ],
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: Icon(
                  currentIndex == 3
                      ? Icons.person
                      : Icons.person_outline_rounded,
                  size: 25,
                  color: currentIndex == 3 ? CColor.primary : CColor.grey,
                ),
              ),
            ],
          ),
          title: SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 5.0, top: 10.0),
                child: Icon(
                  currentIndex == 4 ? Icons.people : Icons.people_alt_outlined,
                  size: 25,
                  color: currentIndex == 4 ? CColor.primary : CColor.grey,
                ),
              ),
            ],
          ),
          title: SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _categoryRecentTracks() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            // color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              Languages.of(context)!.txtRecentTracks,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CColor.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9.5,
            child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: recentTracks.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int pos) {
                    return _songsViewTracks(
                        recentTracks[pos]); //context, pos, index
                  },
                )),
          ),
        ],
      ),
    );
  }

  /*parkhya Solutions*/
  Widget _categoryCorporation() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            // color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              Languages.of(context)!.txtCorporationPartner,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CColor.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9.5,
            child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: kooperationpartner.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int pos) {
                    return _songViewKooperations(
                        kooperationpartner[pos]); //context, pos, index
                  },
                )),
          ),
        ],
      ),
    );
  }

  /*parkhya Solutions*/
  Widget _categoryAllTracksList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            // color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              Languages.of(context)!.txtTrackList,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CColor.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9.5,
            child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: trackList.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int pos) {
                    return _songsViewTracks(trackList[pos]); //context, pos, index
                  },
                )),
          ),
        ],
      ),
    );
  }

  /*parkhya Solutions*/
  Widget _categoryTopUser() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            // color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              Languages.of(context)!.txtTopUsers,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CColor.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9.5,
            child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: topUsers.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int pos) {
                    return _songsViewUser(topUsers[pos]); //context, pos, index
                  },
                )),
          ),
        ],
      ),
    );
  }

  /*parkhya Solutions*/
  Widget _categoryTopTracks() {
    //BuildContext context, int index
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            // color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              Languages.of(context)!.txtTopTracks,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CColor.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 16 / 9.5,
            child: Container(
                margin: EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: toptrack.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int pos) {
                    //toptrack[pos].
                    return _songsViewTracks(
                        toptrack[pos]); //context, pos, index
                  },
                )),
          ),
        ],
      ),
    );
  }

  /*parkhya Solutions*/
  Widget _songViewKooperations(SongDTO songDTO) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // if you need this
        ),
        child: Container(
          width: 185,
          //  height: 100,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(songDTO.song_image!),

              // image: AssetImage('assets/images/bg_forest.jpeg'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: Container(
                        child: !isFavorite
                            ? Icon(
                                Icons.favorite_border,
                                color: CColor.light_primary,
                                size: 35,
                              )
                            : Icon(
                                Icons.favorite,
                                color: CColor.light_primary,
                                size: 35,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 7.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              songDTO.song_name!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: CColor.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          // Container(
                          //   child: Text(
                          //     "42",
                          //     style: TextStyle(
                          //         color: CColor.white,
                          //         fontWeight: FontWeight.w500,
                          //         fontSize: 16),
                          //   ),
                          // ),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 PlayerScreen(globalKey)));
                          //   },
                          //   child: Container(
                          //     margin: EdgeInsets.only(left: 10, right: 7),
                          //     height: 40,
                          //     width: 40,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(15.0),
                          //       ),
                          //       color: CColor.light_primary,
                          //     ),
                          //     child: Icon(
                          //       Icons.play_arrow_rounded,
                          //       color: CColor.white,
                          //       size: 36,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*parkhya Solutions*/
  Widget _songsViewUser(SongDTO songDTO) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // if you need this
        ),
        child: Container(
          width: 185,
          // height: 10,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            image: DecorationImage(
              fit: BoxFit.fill,
              //image: AssetImage('assets/images/bg_forest.jpeg'),

              image: NetworkImage(songDTO.song_image!),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: Container(
                        child: !isFavorite
                            ? Icon(
                                Icons.favorite_border,
                                color: CColor.light_primary,
                                size: 35,
                              )
                            : Icon(
                                Icons.favorite,
                                color: CColor.light_primary,
                                size: 35,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              songDTO.song_name!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: CColor.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          Container(
                            child: Text(
                              "42",
                              style: TextStyle(
                                  color: CColor.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayerScreen(
                                          globalKey,
                                          songDTO
                                          //songDTO:songDTO
                                          //  songDTO
                                          )));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 7),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                                color: CColor.light_primary,
                              ),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: CColor.white,
                                size: 36,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*parkhya Solutions*/
  Widget _songsViewTracks(SongDTO songDTO) {
    //BuildContext context, int pos, int index
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // if you need this
        ),
        child: Container(
          width: 185,

          // height: 10,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(songDTO.song_image!),

              //  image: AssetImage('assets/images/bg_forest.jpeg'),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      child: Container(
                        child: !isFavorite
                            ? Icon(
                                Icons.favorite_border,
                                color: CColor.light_primary,
                                size: 35,
                              )
                            : Icon(
                                Icons.favorite,
                                color: CColor.light_primary,
                                size: 35,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              songDTO.song_name!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: CColor.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          )/*,
                          Container(
                            child: Text(
                              "42",
                              style: TextStyle(
                                  color: CColor.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          )*/,
                          InkWell(
                            onTap: () {
                              if(recentTracks.isNotEmpty){
                                bool found = false;
                                recentTracks.forEach((element) {
                                  if(element.song_id == songDTO.song_id){
                                    found = true;
                                  }
                                });
                                if(!found){
                                  setState(() {
                                    recentTracks.add(songDTO);
                                  });
                                }
                              }else{
                                setState(() {
                                  recentTracks.add(songDTO);
                                });
                              }
                              firebaseHomeUtils.saveRecentTrackListDataOnFirebase(recentTracks, (value) {}, () {});
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlayerScreen(
                                          globalKey,
                                          songDTO)));
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 7),
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                                color: CColor.light_primary,
                              ),
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: CColor.white,
                                size: 36,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    BroadcastReceiver().unsubscribe("BROADCAST_RECEIVER_DEMO");
    _receivePort?.close();
    FlutterForegroundTask.stopService();
    super.dispose();
  }
}
