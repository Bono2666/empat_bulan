// @dart=2.9
import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:empat_bulan/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List dbHome, dbTimeline, dbProfile, dbArticle;
  bool firstLoad = true;
  int currentAge;

  @override
  void initState() {
    super.initState();

    prefs.setFirstlaunch(false);
  }

  Future getHomeImage() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/get_home_image.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getProfile() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getTimeline() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/get_timeline.php?id=$currentAge');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getArticles() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/get_home_article.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
        child: FutureBuilder(
          future: getArticles(),
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
              dbArticle = snapshot.data as List;
            }
            return FutureBuilder(
              future: getProfile(),
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
                  dbProfile = snapshot.data as List;

                  if (firstLoad) {
                    if (dbProfile[0]['basecount'] != '') {
                      // DateTime hpl = DateTime(
                      //     int.parse(dbProfile[0]['hpl'].substring(0, 4)),
                      //     int.parse(dbProfile[0]['hpl'].substring(5, 7)),
                      //     int.parse(dbProfile[0]['hpl'].substring(8, 10))
                      // );

                      DateTime hpht = DateTime(
                          int.parse(dbProfile[0]['hpht'].substring(0, 4)),
                          int.parse(dbProfile[0]['hpht'].substring(5, 7)),
                          int.parse(dbProfile[0]['hpht'].substring(8, 10))
                      );

                      currentAge = (DateTime.now().difference(hpht).inDays);
                    }

                    firstLoad = false;
                  }
                }
                return FutureBuilder(
                  future: getTimeline(),
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
                      dbTimeline = snapshot.data as List;
                    }
                    return FutureBuilder(
                      future: getHomeImage(),
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
                          dbHome = snapshot.data as List;
                        }
                        return Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 100.0.w,
                                      height: 74.0.h,
                                      child: Image.network(
                                        dbProfile[0]['basecount'] == '' ? dbHome[0]['image'] : dbTimeline[0]['image'],
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(top: 22.8.h),
                                                child: const SpinKitDoubleBounce(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 26.0.h,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                dbProfile[0]['basecount'] == '' ? Container() : Container(
                                  height: 45.6.h,
                                  padding: EdgeInsets.only(right: 7.2.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Stack(
                                            alignment: AlignmentDirectional.topCenter,
                                            children: [
                                              Text(
                                                'Pekan',
                                                style: TextStyle(
                                                  fontSize: 13.0.sp,
                                                  color: Theme.of(context).backgroundColor,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 2.8.h),
                                                child: Text(
                                                  dbTimeline[0]['week'],
                                                  style: TextStyle(
                                                    fontSize: 50.0.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context).backgroundColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 1.8.h,)
                                        ],
                                      ),
                                      SizedBox(width: 3.8.w,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Stack(
                                            alignment: AlignmentDirectional.topCenter,
                                            children: [
                                              Text(
                                                'Hari',
                                                style: TextStyle(
                                                  fontSize: 9.0.sp,
                                                  color: Theme.of(context).backgroundColor,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 2.0.h,),
                                                child: Text(
                                                  dbTimeline[0]['day'],
                                                  style: TextStyle(
                                                    fontSize: 27.0.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4.0.h,)
                                        ],
                                      ),
                                      SizedBox(width: 2.8.w,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              'Usia kehamilan',
                                              style: TextStyle(
                                                fontSize: 10.0.sp,
                                                color: Theme.of(context).backgroundColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 3.4.h,)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 30.0.w,
                                  padding: EdgeInsets.only(right: 74.4.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Stack(
                                            alignment: AlignmentDirectional.topCenter,
                                            children: [
                                              Text(
                                                'Hari ini',
                                                style: TextStyle(
                                                  color: Theme.of(context).backgroundColor,
                                                  fontSize: 10.0.sp,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 2.4.h,),
                                                child: Text(
                                                  DateTime.now().day.toString(),
                                                  style: TextStyle(
                                                    color: Theme.of(context).backgroundColor,
                                                    fontSize: 36.0.sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 1.2.w,),
                                        ],
                                      ),
                                      SizedBox(width: 1.4.w,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          RotatedBox(
                                            quarterTurns: 3,
                                            child: Text(
                                              DateFormat('MMM yyyy', 'id_ID').format(DateTime.now()),
                                              style: TextStyle(
                                                color: Theme.of(context).backgroundColor,
                                                fontSize: 10.0.sp,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4.4.w,),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.54,
                              minChildSize: 0.54,
                              maxChildSize: 1.0,
                              builder: (context, scrollController) {
                                return SingleChildScrollView(
                                  controller: scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  child: Container(
                                    width: 100.0.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(56),
                                      ),
                                      border: Border.all(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 1.8.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 8.6.w,
                                              height: 0.5.h,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 6.3.h,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10.6.w,),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => const Search(),));
                                            },
                                            child: Container(
                                              height: 11.7.w,
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(24)),
                                                border: Border.all(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'images/ic_search.png',
                                                    height: 5.3.w,
                                                  ),
                                                  SizedBox(width: 3.3.w,),
                                                  Text(
                                                    'Cari pertanyaan, artikel',
                                                    style: TextStyle(
                                                      fontSize: 12.0.sp,
                                                      color: Theme.of(context).primaryColorDark,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3.0.h,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 11.8.w,),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  prefs.setIsSignIn(false);
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
                                                              color: Theme.of(context).backgroundColor,
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
                                                      SizedBox(height: 2.5.w,),
                                                      Text(
                                                        'Forum',
                                                        style: TextStyle(
                                                          fontSize: 10.0.sp,
                                                          color: Colors.black,
                                                        ),
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
                                                      SizedBox(height: 2.5.w,),
                                                      Text(
                                                        'Artikel',
                                                        style: TextStyle(
                                                          fontSize: 10.0.sp,
                                                          color: Colors.black,
                                                        ),
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
                                                    Navigator.pushNamed(context, '/register');
                                                  } else {
                                                    Navigator.pushNamed(context, '/hpl');
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
                                                              color: Theme.of(context).backgroundColor,
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
                                                      SizedBox(height: 2.5.w,),
                                                      Text(
                                                        'HPL',
                                                        style: TextStyle(
                                                          fontSize: 10.0.sp,
                                                          color: Colors.black,
                                                        ),
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
                                                    Navigator.pushNamed(context, '/register');
                                                  } else {
                                                    Navigator.pushNamed(context, '/profile');
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
                                                              color: Theme.of(context).backgroundColor,
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
                                        SizedBox(height: 4.1.h,),
                                        dbProfile[0]['basecount'] == '' ? Container() : Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 6.6.w,),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        'images/ic_size.png',
                                                        width: 3.2.w,
                                                      ),
                                                      SizedBox(width: 1.4.w,),
                                                      Column(
                                                        children: [
                                                          SizedBox(height: 0.8.w,),
                                                          Text(
                                                            'Ukuran Bayi',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 10.0.sp,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 1.3.h,),
                                                  Container(
                                                    width: 100.0.w,
                                                    constraints: BoxConstraints(minHeight: 10.0.h,),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Theme.of(context).shadowColor,
                                                          blurRadius: 6,
                                                          offset: const Offset(0, 3),
                                                        ),
                                                      ],
                                                      borderRadius: const BorderRadius.all(
                                                        Radius.circular(12),
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.symmetric(vertical: 5.6.w),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 4.4.w),
                                                          child: Text(
                                                            'Ukuran Bayi di Pekan ke ${dbTimeline[0]['week']}',
                                                            style: TextStyle(
                                                              fontSize: 13.0.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 1.2.w,),
                                                        Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 2.35.w),
                                                          child: Html(
                                                            data: dbTimeline[0]['size_desc'],
                                                            style: {
                                                              'body': Style(
                                                                fontSize: FontSize.percent(112),
                                                                fontWeight: FontWeight.w400,
                                                                color: Colors.black,
                                                                padding: const EdgeInsets.all(0),
                                                                lineHeight: LineHeight.percent(112),
                                                              ),
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 2.0.h,),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.6.w,),
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'images/ic_article_small.png',
                                                    height: 3.2.w,
                                                  ),
                                                  SizedBox(width: 1.4.w,),
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 0.8.w,),
                                                      Text(
                                                        'Artikel',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10.0.sp,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 2.8.h,),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 69.6.w,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: dbArticle.length,
                                            physics: const BouncingScrollPhysics(),
                                            padding: EdgeInsets.fromLTRB(6.6.w, 0, 2.4.w, 3.1.h),
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  InkWell(
                                                    child: Container(
                                                      width: 86.6.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: const BorderRadius.all(
                                                            Radius.circular(12),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Theme.of(context).shadowColor,
                                                              blurRadius: 6.0,
                                                              offset: const Offset(0,3),
                                                            ),
                                                          ]
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(12),
                                                              topRight: Radius.circular(12),
                                                            ),
                                                            child: Container(
                                                              color: Theme.of(context).primaryColor,
                                                              child: Image.network(
                                                                dbArticle[index]['image'],
                                                                height: 43.0.w,
                                                                width: 86.6.w,
                                                                fit: BoxFit.cover,
                                                                loadingBuilder: (context, child, loadingProgress) {
                                                                  if (loadingProgress == null) return child;
                                                                  return SizedBox(
                                                                    height: 43.0.w,
                                                                    child: const Center(
                                                                      child: SpinKitPulse(
                                                                        color: Colors.white,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.fromLTRB(3.8.w,5.0.w,3.8.w,5.6.w),
                                                            child: Text(
                                                              dbArticle[index]['title'],
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
                                                      prefs.setArticleId(dbArticle[index]['id']);
                                                      Navigator.pushNamed(context, '/viewarticle');
                                                    },
                                                  ),
                                                  SizedBox(width: 3.9.w,),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.6.w,),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/ic_forum_small.png',
                                                height: 3.2.w,
                                              ),
                                              SizedBox(width: 1.4.w,),
                                              Column(
                                                children: [
                                                  SizedBox(height: 0.8.w,),
                                                  Text(
                                                    'Forum',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10.0.sp,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 11.2.h,),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 3.8.h,),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 88.9.w,
                                    height: 26.7.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).shadowColor,
                                          offset: const Offset(0,3),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(Radius.circular(44)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.6.w,),
                                          child: Row(
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
                                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                            color: Theme.of(context).backgroundColor,
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
                                                    SizedBox(height: 2.5.w,),
                                                    Text(
                                                      'Layanan',
                                                      style: TextStyle(
                                                        fontSize: 8.0.sp,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
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
                                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                        SizedBox(
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
                                                    SizedBox(height: 2.5.w,),
                                                    Text(
                                                      'Buku Anak',
                                                      style: TextStyle(
                                                        fontSize: 8.0.sp,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
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
                                                    SizedBox(height: 2.5.w,),
                                                    Text(
                                                      'Kick Counter',
                                                      style: TextStyle(
                                                        fontSize: 8.0.sp,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
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
                                                        fontSize: 8.0.sp,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 6.6.w, top: 5.6.h,),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Visibility(
                                        visible: prefs.getIsSignIn ? true : false,
                                        child: InkWell(
                                          onTap: () {

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
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2.2.w,),
                                      InkWell(
                                        onTap: () {
                                          prefs.setBackRoute('/home');
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
                                                child: Image.asset('images/ic_menu.png'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
