import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/ui/enterDetails/datamodel/PersonalDataModel.dart';
import 'package:hear_me_final/ui/personalMusicPreference/PersonalMusicPreference.dart';
import 'package:hear_me_final/ui/uploadMusic/UploadMusicScreen.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/Debug.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:hear_me_final/utils/Utils.dart';

class EnterDetailsScreen extends StatefulWidget {
  const EnterDetailsScreen({Key? key}) : super(key: key);

  @override
  _EnterDetailsScreenState createState() => _EnterDetailsScreenState();
}

class _EnterDetailsScreenState extends State<EnterDetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController whoAreYouController = TextEditingController();
  TextEditingController searchingController = TextEditingController();

  bool? isUnderContract = false;
  bool? isNotUnderContract = false;

  PersonalDataModel? personalDataModel = PersonalDataModel();

  @override
  void initState() {
    super.initState();
    populateDateIfExist();
  }

  populateDateIfExist() {
    String? prefDetails =
        Preference().getString(Preference.USER_PERSONAL_DETAILS);
    if (prefDetails != null && prefDetails.isNotEmpty) {
      personalDataModel = PersonalDataModel.fromJson(json.decode(prefDetails));
      nameController.text =
          personalDataModel!.name == null ? "" : personalDataModel!.name!;
      contactController.text =
          personalDataModel!.contact == null ? "" : personalDataModel!.contact!;
      emailController.text =
          personalDataModel!.email == null ? "" : personalDataModel!.email!;
      passwordController.text = personalDataModel!.password == null
          ? ""
          : personalDataModel!.password!;
      addressController.text =
          personalDataModel!.address == null ? "" : personalDataModel!.address!;
      whoAreYouController.text =
          personalDataModel!.iAm == null ? "" : personalDataModel!.iAm!;
      searchingController.text = personalDataModel!.lookingFor == null
          ? ""
          : personalDataModel!.lookingFor!;
      isUnderContract = personalDataModel!.contractFlag!;
      isNotUnderContract = !isUnderContract!;
      /*if (personalDataModel!.contract == null) {
        isUnderContract = false;
      } else {
        if (personalDataModel!.contract! ==
            Languages.of(context)!.txtIHaveContract) {
          isUnderContract = true;
        } else if (personalDataModel!.contract! ==
            Languages.of(context)!.txtIDontHaveAContract) {
          isNotUnderContract = true;
        } else {
          isUnderContract = false;
          isNotUnderContract = false;
        }
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    var fullHeight = MediaQuery.of(context).size.height;
    var fullWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () {
        setData();
        return new Future(() => true);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CColor.black,
        body: SafeArea(
          child: Column(
            children: [
              //=========Topbar==========
              topbarWidget(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //========TextFields
                      textfieldsWidget(),
                      //========checkbox=======
                      checkBoxWidget(),
                    ],
                  ),
                ),
              ),
              //=======Further btn======
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

  textfieldsWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          //======Name==========
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: Languages.of(context)!.txtName,
                hintStyle: TextStyle(
                    color: CColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
              ),
              cursorColor: CColor.white,
              controller: nameController,
              maxLines: 1,
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
          ),
          //=====Contact=====
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: Languages.of(context)!.txtContact + ":",
                hintStyle: TextStyle(
                    color: CColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
              ),
              cursorColor: CColor.white,
              controller: contactController,
              maxLines: 1,
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              maxLength: 10,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),
          //=======Email=======
          /*parkhya Solutions*/
          Container(
            margin: EdgeInsets.only(top: 0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: Languages.of(context)!.txtEmail + ":",
                hintStyle: TextStyle(
                    color: CColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
              ),
              cursorColor: CColor.white,
              controller: emailController,
              maxLines: 1,
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              maxLength: 30,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
          ),
          //=========Password======
          /*parkhya Solutions*/
          Container(
            margin: EdgeInsets.only(top: 0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: Languages.of(context)!.txtPassword + ":",
                hintStyle: TextStyle(
                    color: CColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
              ),
              cursorColor: CColor.white,
              controller: passwordController,
              maxLines: 1,
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              maxLength: 10,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
          ),

          //====Address=====
          Container(
            margin: EdgeInsets.only(top: 0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: Languages.of(context)!.txtAddress + ":",
                hintStyle: TextStyle(
                    color: CColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
              ),
              cursorColor: CColor.white,
              controller: addressController,
              maxLines: 1,
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              //maxLength: 10,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
          ),
          //====Who are you=====
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: Languages.of(context)!.txtWhoAreYou,
                hintStyle: TextStyle(
                    color: CColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
              ),
              cursorColor: CColor.white,
              controller: whoAreYouController,
              maxLines: 1,
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              //maxLength: 10,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
          ),
          //====What are you searching for=====
          Container(
            margin: EdgeInsets.only(top: 20),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: Languages.of(context)!.txtWhatAreYouSearchingFor,
                hintStyle: TextStyle(
                    color: CColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: CColor.white),
                ),
              ),
              cursorColor: CColor.white,
              controller: searchingController,
              maxLines: 1,
              style: TextStyle(
                  color: CColor.white,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
              //maxLength: 10,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
    );
  }

  checkBoxWidget() {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //=====Are you already under contract txt=======
          Text(
            Languages.of(context)!.txtAreYouAlreadyUnderContract,
            style: TextStyle(
                color: CColor.white,
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
          //========checkboxes container=========
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //=====yes checkbox=====
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          border: Border.all(color: CColor.white)),
                      child: Theme(
                        data: ThemeData(
                            unselectedWidgetColor: CColor.transparent),
                        child: Checkbox(
                          value: isUnderContract!,
                          tristate: false,
                          onChanged: (value) {
                            setState(() {
                              isUnderContract = value;
                              isNotUnderContract = false;
                            });
                          },
                          //side: BorderSide(color: CColor.white),
                          activeColor: CColor.transparent,
                          checkColor: CColor.primary,
                        ),
                      ),
                    ),
                    Text(
                      Languages.of(context)!.txtYes,
                      style: TextStyle(
                          color: CColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                //========"/"=========
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "/",
                    style: TextStyle(
                        color: CColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                //========no checkbox=======
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          border: Border.all(color: CColor.white)),
                      child: Theme(
                        data: ThemeData(
                            unselectedWidgetColor: CColor.transparent),
                        child: Checkbox(
                          value: isNotUnderContract!,
                          tristate: false,
                          onChanged: (value) {
                            setState(() {
                              isUnderContract = false;
                              isNotUnderContract = value;
                            });
                          },
                          //side: BorderSide(color: CColor.white),
                          activeColor: CColor.transparent,
                          checkColor: CColor.primary,
                        ),
                      ),
                    ),
                    Text(
                      Languages.of(context)!.txtNo,
                      style: TextStyle(
                          color: CColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                )
              ],
            ),
          )
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
            if (validate()) {
              setData();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PersonalMusicPreference()));
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
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool validate() {
    /*parkhya Solutions*/
    if (nameController.text.isEmpty ||
        contactController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        addressController.text.isEmpty ||
        whoAreYouController.text.isEmpty ||
        searchingController.text.isEmpty) {
      /*parkhya Solutions*/
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please Enter All Details."),
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  void setData() async{
    personalDataModel!.name = nameController.text;
    personalDataModel!.contact = contactController.text;
    personalDataModel!.email = emailController.text;
    personalDataModel!.password = passwordController.text;
    personalDataModel!.address = addressController.text;
    personalDataModel!.iAm = whoAreYouController.text;
    personalDataModel!.lookingFor = searchingController.text;
    personalDataModel!.age = calculateDate();
    // personalDataModel!.musicGenre =
    //     Preference().getString(Preference.KEY_MUSIC_TYPE);
    // personalDataModel!.language = Preference().getString(Preference.LANGUAGE);
    personalDataModel!.id = Languages.of(context)!.txtDummyid;
    personalDataModel!.gender = Preference().getString(Preference.KEY_GENDER);
    personalDataModel!.contract = isUnderContract!
        ? Languages.of(context)!.txtIHaveContract
        : Languages.of(context)!.txtIDontHaveAContract;
    personalDataModel!.contractFlag = isUnderContract!;
    String? prefDetails = Preference().getString(Preference.USER_PERSONAL_DETAILS);
    if (prefDetails != null && prefDetails.isNotEmpty){
      PersonalDataModel personalDataModel1 = PersonalDataModel.fromJson(json.decode(prefDetails));
      personalDataModel!.musicGenre = personalDataModel1.musicGenre;
      personalDataModel!.language = personalDataModel1.language;
    }
    String detailStr = json.encode(personalDataModel);
    Preference().setString(Preference.USER_PERSONAL_DETAILS, detailStr);
  }

  int calculateDate() {
    String year = Preference().getString(Preference.KEY_YEAR).toString();
    DateTime currentDate = DateTime.now();
    int month1 = currentDate.month;
    int month2 =
        int.parse(Preference().getString(Preference.KEY_MONTH).toString());
    int age = currentDate.year - int.parse(year);
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 =
          int.parse(Preference().getString(Preference.KEY_DAY).toString());
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
