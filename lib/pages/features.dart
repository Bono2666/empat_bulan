import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Features extends StatefulWidget {
  const Features({Key? key}) : super(key: key);

  @override
  State<Features> createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  late List dbChildBook;

  Future getChildBook() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_childbook.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getChildBook(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
            return
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitDoubleBounce(
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            dbChildBook = snapshot.data as List;
          }
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.0.w,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 19.0.h,),
                    Text(
                      'AKTIVITAS',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                    ),
                    SizedBox(height: 3.1.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.2.w,),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              if (!prefs.getIsSignIn) {
                                Navigator.pushReplacementNamed(context, '/register');
                              } else {
                                Navigator.pushReplacementNamed(context, '/questionsList');
                              }
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_forum.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.0.w,),
                                  Text(
                                    'Forum Saya',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (!prefs.getIsSignIn) {
                                prefs.setGoRoute('/schedule');
                                Navigator.pushReplacementNamed(context, '/register');
                              } else {
                                Navigator.pushReplacementNamed(context, '/schedule');
                              }
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_schedule.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.0.w,),
                                  Text(
                                    'Jadwal Kontrol',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (!prefs.getIsSignIn) {
                                Navigator.pushReplacementNamed(context, '/register');
                              } else {
                                Navigator.pushReplacementNamed(context, '/todo');
                              }
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_checklist.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.5.w,),
                                  Text(
                                    'To Do List',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(flex: 7),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.1.h,),
                    Text(
                      'SEMUA FITUR',
                      style: TextStyle(
                        fontSize: 12.0.sp,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                    ),
                    SizedBox(height: 3.1.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.2.w,),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_service.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.0.w,),
                                  Text(
                                    'Layanan',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              if (!prefs.getIsSignIn) {
                                prefs.setGoRoute('/homeServices');
                                Navigator.pushReplacementNamed(context, '/register');
                              } else {
                                Navigator.pushReplacementNamed(context, '/homeServices');
                              }
                            },
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              prefs.setBackRoute('/home');
                              if (!prefs.getIsSignIn) {
                                if (dbChildBook.isEmpty) {
                                  prefs.setGoRoute('/childProfile');
                                } else {
                                  prefs.setGoRoute('/childChart');
                                }
                                Navigator.pushReplacementNamed(context, '/register');
                              } else {
                                if (dbChildBook.isEmpty) {
                                  Navigator.pushReplacementNamed(context, '/childProfile');
                                } else {
                                  Navigator.pushReplacementNamed(context, '/childChart');
                                }
                              }
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_child_white.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.0.w,),
                                  Text(
                                    'Buku Anak',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/kickcounter');
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
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
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_kick.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.0.w,),
                                  Text(
                                    'Kick Counter',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (prefs.getWarning) {
                                showDialog(
                                  context: context,
                                  builder: (_) => const Warning(),
                                  barrierDismissible: false,
                                );
                              } else {
                                Navigator.pushReplacementNamed(context, '/contractions');
                              }
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
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
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_contraction.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.5.w,),
                                  Text(
                                    'Kontraksi',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.4.h,),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.2.w,),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              if (!prefs.getIsSignIn) {
                                prefs.setGoRoute('/newquestion');
                                Navigator.pushReplacementNamed(context, '/register');
                              } else {
                                Navigator.pushReplacementNamed(context, '/newquestion');
                              }
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_forum.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.0.w,),
                                  Text(
                                    'Forum',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/articles');
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
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
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_article.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.0.w,),
                                  Text(
                                    'Artikel',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (!prefs.getIsSignIn) {
                                prefs.setGoRoute('/hpl');
                                Navigator.pushReplacementNamed(context, '/register');
                              } else {
                                Navigator.pushReplacementNamed(context, '/hpl');
                              }
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_hpl.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.0.w,),
                                  Text(
                                    'HPL',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                      height: 1.2,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              if (!prefs.getIsSignIn) {
                                prefs.setGoRoute('/profile');
                                Navigator.pushReplacementNamed(context, '/register');
                              } else {
                                Navigator.pushReplacementNamed(context, '/profile');
                              }
                            },
                            child: SizedBox(
                              width: 16.7.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_profile.png',
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 2.5.w,),
                                  Text(
                                    'Profil',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 19.0.w,
                  height: 15.0.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      SizedBox(
                        width: 19.0.w,
                        height: 19.0.w,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 5.2.w,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Warning extends StatefulWidget {
  const Warning({Key? key}) : super(key: key);

  @override
  State<Warning> createState() => _WarningState();
}

class _WarningState extends State<Warning>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84.0.w,
              constraints: BoxConstraints(
                minHeight: 24.4.w,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(40),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 24,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.8.w,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8.8.w,),
                        Image.asset(
                          'images/baby_button.png',
                          height: 28.0.w,
                        ),
                        SizedBox(height: 6.7.w,),
                        Text(
                          'Kontraksi Bunda sekarang berjarak kurang dari 5 menit. '
                              'Pertimbangkan untuk pergi ke rumah sakit atau menghubungi '
                              'dokter/bidan Bunda.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11.0.sp,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 6.7.w,),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(context, '/contractions');
                            },
                            child: Container(
                              width: 28.0.w,
                              height: 20.0.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Ok',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}