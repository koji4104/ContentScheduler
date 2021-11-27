import 'package:flutter/material.dart';
import 'dart:core';

/// Data on the timetable
class ScheduleData {
  int scheduleID = -1;
  int contentID = -1;
  DateTime d1 = DateTime(2021,12,1);
  DateTime d2 = DateTime(2021,12,1);

  ScheduleData({DateTime? d1, DateTime? d2, int? contentID}) {
    if(d1 != null) this.d1 = d1;
    if(d2 != null) this.d2 = d2;
    if(contentID != null) this.contentID = contentID;
    this.scheduleID = ++scheduleCounter;
  }
}
int scheduleCounter = 0;

/// Scheduled content
class ContentData {
  int contentID = -1;
  String name = "";
  Color col = Color(0);

  ContentData({String? name, Color? col, int? contentID}) {
    if(name != null) this.name = name;
    if(col != null) this.col = col;
    if(contentID != null) this.contentID = contentID;
  }
}

/// Items are common data on the UI.
/// Used for drag and drop data movement and drawing.
/// Including data that is not used because it is common.
class ItemData {
  int type = -1;
  int itemID = -1;
  String name = "";
  DateTime d1 = DateTime(2020,01,01);
  DateTime d2 = DateTime(2020,01,01);
  Color col = Color(0xFF004488);
  int scheduleID = -1;
  int contentID = -1;
  Offset tapPos = Offset(0,0);

  ItemData({DateTime? d1, DateTime? d2, String? name, int? contentID, int? scheduleID, int? type, Color? col}){
    if(contentID != null) this.contentID = contentID;
    if(scheduleID != null) this.scheduleID = scheduleID;
    if(d1 != null) this.d1 = d1;
    if(d2 != null) this.d2 = d2;
    if(name != null) this.name = name;
    if(type != null) this.type = type;
    if(col != null) this.col = col;
    this.itemID = ++itemCounter;
  }
}
int itemCounter = 0;

/// Environment
class EnvironmentData {
  /// Date to display and time to start
  DateTime dispDate = new DateTime(2021,12,1,0,0,0);

  /// Number of days to display
  int dispDays = 5;

  /// Number of hours to display
  int dispHours = 24;

  /// Number of seconds in 1 grid
  int gridSec = 30*60;

  double contentWidth = 150.0;
}