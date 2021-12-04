import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main_screen.dart';
import 'scheduler_provider.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(isDarkProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drag Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      home: MainScreen(),
    );
  }
}


