

import 'package:hear_me_final/utils/Debug.dart';

class Constant {
  static const RESPONSE_FAILURE_CODE = 400;
  static const RESPONSE_SUCCESS_CODE = 200;

  static const MAIN_URL = "https://pandalanhukuk.com";

  static const DATA_NOT_FOUND = "Data not found";

  static const LOGIN_TYPE_NORMAL = "Normal";
  static const LOGIN_TYPE_GOOGLE = "Google";
  static const LOGIN_TYPE_FACEBOOK = "Facebook";
  static const LOGIN_TYPE_LINKEDIN = "Linkedin";
  static const LOGIN_TYPE_APPLE = "Apple";

  static const STR_MENU = "Menu";
  static const STR_BACK = "Back";
  static const STR_INFO = "Info";
  static const STR_EDITION = "Edition";

  static const BROADCAST_CHANNEL = "BROADCAST_RECEIVER_DEMO";

  static getMainURL() {
    if (Debug.SANDBOX_API_URL)
      return "";
    else
      return MAIN_URL;
  }

  static String getTermsURL() {
    return getMainURL() + "";
  }
  static String getConditionsURL() {
    return getMainURL() + "";
  }
}
