// @dart=2.9
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Features extends StatefulWidget {
  @override
  State<Features> createState() => _FeaturesState();
}

class _FeaturesState extends State<Features> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                      SizedBox(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                                Container(
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
                      Spacer(),
                      SizedBox(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                                Container(
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
                      Spacer(),
                      SizedBox(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                                Container(
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
                      Spacer(flex: 7),
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
                      SizedBox(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                                Container(
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
                      Spacer(),
                      SizedBox(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Container(
                                  width: 5.6.w,
                                  height: 5.6.w,
                                  child: FittedBox(
                                    child: Image.asset(
                                      'images/ic_child_book.png',
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
                      Spacer(),
                      SizedBox(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Container(
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
                      Spacer(),
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
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Container(
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
                      SizedBox(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                                Container(
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
                      Spacer(),
                      SizedBox(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                Container(
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
                      Spacer(),
                      SizedBox(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Theme.of(context).backgroundColor,
                                  ),
                                ),
                                Container(
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
                      Spacer(),
                      InkWell(
                        onTap: () {
                          if (!prefs.getIsSignIn)
                            return Navigator.pushNamed(context, '/register');
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
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      color: Theme.of(context).backgroundColor,
                                    ),
                                  ),
                                  Container(
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
                borderRadius: BorderRadius.only(
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
      ),
    );
  }
}
