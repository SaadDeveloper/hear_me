import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/ui/audioRecorder/audio_recorder.dart';
import 'package:hear_me_final/utils/CustomDialogs.dart';
import 'package:path/path.dart' as p;

import 'GUIDGen.dart';
import 'Utils.dart';

class FilePickerUtils {
  Future<List<SongDTO>> selectMediaFromGallery(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['MP3', 'm4a', 'wav']);

    List<SongDTO> songsList = [];
    if (result != null) {
      CustomDialogs.showProgressDialog(context, "Fetching Track Details....");

      for (var path in result.paths) {
        SongDTO songDTO = await getMetadata(path!);
        songsList.add(songDTO);
      }
    }
    return songsList;
  }

  Future<SongDTO> selectTrackCoversFromGallery(SongDTO songDTO) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      songDTO.song_image = files[0].path;
    }
    return songDTO;
  }

  Future<SongDTO> getMetadata(String filePath) async {
    File file = new File(filePath);
    var metadata = await MetadataRetriever.fromFile(file);
    SongDTO songDTO = SongDTO(
        song_id: GUIDGen.generate(),
        postedDate: Utils.getCurrentDateTime(),
        song_name: getName(p.basename(filePath)),
        song_title: getName(p.basename(filePath)),
        song_image: "",
        song_details: "",
        song_duration: printDuration(Duration(
            milliseconds:
                metadata.trackDuration == null ? 0 : metadata.trackDuration!)),
        is_favourite: "false",
        song_path: filePath,
        genre: "",
        language: "");
    return songDTO;
  }

  Future<SongDTO> getRecordedMetadata(Recording recordedData, int? durationMillis) async {
    File file = new File(recordedData.path!);
    var metadata = await MetadataRetriever.fromFile(file);
    // final retriever = new MediaMetadataRetriever();
    /* Setting a file path. */
    /* Reading its metadata. */
    SongDTO songDTO = SongDTO(
        song_id: GUIDGen.generate(),
        postedDate: Utils.getCurrentDateTime(),
        song_name: getName(p.basename(recordedData.path!)),
        song_title: getName(p.basename(recordedData.path!)),
        song_image: "",
        song_details: "",
        song_duration: printDuration(Duration(
            milliseconds:
            durationMillis == null ? 0 : durationMillis)),
        is_favourite: "false",
        song_path: recordedData.path!,
        genre: "",
        language: "");
    return songDTO;
  }

  static String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  static String getName(String fullName) {
    final parts = fullName.split('.');
    parts.removeAt(parts.length - 1);
    return parts.join();
  }
}
