import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hear_me_final/custom/drawer/datamodel/SongDTO.dart';
import 'package:hear_me_final/localization/language/languages.dart';
import 'package:hear_me_final/utils/Color.dart';

class SongListViewScreen extends StatefulWidget {
  final List<SongDTO>? songsList;
  final bool fromSignUp;
  const SongListViewScreen({Key? key, this.songsList, required this.fromSignUp}) : super(key: key);

  @override
  _SongListViewScreenState createState() => _SongListViewScreenState();
}

class _SongListViewScreenState extends State<SongListViewScreen> {

  bool gridVisible = true;

  @override
  Widget build(BuildContext context) {
    return (gridVisible)? buildGridViewDesign(): buildListViewViewDesign();
  }

  Widget buildGridViewDesign(){
    return Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: (){},
                iconSize: 30,
                icon: Image.asset(
                    "assets/icons/ic_add_music.png"
                )),
            Spacer(),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        gridVisible = !gridVisible;
                      });
                    },
                    iconSize: 30,
                    icon: Image.asset("assets/icons/ic_list_view.png")),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {},
                    iconSize: 30,
                    icon: Image.asset("assets/icons/ic_filter_funnel.png"))
              ],
            )
          ],
        ),
        SizedBox(height: 10),
        buildSongGridView()
      ],
    );
  }

  Widget buildListViewViewDesign(){
    return Column(
      children: [
        Row(
          children: [
            buildButton(Languages.of(context)!.txtAdd, () {

            }),
            Spacer(),
            Row(
              children: [
                buildButton(Languages.of(context)!.txtGrid, () {
                  setState(() {
                    gridVisible = !gridVisible;
                  });
                }),
                SizedBox(
                  width: 10,
                ),
                buildButton(Languages.of(context)!.txtFilter, () {

                })
              ],
            )
          ],
        ),
        SizedBox(height: 10),
        buildSongListView()
      ],
    );
  }

  Widget buildSongGridView(){
    return Container(
      child: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 3,
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(4.0),
        // Generate 100 widgets that display their index in the List.
        children: List.generate(widget.songsList!.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                  image: checkSongTrackThumb(index), borderRadius: BorderRadius.circular(10)),
            ),
          );
        }),
      ),
    );
  }

  DecorationImage checkSongTrackThumb(int index){
    if(widget.fromSignUp){
      if(widget.songsList![index].song_image!.isEmpty){
        return DecorationImage(
          image: AssetImage(
            "assets/images/placeholder.jpg",
          ),
          fit: BoxFit.cover,
        );
      }else {
        return DecorationImage(
          image:
          Image
              .file(File(widget.songsList![index].song_image!))
              .image,
          fit: BoxFit.cover,
        );
      }
    }else{
      return DecorationImage(
        image: NetworkImage(
          widget.songsList![index].song_image!,
        ),
        fit: BoxFit.cover,
      );
    }
  }

  Widget buildSongListView(){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.songsList!.length,
      physics: new NeverScrollableScrollPhysics(),
      itemBuilder: (context, position) {
        return Padding(
          padding: EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    widget.songsList![position].song_title!,
                    style: TextStyle(color: CColor.white, fontSize: 19),
                  ),
                  Spacer(),
                  IconButton(onPressed: (){},
                      iconSize: 40,
                      icon: Image.asset(
                          "assets/icons/ic_overflow.png",
                        color: CColor.white,
                      ))
                ],
              ),
              Divider(
                color: CColor.txt_gray,
                thickness: 1,
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildButton(String buttonTxt, GestureTapCallback onPress){
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: CColor.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: CColor.transparent,
        child: InkWell(
            onTap: onPress,
            child: Center(
              child: Text(
                buttonTxt.toUpperCase(),
                style: TextStyle(
                    color: CColor.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
            )),
      ),
    );
  }
}
