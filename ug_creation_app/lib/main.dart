import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ugbussinesscard/ui/splashscreen.dart';
import 'package:ugbussinesscard/utils/dark_theme_provider.dart';
import 'package:ugbussinesscard/utils/styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.setPersistenceCacheSizeBytes(1250000);
  final dir = await getApplicationDocumentsDirectory();
// For hive, isar and objectbox
  final dbPath = dir.path;
  await Hive.initFlutter(dbPath);
  await Hive.openBox("cards");
  runApp(const MyApp());
  getCurrentAppTheme();
  // removeKey("Card2");
  // removeKey("Card1");
  // removeKey("Card3");
  // removeKey("Card4");
  // removeKey("Card5");
  // removeKey("New");
  // removeKey("companydetail");
}

DarkThemeProvider themeChangeProvider = DarkThemeProvider();

void getCurrentAppTheme() async {
  themeChangeProvider.darkTheme =
      await themeChangeProvider.darkThemePreference.getTheme();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) {
      return themeChangeProvider;
    }, child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
      return MaterialApp(
        title: 'UG Business Card',
        debugShowCheckedModeBanner: false,
        theme: Styles.themeData(themeChangeProvider.darkTheme, context),
        home: SplashScreen(key: key),
      );
    }));
  }
}
