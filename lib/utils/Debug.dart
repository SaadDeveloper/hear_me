import 'dart:developer';

class Debug {
  static const DEBUG = true;
  static const STORE_RES_IN_PREF = true;
  static const SANDBOX_API_URL = false;
  static const SANDBOX_SOCKET_URL = false;
  static const SANDBOX_VERIFY_RECEIPT_URL = false;

  static printLog(String str) {
    if (DEBUG) log(str);
  }
}