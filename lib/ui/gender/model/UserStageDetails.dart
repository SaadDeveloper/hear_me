class UserStageDetails {
  String? id;
  String? userStageName;
  String? gender;
  String? userVoiceSound;
  String? dateOfBirth;

  UserStageDetails(
      {this.id, this.userStageName, this.gender, this.userVoiceSound, this.dateOfBirth});

  factory UserStageDetails.fromJson(Map<String, dynamic> parsedJson) {
    return new UserStageDetails(
      id: parsedJson['id'] ?? "",
      userStageName: parsedJson['stage_name'] ?? "",
      gender: parsedJson['gender'] ?? "",
      userVoiceSound: parsedJson['user_voice_sound'] ?? "",
      dateOfBirth: parsedJson['date_of_birth'] ?? "",);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "stage_name": this.userStageName,
      "gender": this.gender,
      "user_voice_sound": this.userVoiceSound,
      "date_of_birth": this.dateOfBirth
    };
  }
}
