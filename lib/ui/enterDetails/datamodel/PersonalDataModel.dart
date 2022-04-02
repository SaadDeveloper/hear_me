import 'dart:convert';

PersonalDataModel personalDataModelFromJson(String str) => PersonalDataModel.fromJson(json.decode(str));

String personalDataModelToJson(PersonalDataModel data) => json.encode(data.toJson());

class PersonalDataModel {
  PersonalDataModel({
    this.name,
    this.contact,
    this.address,
    this.email,
    this.password,
    this.musicGenre,
    this.age,
    this.language,
    this.id,
    this.gender,
    this.iAm,
    this.lookingFor,
    this.contract,
    this.contractFlag
  });

  String? name;
  String? contact;
  String? address;
  String? email;
  String? password;
  String? musicGenre;
  int? age;
  String? language;
  String? id;
  String? gender;
  String? iAm;
  String? lookingFor;
  String? contract;
  bool? contractFlag;

  factory PersonalDataModel.fromJson(Map<String, dynamic> json) => PersonalDataModel(
    name: json["name"],
    contact: json["contact"],
    address: json["address"],
    email: json["email"],
    password: json["password"],
    musicGenre: json["musicGenre"],
    age: json["age"],
    language: json["language"],
    id: json["id"],
    gender: json["gender"],
    iAm: json["iAm"],
    lookingFor: json["lookingFor"],
    contract: json["contract"],
    contractFlag: json["contract_flag"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "contact": contact,
    "address": address,
    "email": email,
    "password": password,
    "musicGenre": musicGenre,
    "age": age,
    "language": language,
    "id": id,
    "gender": gender,
    "iAm": iAm,
    "lookingFor": lookingFor,
    "contract": contract,
    "contract_flag": contractFlag,
  };
}
