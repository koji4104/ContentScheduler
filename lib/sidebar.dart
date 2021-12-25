import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'schedule_provider.dart';

class Sidebar extends ConsumerWidget {
  bool isTitle = false;
  int type = 2;
  Sidebar({Key? key, bool? isTitle}) : super(key: key){
    if(isTitle!=null) this.isTitle=isTitle;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    this.type = ref.watch(screenTypeProvider);
    final col = ref.watch(colorProvider);
    this.isTitle = ref.watch(sidebarTypeProvider) == 2 ? true : false;

    return Container(
      width: isTitle ? 170 : 42,
      child: Drawer(
      //backgroundColor: col.sidebarColor,
      child: ListView(
        children: [
          MyListTile(
            title: "Dashboard",
            icon: Icons.insert_chart_outlined,
            screenType: 1,
            ref: ref,
          ),
          MyListTile(
            title: "Schedules",
            icon: Icons.view_list_sharp ,
            screenType: 2,
            ref: ref,
          ),
          MyListTile(
            title: "Devices",
            icon: Icons.phone_android_outlined,
            screenType: 3,
            ref: ref,
          ),
          MyListTile(
            title: "Users",
            icon: Icons.account_circle_outlined,
            screenType: 4,
            ref: ref,
          ),
          MyListTile(
            title: "Notifications",
            icon: Icons.info_outline ,
            screenType: 5,
            ref: ref,
          ),
        ],
      ),
    ));
  }

  /// Tile
  Widget MyListTile({
    required String title, 
    required IconData icon, 
    required int screenType,
    required WidgetRef ref
  }){        
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      onTap: () { ref.read(screenTypeProvider.state).state = screenType; },
      leading: (type==screenType) ? Icon(icon, color: Colors.blue, size: 32) : Icon(icon, color: Colors.grey, size: 32),
      title: isTitle ? Text(title) : null,
    );
  }
}
