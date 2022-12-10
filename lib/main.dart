import 'dart:convert';
import 'dart:ui';
import 'package:empat_bulan/pages/childbook/add_childbook.dart';
import 'package:empat_bulan/pages/childbook/child_chart.dart';
import 'package:empat_bulan/pages/childbook/child_profile.dart';
import 'package:empat_bulan/pages/features.dart';
import 'package:empat_bulan/pages/home.dart';
import 'package:empat_bulan/pages/onboarding.dart';
import 'package:empat_bulan/pages/profile/upd_sched.dart';
import 'package:empat_bulan/pages/profile/profile.dart';
import 'package:empat_bulan/pages/hpl.dart';
import 'package:empat_bulan/pages/contractions.dart';
import 'package:empat_bulan/pages/kickcounter.dart';
import 'package:empat_bulan/pages/kickdetail.dart';
import 'package:empat_bulan/pages/profile/schedule.dart';
import 'package:empat_bulan/pages/profile/todo.dart';
import 'package:empat_bulan/pages/profile/upd_todo.dart';
import 'package:empat_bulan/pages/profile/upd_profile.dart';
import 'package:empat_bulan/pages/profile/upd_pregnancy.dart';
import 'package:empat_bulan/pages/profile/privacy.dart';
import 'package:empat_bulan/pages/profile/rules.dart';
import 'package:empat_bulan/pages/profile/about.dart';
import 'package:empat_bulan/pages/forum/new.dart';
import 'package:empat_bulan/pages/forum/list.dart';
import 'package:empat_bulan/pages/forum/view.dart';
import 'package:empat_bulan/pages/forum/notif.dart';
import 'package:empat_bulan/pages/register.dart';
import 'package:empat_bulan/pages/services/cart.dart';
import 'package:empat_bulan/pages/services/checkout.dart';
import 'package:empat_bulan/pages/services/classes.dart';
import 'package:empat_bulan/pages/services/confirm.dart';
import 'package:empat_bulan/pages/services/homeservices.dart';
import 'package:empat_bulan/pages/services/timeschedule.dart';
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
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List dbOnboarding;

  Future getOnboarding() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_onboarding.php');
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
          prefs.setTotOnboard(dbOnboarding.length);
        }
        return Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              title: 'EmpatBulan',
              theme: ThemeData(
                fontFamily: 'Josefin Sans',
                primaryColor: const Color(0xffC09AC7),
                primaryColorDark: const Color(0xff484848),
                primaryColorLight: const Color(0xffF2F2F2),
                shadowColor: const Color(0x32000000),
                highlightColor: const Color(0xffEBE1DD),
                unselectedWidgetColor: const Color(0xff757575),
                dividerColor: const Color(0xffD1D3D4),
                hintColor: const Color(0xffCDCDCD),
                toggleableActiveColor: const Color(0x38000000),
                bottomAppBarColor: const Color(0xff5299D3),
                indicatorColor: const Color(0xffFCB800),
                focusColor: const Color(0xff669900),

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
                ), colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: const Color(0xffC09AC7),
              ).copyWith(background: const Color(0xffA34C88)).copyWith(error: const Color(0xffE4572E)),
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
                  case '/notifications':
                    return SlideDownRoute(page: const Notifications());
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
                  case '/newquestion':
                    return SlideUpRoute(page: const NewQuestions());
                  case '/questionsList':
                    return SlideUpRoute(page: const QuestionsList());
                  case '/questionView':
                    return SlideLeftRoute(page: const QuestionView());
                  case '/contractions':
                    return SlideUpRoute(page: const Contractions());
                  case '/kickcounter':
                    return SlideUpRoute(page: const KickCounter());
                  case '/kickDetail':
                    return SlideLeftRoute(page: const KickDetail());
                  case '/childProfile':
                    return SlideUpRoute(page: const ChildProfile());
                  case '/childChart':
                    return SlideUpRoute(page: const ChildChart());
                  case '/addChildBook':
                    return SlideLeftRoute(page: const AddChildBook());
                  case '/homeServices':
                    return SlideUpRoute(page: const HomeServices());
                  case '/classes':
                    return SlideLeftRoute(page: const Classes());
                  case '/cart':
                    return SlideLeftRoute(page: const Cart());
                  case '/timeSchedule':
                    return SlideLeftRoute(page: const TimeSchedule());
                  case '/checkout':
                    return SlideLeftRoute(page: const Checkout());
                  case '/confirm':
                    return SlideLeftRoute(page: const Confirm());
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
  String get getQuestionId => _prefs.getString('questionid') ?? '';
  String get getLastContraction => _prefs.getString('lastContraction') ?? '';
  int get getTotalInterval => _prefs.getInt('totalInterval') ?? 0;
  int get getCountInterval => _prefs.getInt('countInterval') ?? 0;
  int get getTotalDuration => _prefs.getInt('totalDuration') ?? 0;
  int get getCountDuration => _prefs.getInt('countDuration') ?? 0;
  bool get getWarning => _prefs.getBool('warning') ?? false;
  String get getKickDay => _prefs.getString('kickDay') ?? '';
  String get getComplaint => _prefs.getString('complaint') ?? '';
  String get getPrivateDate => _prefs.getString('privateDate') ?? '';
  String get getPrivateTime => _prefs.getString('privateTime') ?? '';

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
  setQuestionId(String value) => _prefs.setString('questionid', value);
  setLastContraction(String value) => _prefs.setString('lastContraction', value);
  setTotalInterval(int value) => _prefs.setInt('totalInterval', value);
  setCountInterval(int value) => _prefs.setInt('countInterval', value);
  setTotalDuration(int value) => _prefs.setInt('totalDuration', value);
  setCountDuration(int value) => _prefs.setInt('countDuration', value);
  setWarning(bool value) => _prefs.setBool('warning', value);
  setKickDay(String value) => _prefs.setString('kickDay', value);
  setComplaint(String value) => _prefs.setString('complaint', value);
  setPrivateDate(String value) => _prefs.setString('privateDate', value);
  setPrivateTime(String value) => _prefs.setString('privateTime', value);
}

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpRoute({required this.page})
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

  SlideLeftRoute({required this.page})
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

  SlideDownRoute({required this.page})
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

class Blur extends StatefulWidget {
  const Blur({Key? key}) : super(key: key);

  @override
  State<Blur> createState() => _BlurState();
}

class _BlurState extends State<Blur> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return open
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 2.4.w, top: 2.4.w,),
          child: InkWell(
            onTap: () {
              setState(() {
                open = false;
              });
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: 11.1.w,
                  height: 11.1.w,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                SizedBox(
                  width: 5.6.w,
                  child: FittedBox(
                    child: Image.asset(
                      'images/ic_sensitive.png',
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    )
        : BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10,
      ),
      child: Container(
        color: Theme.of(context).colorScheme.background.withOpacity(0.8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 8.0.w,
              child: FittedBox(
                child: Image.asset(
                  'images/ic_sensitive.png',
                ),
              ),
            ),
            SizedBox(height: 2.4.w,),
            const Text(
              'Konten-Sensitif',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.4.w,),
            InkWell(
              onTap: () {
                setState(() {
                  open = true;
                });
              },
              child: Container(
                width: 28.0.w,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.4.w,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 2.4.w,),
                      const Text(
                        'Lihat',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.4.w,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}