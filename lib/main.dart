import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hear_me_final/ui/gender/GenderScreen.dart';
import 'package:hear_me_final/ui/home/HomeScreen.dart';
import 'package:hear_me_final/ui/selectmusicforsing/SelectMusicForSing.dart';
import 'package:hear_me_final/utils/Color.dart';
import 'package:hear_me_final/utils/Preference.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';
import 'ui/login/LogInScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preference().instance();
  // await Preference.clear();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
        initializeDateFormatting(_locale!.languageCode);
      });
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: [
          Locale('en', ''),
        ],
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode &&
                supportedLocale.countryCode == locale?.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          accentColor: CColor.white,
          accentIconTheme: IconThemeData(color: CColor.white),
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            backgroundColor: CColor.transparent,
          ),
        ),
        theme: ThemeData(
          splashColor: CColor.transparent,
          highlightColor: CColor.transparent,
          fontFamily: 'Poppins',
          primarySwatch: Colors.blue,
        ),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: CColor.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarColor: CColor.txt_black,
          ),
          // child: LogInScreen(),
          child: Preference().getLoginBool(Preference.IS_LOGIN) == true
              ? HomeScreen(fromSignup: false,)
              : LogInScreen(),
          // child: SelectMusicForSing(),
        ),
        routes: <String, WidgetBuilder>{
          '/genderScreen': (BuildContext context) => GenderScreen(),
          '/searchScreen': (BuildContext context) =>
              SelectMusicForSing((value) {
                return value;
              }),
        });
  }
}
