// To parse this JSON data, do
//
//     final logInData = logInDataFromJson(jsonString);

import 'dart:convert';

LogInData logInDataFromJson(String str) => LogInData.fromJson(json.decode(str));

String logInDataToJson(LogInData data) => json.encode(data.toJson());

class LogInData {
  LogInData({
    this.success,
    this.data,
  });

  bool? success;
  Data? data;

  factory LogInData.fromJson(Map<String, dynamic> json) => LogInData(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.userId,
    this.profileName,
    this.accessToken,
    this.email,
    this.personalInspiration,
    this.profileImage,
    this.message,
  });

  String? userId;
  String? profileName;
  String? accessToken;
  String? email;
  String? personalInspiration;
  String? profileImage;
  String? message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"] == null ? null : json["user_id"],
    profileName: json["profile_name"] == null ? null : json["profile_name"],
    accessToken: json["access_token"] == null ? null : json["access_token"],
    email: json["email"] == null ? null : json["email"],
    personalInspiration: json["personal_inspiration"] == null ? null : json["personal_inspiration"],
    profileImage: json["profileImage"] == null ? null : json["profileImage"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId == null ? null : userId,
    "profile_name": profileName == null ? null : profileName,
    "access_token": accessToken == null ? null : accessToken,
    "email": email == null ? null : email,
    "personal_inspiration": personalInspiration == null ? null : personalInspiration,
    "profileImage": profileImage == null ? null : profileImage,
    "message": message == null ? null : message,
  };
}
