// @dart=2.9
import 'dart:convert';
import 'package:empat_bulan/pages/features.dart';
import 'package:empat_bulan/pages/home.dart';
import 'package:empat_bulan/pages/onboarding.dart';
import 'package:empat_bulan/pages/profile/upd_sched.dart';
import 'package:empat_bulan/pages/profile/profile.dart';
import 'package:empat_bulan/pages/hpl.dart';
import 'package:empat_bulan/pages/profile/schedule.dart';
import 'package:empat_bulan/pages/profile/todo.dart';
import 'package:empat_bulan/pages/profile/upd_todo.dart';
import 'package:empat_bulan/pages/profile/upd_profile.dart';
import 'package:empat_bulan/pages/profile/upd_pregnancy.dart';
import 'package:empat_bulan/pages/profile/privacy.dart';
import 'package:empat_bulan/pages/profile/rules.dart';
import 'package:empat_bulan/pages/profile/about.dart';
import 'package:empat_bulan/pages/register.dart';
import 'package:empat_bulan/pages/verification.dart';
import 'package:empat_bulan/pages/articles.dart';
import 'package:empat_bulan/pages/viewarticle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await prefs.init();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List dbOnboarding;

  Future getOnboarding() async {
    var url =
        Uri.parse('https://empatbulan.bonoworks.id/api/get_onboarding.php');
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
            color: const Color(0xffC09AC7),
            child: const SpinKitPulse(
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
                fontFamily: 'Josefin Sans',
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  secondary: const Color(0xffC09AC7),
                ),
                primaryColor: const Color(0xffC09AC7),
                backgroundColor: const Color(0xffA34C88),
                primaryColorDark: const Color(0xff484848),
                shadowColor: const Color(0x32000000),
                highlightColor: const Color(0xffEBE1DD),
                unselectedWidgetColor: const Color(0xff757575),
                dividerColor: const Color(0xffD1D3D4),
                hintColor: const Color(0xffCDCDCD),
                errorColor: const Color(0xffE4572E),
                toggleableActiveColor: const Color(0x38000000),
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
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffC09AC7),
                      width: 3,
                    ),
                  ),
                ),
                textSelectionTheme: const TextSelectionThemeData(
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
                    return SlideLeftRoute(page: const Onboarding());
                  case '/home':
                    return SlideUpRoute(page: const Home());
                  case '/features':
                    return SlideDownRoute(page: const Features());
                  case '/register':
                    return SlideUpRoute(page: const Register());
                  case '/verification':
                    return SlideLeftRoute(page: const Verification());
                  case '/profile':
                    return SlideUpRoute(page: const Profile());
                  case '/schedule':
                    return SlideLeftRoute(page: const Schedule());
                  case '/updSchedule':
                    return SlideLeftRoute(page: const UpdSched());
                  case '/todo':
                    return SlideLeftRoute(page: const ToDo());
                  case '/updTodo':
                    return SlideLeftRoute(page: const UpdTodo());
                  case '/updProfile':
                    return SlideLeftRoute(page: const UpdProfile());
                  case '/updPregnancy':
                    return SlideLeftRoute(page: const UpdPregnancy());
                  case '/privacy':
                    return SlideLeftRoute(page: const Privacy());
                  case '/rules':
                    return SlideLeftRoute(page: const Rules());
                  case '/about':
                    return SlideLeftRoute(page: const About());
                  case '/hpl':
                    return SlideUpRoute(page: const Hpl());
                  case '/articles':
                    return SlideUpRoute(page: const Articles());
                  case '/viewarticle':
                    return SlideLeftRoute(page: const ViewArticle());
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
  // ignore: prefer_typing_uninitialized_variables
  var _prefs;

  init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  bool get getFirstlaunch => _prefs.getBool('firstlaunch') ?? true;
  int get getTotOnboard => _prefs.getInt('totOnboard') ?? 0;
  bool get getIsSignIn => _prefs.getBool('isSignIn') ?? false;
  String get getName => _prefs.getString('name') ?? '';
  String get getIsoCode => _prefs.getString('isoCode') ?? '';
  String get getDialCode => _prefs.getString('dialCode') ?? '';
  String get getPhone => _prefs.getString('phone') ?? '';
  String get getGoRoute => _prefs.getString('goRoute') ?? '';
  String get getBackRoute => _prefs.getString('backRoute') ?? '';
  bool get getIsUpdSched => _prefs.getBool('isUpdSched') ?? true;
  String get getSchedTitle => _prefs.getString('schedTitle') ?? '';
  String get getSchedDate => _prefs.getString('schedDate') ?? '';
  String get getSchedTime => _prefs.getString('schedTime') ?? '';
  String get getSchedNotes => _prefs.getString('schedNotes') ?? '';
  bool get getIsUpdTodo => _prefs.getBool('isUpdTodo') ?? true;
  String get getTodoId => _prefs.getString('todoId') ?? '';
  String get getTodoTitle => _prefs.getString('todoTitle') ?? '';
  String get getFmtPhone => _prefs.getString('fmtPhone') ?? '';
  String get getEmail => _prefs.getString('email') ?? '';
  String get getArticleId => _prefs.getString('articleid') ?? '';

  setFirstlaunch(bool value) => _prefs.setBool('firstlaunch', value);
  setTotOnboard(int value) => _prefs.setInt('totOnboard', value);
  setIsSignIn(bool value) => _prefs.setBool('isSignIn', value);
  setName(String value) => _prefs.setString('name', value);
  setIsoCode(String value) => _prefs.setString('isoCode', value);
  setDialCode(String value) => _prefs.setString('dialCode', value);
  setPhone(String value) => _prefs.setString('phone', value);
  setGoRoute(String value) => _prefs.setString('goRoute', value);
  setBackRoute(String value) => _prefs.setString('backRoute', value);
  setIsUpdSched(bool value) => _prefs.setBool('isUpdSched', value);
  setSchedTitle(String value) => _prefs.setString('schedTitle', value);
  setSchedDate(String value) => _prefs.setString('schedDate', value);
  setSchedTime(String value) => _prefs.setString('schedTime', value);
  setSchedNotes(String value) => _prefs.setString('schedNotes', value);
  setIsUpdTodo(bool value) => _prefs.setBool('isUpdTodo', value);
  setTodoId(String value) => _prefs.setString('todoId', value);
  setTodoTitle(String value) => _prefs.setString('todoTitle', value);
  setFmtPhone(String value) => _prefs.setString('fmtPhone', value);
  setEmail(String value) => _prefs.setString('email', value);
  setArticleId(String value) => _prefs.setString('articleid', value);
}

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpRoute({this.page})
      : super(
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return page;
            });
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget page;

  SlideLeftRoute({this.page})
      : super(
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return SlideTransition(
                position: Tween(
                  begin: const Offset(1.2, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return page;
            });
}

class SlideDownRoute extends PageRouteBuilder {
  final Widget page;

  SlideDownRoute({this.page})
      : super(
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secAnimation,
                Widget child) {
              animation = CurvedAnimation(
                  parent: animation, curve: Curves.elasticInOut);
              return SlideTransition(
                position: Tween(
                  begin: const Offset(0, -1.2),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secAnimation) {
              return page;
            });
}
