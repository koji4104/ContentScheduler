import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main_screen.dart';
import 'schedule_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(isDarkProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schedule',
      theme: isDark ? ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        backgroundColor: Colors.indigo,
        //canvasColor: Colors.indigo,
      ) :ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        //canvasColor: Colors.indigo,
      ),
      home: MainScreen(),
    );
  }
}


