/*
Content:  Scheduled content.
Schedule: Content with date and time.
Grid:     One cell on the timetable.
Item:     Data on the timetable.
*/
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:core';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dragscheduler/scheduler_model.dart';
import 'package:dragscheduler/scheduler_provider.dart';

DateTime dispDate = new DateTime(2021,12,1,0,0,0);

double TIME_HEADER_HEIGHT = 20.0;
double TIME_SCALE_WIDTH = 50.0;
double MENU_HEIGHT = 40.0;
double MENU_WIDTH = 40.0;
double MARGIN_BOTTOM = 20.0;
double MARGIN_ITEM = 10.0;
int DISP_DAYS = 5;
int DISP_HOURS = 24;
int GRID_SEC = 30*60;
double CONTENT_WIDTH = 150.0;
TextStyle TIME_TEXTSTYLE = TextStyle(color: Colors.white, fontSize: 12.0);
TextStyle SCALE_TEXTSTYLE = TextStyle(color: Color(0xFF909090), fontSize: 12.0);
TextStyle SCALE_HOUR_TEXTSTYLE = TextStyle(color: Color(0xFFF0F0F0), fontSize: 12.0);

double ICON_SIZE = 32.0;
double ICON_RADIUS = 32.0-8.0;
Color COL_ICON_BG = Color(0xFF0080F0);

Color COL_MENU_BG = Color(0xFF404040);
Color COL_TIME_BG = Color(0xFF202020);
Color COL_GRID_BG = Color(0xFF808080);
Color COL_GRID_BG_NIGHT = Color(0xFF707070);
Color COL_GRID_BG_SEL = Color(0xFF7070A0);
Color COL_GRID_BORDER = Color(0xFF404040);
Color COL_GRID_BORDER_SEL = Color(0xFFC0C0C0);

class SchedulerScreen extends ConsumerWidget {
  Size screenSize = Size(1000.0, 1000.0);
  Size gridSize = Size(100.0, 30.0);
  bool isInit = false;
  final ScrollController _scrollController = ScrollController();
  EnvironmentData env = EnvironmentData();

  resize(BuildContext context, WidgetRef ref) {
    final env = ref.watch(environmentProvider).data;
    Size size = MediaQuery.of(context).size;
    screenSize = size;
    double w = (screenSize.width - MENU_WIDTH - TIME_SCALE_WIDTH - CONTENT_WIDTH) / DISP_DAYS;
    double h = (screenSize.height - MENU_HEIGHT - TIME_HEADER_HEIGHT) / 20;
    gridSize = Size(w, h);
    print("-- screenSize=${screenSize.width.toInt()}x${screenSize.height.toInt()} dispHours=${env.dispHours} "
        "gridSize=${gridSize.height.toInt()}");

    ref.read(screenSizeProvider.state).state = screenSize;
    ref.read(gridSizeProvider.state).state = gridSize;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(screenSizeProvider);
    final cItemlist = ref.watch(contentItemListProvider);
    final sItemlist = ref.watch(scheduleItemListProvider);

    Future.delayed(Duration.zero, () => resize(context, ref));
    this.env = ref.watch(environmentProvider).data;

    return Scaffold(
      backgroundColor: COL_MENU_BG,
      body: Stack(children: <Widget>[
        // button
        Positioned(
          top: 4, left: MENU_WIDTH,
          child: myButton(
            text: '30',
            backgroundColor: COL_ICON_BG,
            onPressed: () => _onScale24(env, ref),
          ),
        ),
        Positioned(
          top: 4, left: MENU_WIDTH + 60,
          child: myButton(
            text: '5',
            backgroundColor: COL_ICON_BG,
            onPressed: () => _onScale6(env, ref),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: MENU_WIDTH, top: MENU_HEIGHT),
          decoration: BoxDecoration(color: COL_TIME_BG),
          width: screenSize.width-MENU_WIDTH-CONTENT_WIDTH,
          child: Stack(children: <Widget>[
            timeHeader(),
            Container(
              margin: EdgeInsets.only(left: 0, top: TIME_HEADER_HEIGHT),
              child: Stack(children: <Widget>[
                timeTable(sItemlist),
            ])),
        ])),

        Container(
          margin: EdgeInsets.only(left: screenSize.width-CONTENT_WIDTH, top: MENU_HEIGHT),
          child:Stack(children: <Widget>[
            contentTable(cItemlist),
          ])),
        ])
    );
  }

  /// Date at the top of the timetable
  Widget timeHeader() {
    return Stack(children: List<Widget>.generate(DISP_DAYS, (index) {
      DateTime d1 = dispDate.add(Duration(days: index));
      String s = d1.month.toString() + "/" +d1.day.toString();
      return Positioned(
        left: TIME_SCALE_WIDTH + gridSize.width * index,
        width: gridSize.width,
        top: 2,
        height: TIME_HEADER_HEIGHT,
        child: Text(s, style: TIME_TEXTSTYLE, textAlign: TextAlign.center));
    }));
  }

