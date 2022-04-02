import 'package:flutter/material.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/ui/enterDetails/datamodel/PersonalDataModel.dart';
import 'package:hear_me_final/ui/login/LogInScreen.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/Preference.dart';

import 'datamodel/DrawerData.dart';

class DrawerMenu extends StatefulWidget {
  // final PersonalDataModel? personalDataModel;
  // const DrawerMenu({Key? key, this.personalDataModel}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  List<DrawerData> drawerDataList = <DrawerData>[];
  //String? name;
  String? userName;
  String? profileImage;
  String? personalInspiration;

  @override
  void initState() {
    super.initState();

    // name = widget.personalDataModel!.name;
    // print("$name");
    // userName = widget.personalDataModel!.userName;
  }

  @override
  Widget build(BuildContext context) {
    _drawerData(context);
    return Container(
      decoration: new BoxDecoration(
          color: CColor.black,
          borderRadius:
              new BorderRadius.only(topRight: const Radius.circular(40.0))),
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.width / 9,
          right: MediaQuery.of(context).size.width / 8),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
      child: Column(
        children: [
          Container(
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(
                            minWidth: 0.0,
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          child: Text(
                            Languages.of(context)!.profile,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: CColor.white),
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(
                            minWidth: 0.0,
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          child: Text(
                            // name!,
                            "${Preference().getString(Preference.KEY_STAGE_NAME)}",
                            //    "Parkhya Solution",
                            textAlign: TextAlign.start,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: CColor.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: new ListView.builder(
                itemCount: drawerDataList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                itemBuilder: (BuildContext context, int index) {
                  return _itemDrawer(index);
                },
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await Preference().setLoginBoo(Preference.IS_LOGIN, false);
              await Preference().setString(Preference.KEY_SIGNIN_EMAIL, "");
              await Preference().setString(Preference.KEY_SIGNIN_PASSWORD, "");
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LogInScreen()),
                  (Route<dynamic> route) => false);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 30.0,
                  child: Image.asset(
                    "assets/icons/ic_back.png",
                    scale: 1,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      "Log Out",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: CColor.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _itemDrawer(int index) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, drawerDataList[index].navPath!);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Container(
              width: 100.0,
              child: Image.asset(
                drawerDataList[index].icon,
                scale: 1,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  drawerDataList[index].text,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 17,
                      color: CColor.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  _drawerData(BuildContext context) {
    drawerDataList.clear();
    drawerDataList.add(
      DrawerData("assets/images/hear_me_logo.png",
          Languages.of(context)!.search + " Screen",
          navPath: '/searchScreen'),
    );
    drawerDataList.add(
      DrawerData("assets/images/hear_me_logo.png",
          Languages.of(context)!.gender + " Screen",
          navPath: '/genderScreen'),
    );
  }
}
