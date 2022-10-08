
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:ugbussinesscard/ui/splashscreen.dart';
import 'package:ugbussinesscard/utils/dark_theme_provider.dart';
import 'package:ugbussinesscard/utils/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  runApp(const MyApp());
  getCurrentAppTheme();
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
