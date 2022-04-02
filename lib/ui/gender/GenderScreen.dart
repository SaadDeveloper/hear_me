import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/ui/enterDetails/EnterDetailsScreen.dart';
import 'package:hear_me_final/ui/gender/model/UserStageDetails.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:hear_me_final/utils/Utils.dart';
import 'package:hear_me_final/validator/EmailValidator.dart';

import '../musicforyousing/MusicForYouSing.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  var fullHeight;
  var fullWidth;
  final GlobalKey formKey = GlobalKey();
  TextEditingController _nameController = TextEditingController(text: "Name");
  int gender = 1;
  bool male = true;
  bool female = false;
  bool bipolar = false;
  bool isVoiceSoundMale = true;
  String dropdownValueDays = '1';
  String dropdownValueMonth = '1';
  String dropdownValueYear = '1960';
  List<String> listyear = [];
  var MyIntiValue = "";
  @override
  void initState() {
    super.initState();
    Preference().getBool(Preference.IS_LOGIN) == true
        ? MyIntiValue = ('${Preference().getString(Preference.KEY_STAGE_NAME)}')
        : log("message");
    _nameController.text = MyIntiValue;

    if(Preference().getString(Preference.KEY_STAGE_NAME) != null){
      _nameController.text = Preference().getString(Preference.KEY_STAGE_NAME)!;
    }
    if (Preference().getString(Preference.KEY_DAY) != null) {
      setState(() {
        dropdownValueDays =
            Preference().getString(Preference.KEY_DAY).toString();
      });
    }
    if (Preference().getString(Preference.KEY_MONTH) != null) {
      setState(() {
        dropdownValueMonth =
            Preference().getString(Preference.KEY_MONTH).toString();
      });
    }
    if (Preference().getString(Preference.KEY_YEAR) != null) {
      setState(() {
        dropdownValueYear =
            Preference().getString(Preference.KEY_YEAR).toString();
      });
    }

    if (Preference().getString(Preference.KEY_GENDER) == "male") {
      setState(() {
        male = true;
        female = false;
        bipolar = false;
      });
    } else if (Preference().getString(Preference.KEY_GENDER) == "female") {
      setState(() {
        male = false;
        female = true;
        bipolar = false;
      });
    } else if (Preference().getString(Preference.KEY_GENDER) == "other") {
      setState(() {
        male = false;
        female = false;
        bipolar = true;
      });
    }

    if (Preference().getString(Preference.KEY_VOICE) == "is_voice_yes") {
      setState(() {
        isVoiceSoundMale = true;
      });
    } else if (Preference().getString(Preference.KEY_VOICE) == "is_voice_no") {
      setState(() {
        isVoiceSoundMale = false;
      });
    }

    _listdata();
  }

  _listdata() {
    for (int i = 1960; i < 2020; i++) {
      listyear.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    fullHeight = MediaQuery.of(context).size.height;
    fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CColor.pure_black,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.only(top: 40, left: 10, right: 10),
          color: CColor.pure_black,
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Container(
              height: fullHeight * 0.9,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    // padding: EdgeInsets.only(bottom: 100),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: fullHeight * 0.08),
                          child: Text(
                            Languages.of(context)!.stageName,
                            style: TextStyle(color: CColor.white, fontSize: 19),
                          ),
                        ),
                        TextFormField(
                          cursorColor: CColor.white,
                          controller: _nameController,
                          onEditingComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Name";
                            } else if (!EmailValidator.validate(value, false)) {
                              return "Please Enter Valid Email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                        Divider(
                          color: CColor.txt_gray,
                          thickness: 1,
                        ),
                        _gender(fullHeight),
                        _doesYourVoiceSoundWidget(fullHeight),
                        _furtherWidget(fullHeight),
                        _submitButton(),
                      ],
                    ),
                  )
                  // _nameField(fullHeight),
                ],
                /*child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _nameField(fullHeight),
                  ],
                ),*/
              ),
            ),
          ),
        ),
      ),
    );
  }

  _nameField(fullHeight) {
    return Expanded(
      /*parkhya Solutions*/
      child: ListView(
        children: [
          Container(
            // color: Colors.red,

            padding: EdgeInsets.only(left: 10, right: 10),
            // padding: EdgeInsets.only(bottom: 100),
            child: Column(
              children: [

              ],
            ),
          ),
        ],
      ),
    );
  }

  _gender(fullHeight) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: fullHeight * 0.1),
            child: Text(
              Languages.of(context)!.gender,
              style: TextStyle(color: CColor.white, fontSize: 13),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    //  Preference().getBool(Preference.KEY_GENDER);
                    male = true;
                    female = false;
                    bipolar = false;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/icons/ic_male.png',
                        color: (male) ? CColor.primary : CColor.grey,
                        width: 55,
                        height: 55,
                      ),
                    ),
                    Text(
                      Languages.of(context)!.txtMale,
                      style: TextStyle(color: (male) ? CColor.primary :  CColor.white, fontSize: 13),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    male = false;
                    female = true;
                    bipolar = false;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Image.asset(
                        'assets/icons/ic_female.png',
                        color: (female) ? CColor.primary : CColor.grey,
                        width: 55,
                        height: 55,
                      ),
                    ),
                    Text(
                      Languages.of(context)!.txtFemale,
                      style: TextStyle(color: (female) ? CColor.primary :  CColor.white, fontSize: 13),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    male = false;
                    female = false;
                    bipolar = true;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/icons/ic_bipolar.png',
                        color: (bipolar) ? CColor.primary : CColor.grey,
                        width: 55,
                        height: 55,
                      ),
                    ),
                    Text(
                      Languages.of(context)!.txtOther,
                      style: TextStyle(color: (bipolar) ? CColor.primary :  CColor.white, fontSize: 13),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _doesYourVoiceSoundWidget(fullHeight) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                top: fullHeight * 0.04, bottom: fullHeight * 0.01),
            child: Text(
              Languages.of(context)!.doesYourVoiceSound,
              style: TextStyle(color: CColor.white, fontSize: 13),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isVoiceSoundMale = true;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/icons/ic_male.png',
                        color: (isVoiceSoundMale) ? CColor.primary : CColor.grey,
                        width: 55,
                        height: 55,
                      ),
                    ),
                    Text(
                      Languages.of(context)!.txtMale,
                      style: TextStyle(color: (isVoiceSoundMale) ? CColor.primary :  CColor.white, fontSize: 13),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isVoiceSoundMale = false;
                  });
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Image.asset(
                        'assets/icons/ic_female.png',
                        color: (!isVoiceSoundMale) ? CColor.primary : CColor.grey,
                        width: 55,
                        height: 55,
                      ),
                    ),
                    Text(
                      Languages.of(context)!.txtFemale,
                      style: TextStyle(color: (!isVoiceSoundMale) ? CColor.primary :  CColor.white, fontSize: 13),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _furtherWidget(fullHeight) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                top: fullHeight * 0.04, bottom: fullHeight * 0.01),
            child: Text(
              Languages.of(context)!.further,
              style: TextStyle(color: CColor.white, fontSize: 13),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: dropdownValueDays,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: CColor.grey),
                  underline: Container(
                    height: 2,
                    color: CColor.grey,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueDays = newValue!;
                    });
                  },
                  items: <String>[
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                    '11',
                    '12',
                    '13',
                    '14',
                    '15',
                    '16',
                    '17',
                    '18',
                    '19',
                    '20',
                    '21',
                    '22',
                    '23',
                    '24',
                    '25',
                    '26',
                    '27',
                    '28',
                    '29',
                    '30',
                    '31'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  width: 10,
                ),
                DropdownButton<String>(
                  value: dropdownValueMonth,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: CColor.grey),
                  underline: Container(
                    height: 2,
                    color: CColor.grey,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueMonth = newValue!;
                    });
                  },
                  items: <String>[
                    '1',
                    '2',
                    '3',
                    '4',
                    '5',
                    '6',
                    '7',
                    '8',
                    '9',
                    '10',
                    '11',
                    '12'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  width: 10,
                ),
                DropdownButton<String>(
                  value: dropdownValueYear,
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: CColor.grey),
                  underline: Container(
                    height: 2,
                    color: CColor.grey,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValueYear = newValue!;
                    });
                  },
                  items: listyear.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /*parkhya Solutions*/
  _submitButton() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: TextButton(
          onPressed: () {
            if (_nameController.text != '') {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => MusicForYouSing()));
              // print("Male...$male");
              // print("Female...$female");
              // print("Other...$bipolar");
              // print("voice...$isVoiceSoundMale");

              print("day...$dropdownValueDays");
              print("month...$dropdownValueMonth");
              print("year...$dropdownValueYear");
              Preference().setString(Preference.KEY_STAGE_NAME, _nameController.text);
              Preference().setString(Preference.KEY_DAY, dropdownValueDays);
              Preference().setString(Preference.KEY_DAY, dropdownValueDays);
              Preference().setString(Preference.KEY_MONTH, dropdownValueMonth);
              Preference().setString(Preference.KEY_YEAR, dropdownValueYear);

              String userVoice = "";
              if (isVoiceSoundMale) {
                userVoice = "male_voice";
                Preference().setString(Preference.KEY_VOICE, "is_voice_yes");
              } else {
                userVoice = "female_voice";
                Preference().setString(Preference.KEY_VOICE, "is_voice_no");
              }

              String gender = "";
              if (male) {
                gender = "male";
                Preference().setString(Preference.KEY_GENDER, "male");
              } else if (female) {
                gender = "female";
                Preference().setString(Preference.KEY_GENDER, "female");
              } else if (bipolar) {
                gender = "other";
                Preference().setString(Preference.KEY_GENDER, "other");
              }
              int age = Utils.calculateDate(int.parse(dropdownValueYear), int.parse(dropdownValueMonth), int.parse(dropdownValueDays));
              UserStageDetails userStageDetails = new UserStageDetails(userStageName: _nameController.text, gender: gender,
              userVoiceSound: userVoice, dateOfBirth: age.toString());

              String detailStr = jsonEncode(userStageDetails.toJson());
              Preference().setString(Preference.USER_STAGE_DETAILS, detailStr);

              // String prefDetails = Preference().getString(Preference.USER_STAGE_DETAILS)!;
              // UserStageDetails userStageDetailsDecode = UserStageDetails.fromJson(jsonDecode(prefDetails) as Map<String, dynamic>);
              Preference().getLoginBool(Preference.IS_LOGIN) == true
                  ? Navigator.pop(context)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => /*MusicForYouSing()*/EnterDetailsScreen()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Enter Your Stage Name"),
                ),
              );
            }
          },
          child: Text(
            Languages.of(context)!.further.toUpperCase(),
            maxLines: 1,
            softWrap: true,
            style: TextStyle(
                color: CColor.white,
                fontSize: 12.0,
                fontWeight: FontWeight.w400),
          ),
          style: TextButton.styleFrom(
            primary: CColor.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
            backgroundColor: CColor.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
          )),
    );
  }
}
