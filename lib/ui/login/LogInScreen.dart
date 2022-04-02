import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hear_me_final/interfaces/TopBarClickListener.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/ui/gender/GenderScreen.dart';
import 'package:hear_me_final/ui/home/HomeScreen.dart';
import 'package:hear_me_final/ui/uploadMusic/UploadMusicScreen.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/Constant.dart';
import 'package:hear_me_final/utils/Debug.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:hear_me_final/utils/Utils.dart';
import 'package:hear_me_final/validator/EmailValidator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'datamodel/LogInData.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen>
    implements TopBarClickListener {
  /*parkhya Solutions*/
  late FirebaseAuth firebaseAuth;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool passwordVisible = false;
  bool isAcceptedTermsAndConditions = false;
  var fullHeight;
  var fullWidth;
  late FirebaseDatabase mFirebaseDatabase;
  // var _emailControllerError = false;
  // var _passwordControllerError = false;
  // var validate = true;

  @override
  void initState() {
    super.initState();
    mFirebaseDatabase = FirebaseDatabase.instance;
    firebaseAuth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    fullHeight = MediaQuery.of(context).size.height;
    fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CColor.black,
      body: Container(
        height: fullHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/bg_water.png",
              ),
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft),
        ),
        child: SingleChildScrollView(
            child: Container(
          height: fullHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/hear_me_wave.png",
              ),
              fit: BoxFit.values[5],
              alignment: Alignment.topCenter,
            ),
          ),
          child: Container(
            margin: EdgeInsets.only(top: 120),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  child: Image.asset(
                    "assets/images/hear_me_logo.png",
                    fit: BoxFit.fitHeight,
                  ),
                ),
                _fieldsForLogIn(),
                // _logInButton(fullHeight),
                SizedBox(
                  height: 24,
                ),

                /*parkhya Solutions*/
                InkWell(
                  onTap: () {
                    if (_emailController.text.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Enter Email ID."),
                        ),
                      );
                    } else if (_passwordController.text.length == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Enter Passowrd."),
                        ),
                      );
                    } else {
                      FocusScope.of(context).unfocus();
                      logInToFb();

                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (context) => HomeScreen()),
                      //     (Route<dynamic> route) => false);
                    }
                    /*parkhya Solutions*/

                    // if (_emailController.text != '' ||
                    //     _passwordController.text != '') {
                    //   FocusScope.of(context).unfocus();
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       backgroundColor: Colors.green,
                    //       content: Text("Login Done"),
                    //     ),
                    //   );
                    //   Navigator.of(context).pushAndRemoveUntil(
                    //       MaterialPageRoute(builder: (context) => HomeScreen()),
                    //       (Route<dynamic> route) => false);
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       backgroundColor: Colors.red,
                    //       content: Text("Enter Your Email ID and password"),
                    //     ),
                    //   );
                    // }
                  },
                  child: Container(
                    height: 45,
                    width: 150,
                    // color: Colors.red,
                    decoration: BoxDecoration(
                      //  gradient: LinearGradient(colors: CColor.btn_gradient_full_opacity),
                      color: CColor.primary,
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                /*parkhya Solutions*/
                _createAccount(fullHeight),
              ],
            ),
          ),
        )),
      ),
    );
  }

  @override
  void onTopBarClick(String name, {bool value = true}) {
    if (name == Constant.STR_BACK) {
      Navigator.pop(context);
    }
  }

  _logInButton(double fullheight) {
    InkWell(
      onTap: () {
        if (_emailController.text == '' || _passwordController.text == '') {}
      },
      // FocusScope.of(context).unfocus();
      /*Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));*/
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => HomeScreen()),
      //     (Route<dynamic> route) => false);

      child: Container(
        width: 150,
        padding:
            EdgeInsets.symmetric(vertical: fullheight * 0.01, horizontal: 30),
        decoration: BoxDecoration(
          //  gradient: LinearGradient(colors: CColor.btn_gradient_full_opacity),
          color: CColor.primary,
          borderRadius: BorderRadius.circular(35.0),
        ),
        margin: const EdgeInsets.only(top: 30),
        child: Container(
          alignment: Alignment.center,
          child: Text(Languages.of(context)!.login.toUpperCase(),
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: CColor.white)),
        ),
      ),
    );
  }

  _createAccount(double fullheight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30, top: 60),
      // margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => GenderScreen()));
        },
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(Languages.of(context)!.youDontHaveAcc,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: CColor.white)),
            Text(Languages.of(context)!.joinNow,
                style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                    color: CColor.primary)),
          ],
        )),
      ),
    );
  }

  void launchURLTerms() async {
    var url = Constant.getConditionsURL();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _fieldsForLogIn() {
    return Container(
      margin: EdgeInsets.only(top: fullHeight * 0.01, left: 25, right: 25),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 7),
                    width: 100,
                    alignment: Alignment.centerRight,
                    child: Text(
                      Languages.of(context)!.email + ":",
                      style: TextStyle(color: CColor.primary),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      cursorColor: CColor.white,
                      onEditingComplete: () {
                        FocusScope.of(context).nextFocus();
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(color: Colors.white),
                      /*parkhya Solutions*/
                      validator: (value) {
                        if (value!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              margin: EdgeInsets.only(
                                left: 100,
                                right: 100,
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red,
                              content: Text(
                                "Enter E-Mail",
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                          log('>>>>>>>>>>>>>>>>>>>>>>>>>>>$value');
                        }
                        return null;
                      },

                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "Please Enter Email";
                      //   } else if (!EmailValidator.validate(value, false)) {
                      //     return "Please Enter Valid Email";
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: Languages.of(context)!.emailAddress,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              color: CColor.white,
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 7),
                    width: 100,
                    alignment: Alignment.centerRight,
                    child: Text(
                      Languages.of(context)!.password + ":",
                      style: TextStyle(color: CColor.primary),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _passwordController,
                      cursorColor: CColor.white,
                      style: TextStyle(color: CColor.white),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      ///////***********//////////Chanages by parkhya solutions */
                      validator: (value) {
                        if (value!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              margin: EdgeInsets.only(
                                left: 100,
                                right: 100,
                              ),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red,
                              content: Text(
                                "Enter E-Mail",
                                style: TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return null;
                      },

                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "Please Enter Password";
                      //   } else if (!EmailValidator.validate(value, true)) {
                      //     return "Please Enter Valid Password";
                      //   }
                      //   return null;
                      // },
                      decoration: InputDecoration(
                        hintText: Languages.of(context)!.password,
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              color: CColor.white,
            ),
          ],
        ),
      ),
    );
  }

  bool validateRegister(BuildContext context) {
    if (_emailController.text.isEmpty) {
      Utils.showToast(context, Languages.of(context)!.errEmail);
      return false;
    }

    if (_passwordController.text.isEmpty) {
      Utils.showToast(context, Languages.of(context)!.errPass);
      return false;
    }

/*    registerDataModel.email = _emailController.text;
    registerDataModel.password = _passwordController.text; */
    return true;
  }

  Future<void> _doLogIn(
    BuildContext context,
  ) async {
    /*  await logInDataModel!.loggedIn(context).then((value) {
      */ /*   setState(() {
        isShowProgress = false;
      });*/ /*
      handleLogInResponse(value, context);
    });*/
  }

  handleLogInResponse(LogInData logInData, BuildContext context) async {
    if (logInData != null) {
      if (logInData.success == true) {
        Debug.printLog(
            "LogIn Res Success ===> ${logInData.toJson().toString()}");
        if (logInData.data!.message != null &&
            logInData.data!.message!.isNotEmpty) {
          //Utils.showToast(context, logInData.data!.message!, duration: 3);

        } else {
          Debug.printLog(
              "LogIn Res Fail ===> ${logInData.toJson().toString()}");

          if (logInData.data != null && logInData.data!.message!.isNotEmpty)
            Utils.showToast(context, logInData.data!.message!);
          else
            Utils.showToast(
                context,
                Languages.of(context)!.errSomethingWentWrong +
                    ":" +
                    logInData.data.toString());
        }
      } else {
        Utils.showToast(context, Languages.of(context)!.errSomethingWentWrong);
      }
    }
  }
   /*parkhya Solutions*/
  void logInToFb() {
    firebaseAuth
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text)
        .then((result) async{
      await Preference().setLoginBoo(Preference.IS_LOGIN, true);
      await Preference().setString(Preference.KEY_SIGNIN_EMAIL, _emailController.text);
      await Preference().setString(Preference.KEY_SIGNIN_PASSWORD, _passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          // backgroundColor: Color(0xff050A30),
          content: Text("Login Done"),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(fromSignup: false,)),
      );
    }).catchError((err) {
      print(err.message);
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
    });
  }
}

class AlertPop extends StatelessWidget {
  final title;
  AlertPop(this.title);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Alert'),
      content: Text(title),
      actions: [
        new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("okay"))
      ],
    );
  }
}
