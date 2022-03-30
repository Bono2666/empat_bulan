// @dart=2.9
import 'dart:convert';
import 'package:empat_bulan/pages/features.dart';
import 'package:empat_bulan/pages/home.dart';
import 'package:empat_bulan/pages/onboarding.dart';
import 'package:empat_bulan/pages/profile/profile.dart';
import 'package:empat_bulan/pages/register.dart';
import 'package:empat_bulan/pages/verification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await prefs.init();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List dbOnboarding;

  Future getOnboarding() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/get_onboarding.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getOnboarding(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return Container(
            color: Color(0xffC09AC7),
            child: SpinKitPulse(
              color: Colors.white,
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          dbOnboarding = snapshot.data as List;
          prefs.setTotOnboard(dbOnboarding?.length);
        }
        return Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              title: 'EmpatBulan',
              theme: ThemeData(
                fontFamily: GoogleFonts.josefinSans().fontFamily,

                colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: Color(0xffC09AC7),
                ),

                primaryColor: Color(0xffC09AC7),
                backgroundColor: Color(0xffA34C88),
                primaryColorDark: Color(0xff484848),
                shadowColor: Color(0x32000000),
                highlightColor: Color(0xffEBE1DD),
                unselectedWidgetColor: Color(0xff757575),
                dividerColor: Color(0xffD1D3D4),
                hintColor: Color(0xffCDCDCD),
                errorColor: Color(0xffE4572E),

                inputDecorationTheme: InputDecorationTheme(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffC09AC7),
                      width: 3,
                    ),
                  ),
                ),

                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Color(0xff9B9B9B),
                  selectionColor: Color(0xffC09AC7),
                  selectionHandleColor: Color(0xffA34C88),
                ),
              ),

              initialRoute: prefs.getFirstlaunch == false ? '/home' : '/',
              // ignore: missing_return
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/':
                    return SlideLeftRoute(page: Onboarding());
                  case '/home':
                    return SlideUpRoute(page: Home());
                  case '/features':
                    return SlideDownRoute(page: Features());
                  case '/register':
                    return SlideUpRoute(page: Register());
                  case '/verification':
                    return SlideLeftRoute(page: Verification());
                  case '/profile':
                    return SlideUpRoute(page: Profile());
                }
                return null;
              },
            );
          },
        );
      },
    );
  }
}

final prefs = SharedPrefs();

class SharedPrefs {
  var _prefs;

  init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  bool get getFirstlaunch => _prefs.getBool('firstlaunch') ?? true;
  int get getTotOnboard => _prefs.getInt('totOnboard') ?? 0;
  bool get getIsSignIn => _prefs.getBool('isSignIn') ?? false;
  String get getName => _prefs.getString('name') ?? '';
  String get getIsoCode => _prefs.getString('isoCode') ?? '';
  String get getDialCode => _prefs.getString('dialCode') ?? '';
  String get getPhone => _prefs.getString('phone') ?? '';
  String get getGoRoute => _prefs.getString('goroute') ?? '';

  setFirstlaunch(bool value) => _prefs.setBool('firstlaunch', value);
  setTotOnboard(int value) => _prefs.setInt('totOnboard', value);
  setIsSignIn(bool value) => _prefs.setBool('isSignIn', value);
  setName(String value) => _prefs.setString('name', value);
  setIsoCode(String value) => _prefs.setString('isoCode', value);
  setDialCode(String value) => _prefs.setString('dialCode', value);
  setPhone(String value) => _prefs.setString('phone', value);
  setGoRoute(String value) => _prefs.setString('goroute', value);
}

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpRoute({this.page}) :super(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
        animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
        return SlideTransition(
          position: Tween(
            begin: const Offset(0,1.2),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
        return page;
      }
  );
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRoute({this.page}) :super(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
        animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
        return SlideTransition(
          position: Tween(
            begin: const Offset(1.2,0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
        return page;
      }
  );
}

class SlideDownRoute extends PageRouteBuilder {
  final Widget page;

  SlideDownRoute({this.page}) :super(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child) {
        animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
        return SlideTransition(
          position: Tween(
            begin: const Offset(0,-1.2),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
        return page;
      }
  );
}