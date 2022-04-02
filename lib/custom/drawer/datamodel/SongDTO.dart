class SongDTO {
  String? song_details = "";
  String? song_id = "";
  String? song_image = "";
  String? song_name = "";
  String? song_title = "";
  String? is_favourite = "";
  String? song_duration = "";
  String? postedDate = "";
  String? genre = "";
  String? language = "";
  String? song_path = "";

  SongDTO(
      {this.song_details,
      this.song_id,
      this.song_image,
      this.song_name,
      this.song_title,
      this.is_favourite,
      this.song_duration,
      this.postedDate,
      this.genre,
      this.language,
        this.song_path});

  SongDTO.fromJson(Map<String, dynamic> json)
      : song_details = json['song_details'],
        song_id = json['song_id'],
        song_image = json['song_images_thumb'],
        song_name = json['song_name'],
        song_title = json['song_title'],
        is_favourite = json['song_favourite'],
        song_duration = json['song_duration'],
        postedDate = json['song_posted_date'],
        genre = json['song_genre'],
        song_path = json['song_path'],
        language = json['song_language'];

  Map<String, dynamic> toJson() => {
    "song_details": song_details,
    "song_id": song_id,
    "song_images_thumb": song_image,
    "song_name": song_name,
    "song_title": song_title,
    "song_favourite": genre,
    "song_duration": song_duration,
    "song_posted_date": postedDate,
    "song_genre": genre,
    "song_path": song_path,
    "song_language": language,
  };

}
