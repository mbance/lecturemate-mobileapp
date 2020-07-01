/// Import third-party packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecturemate/splash.dart';

/// Import class
import 'bloc/bloc_record.dart';

/// Run app
void main() => runApp(MyApp());

/// Create instance of app as stateful widget
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

/// Build app
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    /// Use MultiProvider to return changed status of recording from bloc_record.dart
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MuRecordBloc>.value(value: MuRecordBloc()),
      ],
      child: MaterialApp(
        /// Display Splash Page
        home: Splash(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}