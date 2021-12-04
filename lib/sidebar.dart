import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'scheduler_provider.dart';

class Sidebar extends ConsumerWidget {
  bool isTitle = false;
  Sidebar({Key? key, bool? isTitle}) : super(key: key){
    if(isTitle!=null) this.isTitle=isTitle;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int type = ref.watch(screenTypeProvider);
    return Drawer(
      //backgroundColor: Color(0xFF444444),
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
            title: "Info",
            icon: Icons.info_outline ,
            screenType: 5,
            ref: ref,
          ),
        ],
      ),
    );
  }

  /// 
  Widget MyListTile({
    required String title, 
    required IconData icon, 
    required int screenType,
    required WidgetRef ref
  }){        
    bool sel = ref.watch(screenTypeProvider)==screenType;
    Color col = sel ? Colors.white : Colors.grey;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      onTap: () { ref.read(screenTypeProvider.state).state = screenType; },
      leading: Icon(icon, color: col, size: 32),
      title: isTitle ? Text(title, style: TextStyle(color: Colors.white)) : null,
    );
  }
}