  /// timeTable
  Widget timeTable(List<ItemData> items) {
    int nGrid = (env.dispHours*3600/env.gridSec).toInt(); // Number of grids per day
    print("-- env.gridSec ${env.gridSec} gridSize.height ${gridSize.height.toInt()}");
    return SizedBox(
      width:gridSize.width*DISP_DAYS + TIME_SCALE_WIDTH,
      child: Scrollbar(
        controller: _scrollController,
        showTrackOnHover: true,
        isAlwaysShown: true,
        thickness: 8,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: gridSize.height * (nGrid+1),
            child: Stack(children: <Widget>[
              // Scale on the left. e.g. 01:00 12:15.
              Stack(children: List<Widget>.generate(nGrid, (index) {
                int totalsec = (index*env.gridSec).toInt();
                int min = ((totalsec%3600)/60).toInt();
                int hour = (totalsec/3600).toInt();
                String s = hour.toString() +":"+ min.toString().padLeft(2,'0');

                return (index%2==1) ? Container() : Positioned(
                  left: 0,
                  width: TIME_SCALE_WIDTH-5,
                  top: gridSize.height * index + 2,
                  height: gridSize.height,
                  child: min==0 ?
                  Text(s, style: SCALE_HOUR_TEXTSTYLE, textAlign: TextAlign.right)
                  : Text(s, style: SCALE_TEXTSTYLE, textAlign: TextAlign.right));
              })),

              // Grid. Each cell every hour.
              Stack(children: List.generate(DISP_DAYS, (day) {
                return Stack(children: List.generate(nGrid, (index) {
                  int sec = (index*env.gridSec).toInt();
                  DateTime d1 = dispDate;
                  d1 = d1.add(Duration(days: day, seconds: sec));
                  DateTime d2 = d1.add(Duration(seconds: env.gridSec));
                  ItemData data = ItemData(d1:d1, d2:d2);
                  return GridWidget(data);
                }));})
              ),

              // Item. Schedule data on the grid.
              items.length==0 ? Container() : Stack(
                children: List.generate(items.length, (index) {
                 return ItemWidget(items[index]);
                }))
            ])))));
  }

  Widget contentTable(List<ItemData> items) {
    return items.length==0 ? Container() : Stack(
      children: List.generate(items.length, (index) {
        return ContentWidget(items[index], index);
      }));
  }

  /// myButton
  Widget myButton({IconData? icon, String? text, Color? backgroundColor, Function()? onPressed}) {
    return icon != null ? CircleAvatar(
        backgroundColor: backgroundColor,
        radius: ICON_RADIUS,
        child: IconButton(
          icon: Icon(icon),
          iconSize: ICON_SIZE,
          color: Colors.white,
          onPressed: onPressed,
        )) : TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3)),
          )),
          child: Text(text!, style: TextStyle(color: Colors.white, fontSize: 12.0), textAlign: TextAlign.center),
        );
  }

  _onScale24(EnvironmentData env, WidgetRef ref) {
    env.dispHours = 24;
    env.gridSec = 30*60;
    ref.read(environmentProvider).update(env);
  }

  _onScale6(EnvironmentData env, WidgetRef ref) {
    env.dispHours = 24;
    env.gridSec = 5*60;
    ref.read(environmentProvider).update(env);
  }
}

/// Timetable grid
class GridWidget extends ConsumerWidget {
  bool isWillAccept = false;
  bool isSelected = false;
  double left = 0;
  double top = 0;
  double width = 0;
  double height = 0;
  ItemData data = ItemData();

  GridWidget(ItemData data1) {
    this.data = data1;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = ref.watch(screenSizeProvider);
    final gridSize = ref.watch(gridSizeProvider);
    final env = ref.watch(environmentProvider).data;
    resize(screenSize, gridSize, env);
    final scheduleList = ref.read(scheduleListProvider);

    return Positioned(
      left: left, top: top, width: width, height: height,
      child: GestureDetector(
        onTap:(){
          final selectList = ref.watch(selectListProvider);
          selectList.clear();
        },
        child: Stack(children: <Widget>[
          DragTarget(
            builder: (context, candidateData, rejectedData) {
              return buildWedget();
            },
            // When dropped
            onAccept: (ItemData? dropData) {
              if(dropData != null) {
                if(dropData.type == 1) {
                  Duration dur = dropData.d2.difference(dropData.d1);

                  int plussec = (dropData.tapPos.dy / gridSize.height).toInt() * env.gridSec;
                  DateTime d1 = data.d1.add(Duration(seconds:(-1)*plussec));
                  scheduleList.update(dropData.scheduleID, d1, d1.add(dur));

                } else if(dropData.type == 2) {
                  Duration dur = Duration(seconds: env.gridSec * 4);
                  scheduleList.add(data.d1, data.d1.add(dur), dropData.contentID);
                };
              }
              isWillAccept = false;
            },
            // When overlapping
            onWillAccept: (data) {
              isWillAccept = true;
              return true;
            },
            // When leaving the overlap
            onLeave: (data) {
              isWillAccept = false;
            },
          ),
        ])));
  }

