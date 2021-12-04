import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'scheduler_provider.dart';
import 'scheduler_screen.dart';
import 'sidebar.dart';
import 'dashboard/dashboard_screen.dart';
import 'dashboard/responsive.dart';

class MainScreen extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int type = ref.watch(screenTypeProvider);
    return Scaffold(
      backgroundColor: Color(0xFF444444),
      key: _key,
      drawer: Container(width:170, child: Sidebar(isTitle:true)),
      body: SafeArea(child:
        Column(children: [
          Row(children: [
            Container(width:42, height:42, child:
              ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              leading: Icon(Icons.menu, color: Colors.white, size: 32),
              onTap: () => _key.currentState!.openDrawer(),
            )),
            SizedBox(width: 20),
            Container(width:42, height:42, child:
              ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
              leading: Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 32),
              onTap: (){
                bool isDark = ref.watch(isDarkProvider);
                ref.read(isDarkProvider.state).state = !isDark;
              },
            )),  
          ]),

          Expanded(child:
            Row(children: [
              if (Responsive.isMobile(context)==false)
                Container(width:42, child:
                  Sidebar(),
                ),
              Expanded(
                child: changeScreen(type),
              ),
          ]),
        ),
      ]),
    ));
  }

  Widget changeScreen(int type){
    if(type==1) return DashboardScreen();
    else if(type==2) return SchedulerScreen();
    else if(type==3) return Container();
    else if(type==4) return Container();
    else if(type==5) return Container();
    else return SchedulerScreen();
  }

}
