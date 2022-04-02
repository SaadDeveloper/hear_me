
import 'dart:math';

import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/utils/GUIDGen.dart';
import 'package:hear_me_final/utils/Utils.dart';

class SampleSongDataPopulate{

  List<SongDTO> songsList = [];

  SampleSongDataPopulate(){
    populateSongs();
  }

  populateSongs(){
    SongDTO songDTO = SongDTO(song_name: "Lost In Sky", song_title: "Lost In Sky", song_image: "assets/images/scenery0.png", song_details: "APL", song_duration: "03:50", is_favourite: "false");
    // SongDTO songDTO1 = SongDTO(song_name: "In The End", song_title: "In The End", song_image: "assets/images/scenery1.png", song_details: "Linkin Park", song_duration: "02:50", is_favourite: "false");
    SongDTO songDTO2 = SongDTO(song_name: "Hymn For The Weekend", song_title: "Hymn For The Weekend", song_image: "assets/images/scenery2.png", song_details: "Coldplay", song_duration: "04:00", is_favourite: "false");
    SongDTO songDTO3 = SongDTO(song_name: "Faded", song_title: "Faded", song_image: "assets/images/scenery3.png", song_details: "AlanWalker", song_duration: "03:33", is_favourite: "false");
    SongDTO songDTO4 = SongDTO(song_name: "Bad Liar", song_title: "Bad Liar", song_image: "assets/images/scenery4.png", song_details: "Imagine Dragon", song_duration: "04:44", is_favourite: "false");
    SongDTO songDTO5 = SongDTO(song_name: "Unstoppable", song_title: "Unstoppable", song_image: "assets/images/scenery5.png", song_details: "Sia", song_duration: "04:07", is_favourite: "false");
    SongDTO songDTO6 = SongDTO(song_name: "Broken Angel", song_title: "Broken Angel", song_image: "assets/images/scenery6.png", song_details: "Arash", song_duration: "03:23", is_favourite: "false");
    SongDTO songDTO7 = SongDTO(song_name: "Serhat Durmus", song_title: "Serhat Durmus", song_image: "assets/images/scenery7.png", song_details: "Hislerim", song_duration: "03:32", is_favourite: "false");

    songsList.add(songDTO);
    // songsList.add(songDTO1);
    songsList.add(songDTO2);
    songsList.add(songDTO3);
    songsList.add(songDTO4);
    songsList.add(songDTO5);
    songsList.add(songDTO6);
    songsList.add(songDTO7);
  }

  SongDTO getRandomSong(){
    final _random = new Random();
    SongDTO songDTO = songsList[_random.nextInt(songsList.length)];
    songDTO.song_id = GUIDGen.generate();
    songDTO.postedDate = Utils.getCurrentDateTime();
    return songDTO;
  }
}