  void resize(Size screenSize, Size gridSize, EnvironmentData env){
    double w = gridSize.width;
    double h = gridSize.height;
    left = w * data.d1.difference(dispDate).inDays + TIME_SCALE_WIDTH;
    top = h * (data.d1.hour*3600 + data.d1.minute*60 + data.d1.second) / env.gridSec;
    width = w;
    Duration dur = data.d2.difference(data.d1);
    height = h * (dur.inSeconds) / env.gridSec;
  }

  Widget buildWedget() {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
        color: getColor(),
        border: isSelected ? Border.all(color: COL_GRID_BORDER_SEL, width: 1.0) :
          Border.all(color: COL_GRID_BORDER, width: 0.2),
      ),
    );
  }

  Color getColor() {
    Color c = COL_GRID_BG;
    if(isWillAccept)
      c = COL_GRID_BG_SEL;
    else if (data.d1.hour < 6 || data.d1.hour >= 18)
      c = COL_GRID_BG_NIGHT;
    return c;
  }
}

/// Items on the timetable
class ItemWidget extends GridWidget {
  ItemWidget(ItemData data) : super(data) {
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = ref.watch(screenSizeProvider);
    final gridSize = ref.watch(gridSizeProvider);
    final env = ref.watch(environmentProvider).data;
    resize(screenSize, gridSize, env);

    final selectList = ref.watch(selectListProvider);
    isSelected = selectList.list.contains(data.scheduleID);

    return Positioned(
      left: left, top: top, width: width, height: height,
      child: GestureDetector(
        onTap:(){
          selectList.add(data.scheduleID);
        },
        onPanDown: (detail) {
          data.tapPos = detail.localPosition;
        },
        child: Draggable(
          data: data,
          onDragStarted: () {},
          onDraggableCanceled: (velocity, offset) {},
          onDragCompleted: () {},
          onDragEnd: (details) {},
          child: childWedget(0), // normal
          feedback: childWedget(1), // dragging
          childWhenDragging: childWedget(2), // original position
        ),
      ));
  }

  @override
  void resize(Size screenSize, Size gridSize, EnvironmentData env){
    super.resize(screenSize, gridSize, env);
    width = width - MARGIN_ITEM;
  }

  // m=0 normal, m=1 dragging, m=2 original position
  @override
  Widget childWedget(int m) {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(
        border: getBorder(m),
        color: (m==1) ? data.col.withAlpha(0x88) : data.col,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Stack(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(data.name, style: TextStyle(color: Colors.white, fontSize: 14.0))
        )
      ])
    );
  }

  BoxBorder getBorder(int m){
    Border b = Border.all(color: Color(0), width: 2.0);
    if(isSelected)
      b = Border.all(color: Color(0xFFFFFFFF), width: 2.0);
    else if(m==1)
      b = Border.all(color: Color(0x88FFFFFF), width: 2.0);
    return b;
  }
}

/// Items on the content list
class ContentWidget extends ItemWidget {
  int listIndex = 0;

  ContentWidget(ItemData data, int index) : super(data) {
    this.listIndex = index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = ref.watch(screenSizeProvider);
    final gridSize = ref.watch(gridSizeProvider);
    final env = ref.watch(environmentProvider).data;
    resize(screenSize, gridSize, env);

    final selectList = ref.watch(selectContentProvider);
    isSelected = selectList.list.contains(data.contentID);

    return Positioned(
      left: left, top: top, width: width, height: height,
      child: GestureDetector(
        onTap:(){
          selectList.add(data.contentID);
        },
        child: Draggable(
          data: data,
          onDragStarted: () {},
          onDraggableCanceled: (velocity, offset) {},
          onDragCompleted: () {},
          onDragEnd: (details) {},
          child: childWedget(0), // normal
          feedback: childWedget(1), // dragging
          childWhenDragging: childWedget(2), // original position
        ),
      ));
  }

  @override
  void resize(Size screenSize, Size gridSize, EnvironmentData env){
    double w = gridSize.width;
    double h = gridSize.height*2;
    left = 10;
    top = listIndex * (h+1);
    width = CONTENT_WIDTH-20;
    height = h;
  }
}