import 'package:flutter/material.dart';
import 'package:hear_me_final/utils/Color.dart';

class CustomTab extends StatefulWidget {
  TabController tabController;
  List<Tab> tabs;

  CustomTab({required this.tabController, required this.tabs});

  @override
  _CustomTabState createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: TabBar(
          controller: widget.tabController,
          indicatorColor: CColor.txt_black,
          unselectedLabelColor: CColor.txt_gray,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: EdgeInsets.symmetric(horizontal: 3),
          indicatorPadding: EdgeInsets.symmetric(vertical: 0),
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          color: CColor.primary
          ),
          indicatorWeight: 0,
          isScrollable: true,
          tabs: widget.tabs),
    );
  }
}
