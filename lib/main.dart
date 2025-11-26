import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'activity/splashscreen/view/splashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EdgeSafeWrapper(child: SplashScreen()),
    );
  }
}

// This ensures content respects system gesture areas (safe areas)
class EdgeSafeWrapper extends StatelessWidget {
  final Widget child;
  const EdgeSafeWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: true,
        bottom: true,
        left: false,
        right: false,
        child: child,
      ),
    );
  }
}
