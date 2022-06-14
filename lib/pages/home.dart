// @dart=2.9
import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
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
  List dbHome;

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
          future: getHomeImage(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
              return
                SizedBox(
                    width: 100.0.w,
                    height: 100.0.h,
                    child: Center(
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
                        Container(
                          width: 100.0.w,
                          height: 74.0.h,
                          child: Image.network(
                            dbHome[0]['image'],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 22.8.h),
                                    child: SpinKitDoubleBounce(
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
                                    padding: EdgeInsets.only(top: 4.2.w,),
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
                              SizedBox(height: 3.3.w,),
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
                      physics: BouncingScrollPhysics(),
                      child: Container(
                        width: 100.0.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
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
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.3.h,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.6.w,),
                              child: InkWell(
                                onTap: () {

                                },
                                child: Container(
                                  height: 11.7.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(24)),
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
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      if (!prefs.getIsSignIn) {
                                        prefs.setGoRoute('/profile');
                                        Navigator.pushNamed(context, '/register');
                                      } else Navigator.pushNamed(context, '/profile');
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
                            SizedBox(height: 3.8.h,),
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
                                  SizedBox(height: 2.8.h,),
                                  // ListView.builder(
                                  //   shrinkWrap: true,
                                  //   itemCount: 3,
                                  //   physics: NeverScrollableScrollPhysics(),
                                  //   padding: EdgeInsets.only(top: 0),
                                  //   scrollDirection: Axis.horizontal,
                                  //   itemBuilder: (context, index) {
                                  //     return ;
                                  //   },
                                  // ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {

                                        },
                                        child: Container(
                                          width: 86.6.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(12)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).shadowColor,
                                                blurRadius: 6.0,
                                                offset: Offset(0,3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3.9.w,),
                                    ],
                                  ),
                                  SizedBox(height: 3.1.h,),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/ic_forum_small.png',
                                        height: 3.2.w,
                                      ),
                                      SizedBox(width: 1.4.w,),
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
                                  SizedBox(height: 11.2.h,),
                                ],
                              ),
                            ),
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
                              offset: Offset(0,3),
                              blurRadius: 6.0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(44)),
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
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).shadowColor,
                                            blurRadius: 6.0,
                                            offset: Offset(0,3),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
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
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).shadowColor,
                                          blurRadius: 6.0,
                                          offset: Offset(0,3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
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
        ),
      ),
    );
  }
}
