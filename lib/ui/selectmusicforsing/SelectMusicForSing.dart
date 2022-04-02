import 'package:flutter/material.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/ui/enterDetails/EnterDetailsScreen.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:hear_me_final/utils/Utils.dart';

import '../home/HomeScreen.dart';

typedef StringValue = String Function(String);

class SelectMusicForSing extends StatefulWidget {
  @override
  _SelectMusicForSingState createState() => _SelectMusicForSingState();

  StringValue callback;

  SelectMusicForSing(this.callback);
}

class _SelectMusicForSingState extends State<SelectMusicForSing> {
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

  /*parkhya Solutions*/

  List<String> _resultMusic = [];
  List<String> _searchList = []

      // 'Pop', 'Hip-Hop', 'Elektronische'
      ;

  TextEditingController _searchController = TextEditingController();
  bool isShow = true;
  var selectChip = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    String vItems =
        Preference().getString(Preference.KEY_MUSIC_TYPE_OTHER).toString();
    if (vItems != null) {
      if (vItems.trim().length > 0) {
        setState(() {
          vItems = vItems.replaceAll("[", "");
          vItems = vItems.replaceAll("]", "");
          _searchList.addAll(vItems.split(","));
        });
      }
    }
    print("Music SEt..${Preference().getString(Preference.KEY_MUSIC_TYPE_OTHER)}");
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
                      Container(
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
                      _chipForSongsWidget(),
                      _questionWidget(),
                      Expanded(child: (isShow) ? _searchListWidget() : Container())
                    ],
                  ),
                ),
                _buttonWidget(),
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
    return Container(
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
    );
  }

  /*parkhya Solutions*/

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

  _questionWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Languages.of(context)!.questionMusic,
            textAlign: TextAlign.left,
            maxLines: 1,
            softWrap: true,
            style: TextStyle(
                color: CColor.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
          TextFormField(
            style: TextStyle(
                color: CColor.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
            controller: _searchController,
            cursorColor: CColor.txt_gray,
            decoration: InputDecoration(
              hintText: Languages.of(context)!.txtNotes,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    if (_searchController.text != "") {
                      _searchList.add(_searchController.text);
                      isShow = true;
                    } else {
                      Utils.showToast(context, "Search value cannot be blank.");
                    }
                  });
                  _searchController.text = "";

                  //  Preference().setString(Preference.KEY_MUSIC_TYPE, "search");
                },
                child: new Icon(Icons.done_rounded, color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: CColor.txt_gray),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: CColor.txt_gray),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: CColor.txt_gray),
              ),
              contentPadding: const EdgeInsets.all(0.0),
              hintStyle: TextStyle(
                  color: CColor.txt_gray,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  _searchListWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 10.0,
          runSpacing: 5.0,
          children: List<Widget>.generate(_searchList.length, (int index) {
            return _itemChipSearch(
                // Preference().getLoginBool(Preference.IS_LOGIN))

                // Preference().getString(Preference.KEY_MUSIC_TYPE)
                _searchList[index],
                index);
          }),
        ),
      ),
    );
  }

  _itemChipSearch(String label, int index) {
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
            color: CColor.primary,
            // color: Colors.amber,
            fontSize: 14.0,
            fontWeight: FontWeight.w400),
      ),
      onDeleted: () {
        setState(() {
          _searchList.removeAt(index);
          if(_searchList.length == 0){
            isShow = false;
          }else{
            isShow = true;
          }
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
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextButton(
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
          print("Music......${_searchList.toString()}");

          if(_searchList.isNotEmpty) {
            Preference()
                .setString(Preference.KEY_MUSIC_TYPE_OTHER, _searchList.toString());
          }

          if (Preference().getLoginBool(Preference.IS_LOGIN) == true) {
            widget.callback(_searchController.text);
            Navigator.pop(context);
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EnterDetailsScreen()));
          }
        },
      ),
    );
  }
}
