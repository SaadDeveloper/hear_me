import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/Preference.dart';

import '../selectmusicforsing/SelectMusicForSing.dart';

class MusicForYouSing extends StatefulWidget {

  final SongDTO? songsDto;

  const MusicForYouSing({Key? key, this.songsDto}) : super(key: key);

  @override
  _MusicForYouSingState createState() => _MusicForYouSingState();
}

class _MusicForYouSingState extends State<MusicForYouSing> {
  List<String> _musicList = [
    'Pop',
    'Hip-Hop',
    'Elektronische',
    'Rap',
    'Soul',
    'Oper',
    'Metal',
    'Blues',
    'Hause',
    'Jazz'
  ];
  /*parkhya Solutions*/
  List _selectedMusicList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> _selectedMusic = [];
  
  
  List<String> _resultList = [];
  List<String> _searchList = [];
  List<String> _languageList = [
    'Abkhaz',
    'Pashto',
    'Tamazight',
    'Arabic',
    'French',
    'Italian',
    'Bengali',
    'Portuguese',
    'Tswana',
    'Spanish',
    'Swahili',
    'Tshiluba',
    'Italian',
    'Romani',
    'English',
    'Russian',
    'French',
  ];

  TextEditingController _searchController = TextEditingController();
  late TextEditingController _titleNameController = TextEditingController();
  bool isShow = true;
  var selectChip = -1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeValues();
  }

  initializeValues(){
    _titleNameController.text = widget.songsDto == null? "": widget.songsDto!.song_name!;
    var vItems = widget.songsDto!.language;
    if (vItems != null) {
      if (vItems.trim().length > 0) {
        setState(() {
          vItems = vItems!.replaceAll("[", "");
          vItems = vItems!.replaceAll("]", "");
          _resultList.addAll(vItems!.split(", "));
        });
      }
    }
    var vGenreItems = widget.songsDto!.genre;
    if (vGenreItems != null) {
      if (vGenreItems.trim().length > 0) {
        vGenreItems = vGenreItems.replaceAll("[", "");
        vGenreItems = vGenreItems.replaceAll("]", "");
        _selectedMusic.addAll(vGenreItems.trim().split(", "));
      }
    }
    setState(() {
      for(int i=0; i<_musicList.length; i++){
        if(_selectedMusic.contains(_musicList[i])){
          _selectedMusicList[i] = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CColor.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _topBarWidget(),
                      _titleNameWidget(),
                      Visibility(
                        visible: isShow,
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 10.0, right: 10.0),
                          child: Text(
                            Languages.of(context)!.questionMusic,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            softWrap: true,
                            style: TextStyle(
                                color: CColor.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Visibility(visible: isShow, child: _chipForSongsWidget()),
                      _questionWidget(),
                      Expanded(
                          child: (isShow)
                              ? _resultListWidget()
                              : _languageListWidget()),
                    ],
                  ),
                ),
                Visibility(visible: isShow, child: _buttonWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _topBarWidget() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_left_outlined,
            size: 25.0,
            color: CColor.primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            Languages.of(context)!.txtReturn.toUpperCase(),
            maxLines: 1,
            softWrap: true,
            style: TextStyle(
                color: CColor.primary,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        )
      ],
    );
  }

  _chipForSongsWidget() {
    return InkWell(
      // onTap: () {},
      child: Container(
        // color: Colors.red,
        height: MediaQuery.of(context).size.height / 3.5,
        margin: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 0.0),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 10.0,
            runSpacing: 5.0,
            children: List<Widget>.generate(_musicList.length, (int index) {
              /*parkhya Solutions*/
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedMusicList[index] = !_selectedMusicList[index];
                  });
                },
                child: _itemChip(
                    _musicList[index], index, _selectedMusicList[index]),
              );
            }),
          ),
        ),
      ),
    );
  }

  _itemChip(String label, int index, selected) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      side: BorderSide(
        color: CColor.primary,
        width: 1.2,
        style: BorderStyle.solid,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      label: Text(
        label,
        maxLines: 1,
        softWrap: true,
        style: TextStyle(
            color: CColor.primary, fontSize: 14.0, fontWeight: FontWeight.w400),
      ),
      /*parkhya Solutions*/
      backgroundColor: selected ? Colors.white : CColor.black,
      padding: EdgeInsets.all(8.0),
    );
  }

  _titleNameWidget() {
    return Visibility(
      visible: isShow,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
            top: 20.0, left: 10.0, right: 10.0, bottom: 20.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              Languages.of(context)!.txtTitleName,
              textAlign: TextAlign.left,
              maxLines: 1,
              softWrap: true,
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              /*decoration: BoxDecoration(
                  color: CColor.bg_green,
                  borderRadius: BorderRadius.circular(10.0)),*/
              child: TextFormField(
                style: TextStyle(
                    color: CColor.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
                controller: _titleNameController,
                cursorColor: CColor.txt_gray,
                onFieldSubmitted: (text) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(5.0),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                      color: CColor.txt_gray,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Divider(
              color: CColor.txt_gray,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  _questionWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: isShow,
            child: Text(
              Languages.of(context)!.questionLanguageMusic,
              textAlign: TextAlign.left,
              maxLines: 1,
              softWrap: true,
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            /*decoration: BoxDecoration(
                color: CColor.bg_green,
                borderRadius: BorderRadius.circular(10.0)),*/
            child: TextFormField(
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
              controller: _searchController,
              cursorColor: CColor.txt_gray,
              onTap: () {
                _searchList = _languageList;
                setState(() {
                  isShow = false;
                });
              },
              onChanged: (text) {
                setState(() {
                  _onSearchTextChanged(text);
                });
              },
              onFieldSubmitted: (text) {
                FocusScope.of(context).unfocus();
                _onSearchTextChanged(text);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(8.0),
                border: InputBorder.none,
                hintText: Languages.of(context)!.txtNotes,
                hintStyle: TextStyle(
                    color: CColor.txt_gray,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          Divider(
            color: CColor.txt_gray,
            thickness: 1,
          ),
          Visibility(
            visible: !isShow,
            child: Container(
              margin: const EdgeInsets.only(top: 20.0, left: 10.0),
              child: Text(
                Languages.of(context)!.txtResult,
                textAlign: TextAlign.left,
                maxLines: 1,
                softWrap: true,
                style: TextStyle(
                    color: CColor.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _resultListWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10.0,
          runSpacing: 5.0,
          children: List<Widget>.generate(_resultList.length, (int index) {
            return _itemChipResult(_resultList[index], index);
          }),
        ),
      ),
    );
  }

  _itemChipResult(String label, int index) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      side: BorderSide(
        color: CColor.primary,
        width: 1.2,
        style: BorderStyle.solid,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      label: Text(
        label,
        maxLines: 1,
        softWrap: true,
        style: TextStyle(
            color: CColor.primary, fontSize: 14.0, fontWeight: FontWeight.w400),
      ),
      onDeleted: () {
        setState(() {
          _resultList.removeAt(index);
          log("message>>>>>$_resultList");
        });
      },
      deleteIcon: Icon(
        Icons.clear,
        size: 20.0,
        color: CColor.white,
      ),
      backgroundColor: CColor.black,
      padding: EdgeInsets.all(8.0),
    );
  }

  _buttonWidget() {
    return TextButton(
      child: Text(
        Languages.of(context)!.txtFurther.toUpperCase(),
        maxLines: 1,
        softWrap: true,
        style: TextStyle(
            color: CColor.white, fontSize: 12.0, fontWeight: FontWeight.w400),
      ),
      style: TextButton.styleFrom(
        primary: CColor.white,
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        backgroundColor: CColor.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
      onPressed: () {
        if(validate()){
          populateSelectedData();
          Navigator.pop(context, widget.songsDto);
        }
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => SelectMusicForSing((value) {
        //               return value;
        //             })));
      },
    );
  }

  _languageListWidget() {
    return Visibility(
      visible: !isShow,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        shrinkWrap: true,
        itemCount: _searchList.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemLanguage(index);
        },
      ),
    );
  }

  _itemLanguage(int index) {
    return InkWell(
      onTap: () {
        _resultList.add(_searchList[index]);
        FocusScope.of(context).unfocus();
        setState(() {
          isShow = true;

          log("list>>>>>>>>>$isShow");
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _searchList[index],
              maxLines: 1,
              softWrap: true,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: CColor.primary,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400),
            ),
            Divider(
              height: 25.0,
              color: CColor.txt_gray,
            ),
          ],
        ),
      ),
    );
  }

  _onSearchTextChanged(String _searchText) {
    setState(() {
      if (_searchText.isEmpty) {
        _searchList =
            _languageList; //_list.map((contact) =>  Uiitem(contact)).toList();
      } else {
        _searchList = _languageList
            .where((element) =>
                element.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();
        print('>>>>>>>>>>>>>>>>>>>>>>${_searchList.length}');
      }
    });
  }

  bool validate(){
    for(int i=0; i<_selectedMusicList.length; i++){
      if(_selectedMusicList[i] is bool){
        if(_selectedMusicList[i]){
          _selectedMusic.add(_musicList[i]);
        }
      }
    }
    if(_titleNameController.text.isEmpty){
      showSnackBar("Enter Title Name");
      return false;
    }else if(_selectedMusic.isEmpty){
      showSnackBar("Select at-least One Genre");
      return false;
    }else if(_resultList.isEmpty){
      showSnackBar("Select at-least One Language");
      return false;
    }
    return true;
  }
  populateSelectedData(){
    // Preference().setString(Preference.KEY_MUSIC_TYPE, _selectedMusic.toString());
    // Preference().setString(Preference.LANGUAGE, _resultList.toString());
    if(widget.songsDto != null){
      widget.songsDto!.song_name = _titleNameController.text;
      widget.songsDto!.genre = _selectedMusic.toString();
      widget.songsDto!.language = _resultList.toString();
    }
  }

  showSnackBar(String message){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(
          left: 100,
          right: 100,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        content: Text(message,
          style: TextStyle(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
