/// Import third-party packages
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

/// Import [home.dart] class from package
import 'package:lecturemate/home.dart';


void main() {
  runApp(new MaterialApp(
    home: new Splash(), /// Set Splash package to Home screen (initial loading screen)
  ));
}

/// New State [Splash]
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

/// Build Splash Screen UI
class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen( /// Splash screen parameters
        seconds: 3,
        backgroundColor: Colors.white,
        image: Image.asset('assets/img/logo.jpg'),
        photoSize: 100.0,
        loaderColor: Colors.red,
        navigateAfterSeconds: HomeScreen());
  }
}
