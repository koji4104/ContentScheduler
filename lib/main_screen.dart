import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'schedule_provider.dart';
import 'schedule_screen.dart';
import 'sidebar.dart';
import 'dashboard/dashboard_screen.dart';
import 'dashboard/responsive.dart';

class MainScreen extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int type = ref.watch(screenTypeProvider);
    final col = ref.watch(colorProvider);
    return Scaffold(
      key: _key,
      drawer: Sidebar(isTitle:true),
      body: SafeArea(child:
        Column(children: [
          topmenuBar(context, ref),
          // Screen
          Expanded(child:
            Row(children: [
              if (Responsive.isMobile(context)==false)
                Sidebar(),
              Expanded(child: changeScreen(type)),
          ]),
        ),
      ]),
    ));
  }

  Widget changeScreen(int type){
    if(type==1) return DashboardScreen();
    else if(type==2) return ScheduleScreen();
    else if(type==3) return Container();
    else if(type==4) return Container();
    else if(type==5) return Container();
    else return ScheduleScreen();
  }

  Widget topmenuBar(BuildContext context, WidgetRef ref){
    final col = ref.watch(colorProvider);
    return Container(color: col.menuBgColor, child:
    Row(children: [
      Container(width:42, child:
        ListTile(contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          leading: Icon(Icons.menu, size: 32, color: col.menuFgColor),
          onTap:(){
            if (Responsive.isMobile(context)==true){
              _key.currentState!.openDrawer(); 
            } else {
              final sidebar = ref.watch(sidebarTypeProvider);
              ref.read(sidebarTypeProvider.state).state = sidebar==1 ? 2 : 1;
            }
          },
      )),
      Expanded(child: SizedBox(width: 20)),
      Container(width:42, height:42, child:
      ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        leading: Icon(Icons.dark_mode_outlined , size: 32, color: col.menuFgColor),
        onTap: (){
          bool isDark = ref.watch(isDarkProvider);
          ref.read(isDarkProvider.state).state = !isDark;
        },
      )),
    ]));
  }
}
