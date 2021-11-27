import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dragscheduler/scheduler_model.dart';

/// sample data
String sampleContent = '''[
{"contentid":"1", "name":"A", "col":"0xFF4444CC"},
{"contentid":"2", "name":"B", "col":"0xFF44AA44"},
{"contentid":"3", "name":"C", "col":"0xFFCC4444"},
{"contentid":"4", "name":"D", "col":"0xFF2288CC"},
{"contentid":"5", "name":"E", "col":"0xFF8822CC"},
{"contentid":"6", "name":"F", "col":"0xFFCC8822"}
]''';

/// sample data
String sampleSchedule = '''[
{"contentid":"1", "d1":"2021-12-01 03:00:00", "d2":"2021-12-01 05:00:00"},
{"contentid":"2", "d1":"2021-12-02 03:00:00", "d2":"2021-12-02 05:00:00"}
]''';

final contentListProvider = ChangeNotifierProvider((ref) => contentListNotifier(ref));
class contentListNotifier extends ChangeNotifier {
  List<ContentData> list = [];
  contentListNotifier(ref){
    var json = jsonDecode(sampleContent);
    for(var con in json){
      list.add(ContentData(
        contentID:int.parse(con['contentid']),
        name:con['name'],
        col:Color(int.parse(con['col']))
      ));
    }
  }
}

final scheduleListProvider = ChangeNotifierProvider((ref) => scheduleListNotifier(ref));
class scheduleListNotifier extends ChangeNotifier {
  List<ScheduleData> list = [];

  scheduleListNotifier(ref){
    var json = jsonDecode(sampleSchedule);
    for(var skd in json){
      list.add(ScheduleData(
        contentID:int.parse(skd['contentid']),
        d1:DateTime.parse(skd['d1']),
        d2:DateTime.parse(skd['d2'])
      ));
    }
  }

  add(DateTime d1, DateTime d2, int contentID){
    ScheduleData skd1 = ScheduleData(contentID: contentID, d1:d1, d2:d2);
    list.add(skd1);
    this.notifyListeners();
  }

  update(int scheduleID, DateTime d1, DateTime d2){
    for(ScheduleData skd in list) {
      if(skd.scheduleID == scheduleID) {
        skd.d1 = d1;
        skd.d2 = d2;
      }
    }
    this.notifyListeners();
  }
}

final scheduleItemListProvider = StateProvider<List<ItemData>>((ref) {
  final slist = ref.watch(scheduleListProvider).list;
  final clist = ref.watch(contentListProvider).list;

  List<ItemData> sItemlist = [];
  for(ScheduleData skd in slist){
    ContentData con = clist.firstWhere((el) => el.contentID==skd.contentID, orElse: () => ContentData());
    if(con.contentID<0) continue;
    ItemData d = ItemData(
      type:1,
      contentID:skd.contentID,
      scheduleID:skd.scheduleID,
      d1:skd.d1,
      d2:skd.d2,
      name:con.name,
      col:con.col,
    );
    sItemlist.add(d);
  }
  return sItemlist;
});

final contentItemListProvider = StateProvider<List<ItemData>>((ref) {
  final clist = ref.watch(contentListProvider).list;

  List<ItemData> cItemlist = [];
  for(ContentData con in clist){
    ItemData d = ItemData(
      type:2,
      contentID:con.contentID,
      name:con.name,
      col:con.col,
    );
    cItemlist.add(d);
  }
  return cItemlist;
});

final gridSizeProvider = StateProvider<Size>((ref) {
  return Size(100,30);
});

final screenSizeProvider = StateProvider<Size>((ref) {
  return Size(1000,1000);
});

final selectContentProvider = ChangeNotifierProvider((ref) => selectListNotifier(ref));
final selectListProvider = ChangeNotifierProvider((ref) => selectListNotifier(ref));
class selectListNotifier extends ChangeNotifier {
  List<int> list = [];
  selectListNotifier(ref) {}
  add(int id) {
    if(id>0 && this.list.contains(id)==false) {
      list.add(id);
      this.notifyListeners();
    }
  }
  clear() {
    if(list.length>0) {
      list = [];
      this.notifyListeners();
    }
  }
}

final environmentProvider = ChangeNotifierProvider((ref) => environmentNotifier(ref));
class environmentNotifier extends ChangeNotifier {
  EnvironmentData data = EnvironmentData();
  environmentNotifier(ref) {}
  update(EnvironmentData d){
    data = d;
    this.notifyListeners();
  }
}