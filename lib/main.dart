import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:upbox/pages/app_start.dart';
import 'package:upbox/services/location_provider.dart';
import 'package:upbox/services/widget_tree.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await dotenv.load(fileName: '.env');
  await Future.delayed(const Duration(seconds: 3));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
          child: const AppStart(),
        ),

        // ChangeNotifierProvider(
        //   create: (context) => GoogleSignInProvider(),
        //   child: const LoginPage(),
        // )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: "Work_Sans",
          brightness: Brightness.light,
        ),
        home: const WidgetTree(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
