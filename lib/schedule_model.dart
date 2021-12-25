import 'package:flutter/material.dart';
import 'dart:core';
import 'package:uuid/uuid.dart';

/// Data on the timetable
class ScheduleData {
  String scheduleid = '';
  String contentid = '';
  DateTime d1 = DateTime(2021,12,1);
  DateTime d2 = DateTime(2021,12,1);

  ScheduleData({DateTime? d1, DateTime? d2, String? contentid}) {
    if(d1 != null) this.d1 = d1;
    if(d2 != null) this.d2 = d2;
    if(contentid != null) this.contentid = contentid;
    this.scheduleid = Uuid().v1();
  }
}

/// Scheduled content
class ContentData {
  String contentid = '';
  String name = "";
  Color col = Color(0);

  ContentData({String? name, Color? col, String? contentid}) {
    if(name != null) this.name = name;
    if(col != null) this.col = col;
    if(contentid != null) this.contentid = contentid;
  }
}

/// Items are common data on the UI.
/// Used for drag and drop data movement and drawing.
/// Including data that is not used because it is common.
class ItemData {
  int type = -1;
  String itemid = '';
  String name = "";
  DateTime d1 = DateTime(2020,01,01);
  DateTime d2 = DateTime(2020,01,01);
  Color col = Color(0xFF004488);
  String scheduleid = '';
  String contentid = '';
  Offset tapPos = Offset(0,0);

  ItemData({DateTime? d1, DateTime? d2, String? name, String? contentid, String? scheduleid, int? type, Color? col}){
    if(contentid != null) this.contentid = contentid;
    if(scheduleid != null) this.scheduleid = scheduleid;
    if(d1 != null) this.d1 = d1;
    if(d2 != null) this.d2 = d2;
    if(name != null) this.name = name;
    if(type != null) this.type = type;
    if(col != null) this.col = col;
    this.itemid = Uuid().v1();
  }
}

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

