// @dart=2.9
import 'dart:convert';
import 'package:empat_bulan/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:empat_bulan/main.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Articles extends StatefulWidget {
  const Articles({Key key}) : super(key: key);

  @override
  State<Articles> createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  List dbArticles, dbNotifications;

  Future getArticles() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_article.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getNotifications() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_notifications.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
          return false;
        },
        child: FutureBuilder(
          future: getNotifications(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
              return
                SizedBox(
                    width: 100.0.w,
                    height: 100.0.h,
                    child: const Center(
                        child: SpinKitDoubleBounce(
                          color: Colors.white,
                        )
                    )
                );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              dbNotifications = snapshot.data as List;
            }
            return FutureBuilder(
              future: getArticles(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitPulse(
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  dbArticles = snapshot.data as List;
                }
                return Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 6.6.w),
                            child: Column(
                              children: [
                                SizedBox(height: 19.0.h,),
                                Text(
                                  'Artikel',
                                  style: TextStyle(
                                    fontSize: 24.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 3.1.h,),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dbArticles.length,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 0, left: 6.6.w, right: 6.6.w),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                      child: InkWell(
                                        child: Container(
                                          width: 86.6.w,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              const BorderRadius.all(
                                                Radius.circular(12),
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                      .shadowColor,
                                                  blurRadius: 6.0,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ]),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                const BorderRadius.only(
                                                  topLeft:
                                                  Radius.circular(12),
                                                  topRight:
                                                  Radius.circular(12),
                                                ),
                                                child: Container(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: Image.network(
                                                    dbArticles[index]['image'],
                                                    height: 43.0.w,
                                                    width: 86.6.w,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return SizedBox(
                                                        height: 43.0.w,
                                                        child: const Center(
                                                          child:
                                                          SpinKitPulse(
                                                            color: Colors
                                                                .white,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                EdgeInsets.fromLTRB(
                                                    3.8.w,
                                                    5.0.w,
                                                    3.8.w,
                                                    5.6.w),
                                                child: Text(
                                                  dbArticles[index]['title'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13.0.sp,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          prefs.setArticleId(dbArticles[index]['id']);
                                          Navigator.pushNamed(context, '/viewarticle');
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2.5.h,
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 12.5.h,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Column(
                              children: [
                                Container(
                                  height: 4.0.h,
                                  color: Colors.white,
                                ),
                                Container(
                                  height: 11.0.h,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white, Colors.white.withOpacity(0.0),
                                        ],
                                      )
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
                              },
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
                                        Icons.close,
                                        color: Colors.white,
                                        size: 7.0.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 5.6.h,),
                            Padding(
                              padding: EdgeInsets.only(right: 2.2.w,),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Search(),));
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Opacity(
                                      opacity: .8,
                                      child: Container(
                                        width: 12.5.w,
                                        height: 12.5.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 6.0,
                                              color: Theme.of(context).shadowColor,
                                              offset: const Offset(0, 3),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.6.w,
                                      height: 5.6.w,
                                      child: FittedBox(
                                        child: Image.asset(
                                          'images/ic_search.png',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: prefs.getIsSignIn ? true : false,
                          child: Column(
                            children: [
                              SizedBox(height: 5.6.h,),
                              Padding(
                                padding: EdgeInsets.only(right: 2.2.w,),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/notifications');
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Opacity(
                                        opacity: .8,
                                        child: Container(
                                          width: 12.5.w,
                                          height: 12.5.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).shadowColor,
                                                blurRadius: 6.0,
                                                offset: const Offset(0,3),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.6.w,
                                        height: 5.6.w,
                                        child: FittedBox(
                                          child: Image.asset('images/ic_forum_small.png'),
                                        ),
                                      ),
                                      Visibility(
                                        visible: dbNotifications.isNotEmpty ? true : false,
                                        child: Positioned(
                                          left: 7.8.w,
                                          top: 2.2.w,
                                          child: Container(
                                            width: 2.2.w,
                                            height: 2.2.w,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).errorColor,
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(50),
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 5.6.h,),
                            Padding(
                              padding: EdgeInsets.only(right: 6.6.w,),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/features');
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Opacity(
                                      opacity: .8,
                                      child: Container(
                                        width: 12.5.w,
                                        height: 12.5.w,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 6.0,
                                              color: Theme.of(context).shadowColor,
                                              offset: const Offset(0, 3),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.6.w,
                                      height: 5.6.w,
                                      child: FittedBox(
                                        child: Image.asset(
                                          'images/ic_menu.png',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
