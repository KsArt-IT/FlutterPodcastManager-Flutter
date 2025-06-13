import 'package:flutter/material.dart';
import 'package:flutter_podcast_manager/app/app_router.dart';

class PodcastManagerApp extends StatelessWidget {
  const PodcastManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Podcast Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
