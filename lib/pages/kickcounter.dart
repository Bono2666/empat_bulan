// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:empat_bulan/pages/db/kick_db.dart';

class KickCounter extends StatefulWidget {
  const KickCounter({Key key}) : super(key: key);

  @override
  State<KickCounter> createState() => _KickCounterState();
}

class _KickCounterState extends State<KickCounter> {
  List dbNotifications, dbList, dbGroup;
  String selectedTab = 'kick';
  var dbKick = KickDb();
  int lastDay;
  int selectedIndex = 0;
  String selectedDay;

  Future getNotifications() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_notifications.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
            return
              SizedBox(
                  width: 100.0.w,
                  height: 100.0.h,
                  child: Center(
                      child: SpinKitDoubleBounce(
                        color: Theme.of(context).primaryColor,
                      )
                  )
              );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            dbNotifications = snapshot.data as List;
          }
          return FutureBuilder(
            future: dbKick.list(DateFormat('d MMM yyyy', 'id_ID').format(DateTime.now())),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                return
                  SizedBox(
                      width: 100.0.w,
                      height: 100.0.h,
                      child: Center(
                          child: SpinKitDoubleBounce(
                            color: Theme.of(context).primaryColor,
                          )
                      )
                  );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                dbList = snapshot.data as List;
              }
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7.0.w,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 19.0.h,),
                          Text(
                            'Kick Counter',
                            style: TextStyle(
                              fontSize: 24.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.5.h,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'kick';
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(
                                          color: selectedTab == 'kick'
                                              ? Colors.transparent : Theme.of(context).primaryColor
                                      ),
                                      color: selectedTab == 'kick'
                                          ? Theme.of(context).primaryColor : Colors.transparent
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(4.4.w, 3.9.w, 4.4.w, 3.6.w),
                                    child: Text(
                                      'Kick',
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: selectedTab == 'kick'
                                            ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.2.w,),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'riwayat';
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(
                                          color: selectedTab == 'riwayat'
                                              ? Colors.transparent : Theme.of(context).primaryColor
                                      ),
                                      color: selectedTab == 'riwayat'
                                          ? Theme.of(context).primaryColor : Colors.transparent
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(4.4.w, 3.9.w, 4.4.w, 3.6.w),
                                    child: Text(
                                      'Riwayat',
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: selectedTab == 'riwayat'
                                            ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: selectedTab == 'kick' ? true : false,
                            child: Column(
                              children: [
                                SizedBox(height: 3.8.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/ic_contractions_small.png',
                                      height: 3.3.w,
                                    ),
                                    SizedBox(width: 1.4.w,),
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.6.w),
                                      child: Text(
                                        'Ketuk kaki untuk mulai menghitung tendangan',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.4.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.bottomCenter,
                                      children: [
                                        Container(
                                          width: 53.3.w,
                                          height: 53.3.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1.0,
                                              style: BorderStyle.solid,
                                              color: Theme.of(context).backgroundColor,
                                            ),
                                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(3.3.w),
                                            child: InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) => const Kick(),
                                                  barrierDismissible: false,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 4.0,
                                                    style: BorderStyle.solid,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'images/ic_foot.png',
                                                    height: 18.3.w,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  dbKick.del();
                                                  selectedIndex = 0;
                                                  prefs.setLastContraction('');
                                                  prefs.setTotalDuration(0);
                                                  prefs.setCountDuration(0);
                                                });
                                              },
                                              child: Container(
                                                width: 11.1.w,
                                                height: 11.1.w,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    width: 1.0,
                                                    style: BorderStyle.solid,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                                                ),
                                                child: Center(
                                                  child: Image.asset(
                                                    'images/ic_reset.png',
                                                    width: 5.6.w,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 31.1.w,),
                                            Container(
                                              width: 11.1.w,
                                              height: 11.1.w,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  width: 1.0,
                                                  style: BorderStyle.solid,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                                borderRadius: const BorderRadius.all(Radius.circular(100)),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 1.0.w,),
                                                  child: Text(
                                                    dbList.isEmpty ? '0' : dbList.length.toString(),
                                                    style: TextStyle(
                                                      fontSize: 17.0.sp,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black,
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
                                SizedBox(height: 3.8.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.0.w,),
                                      child: Text(
                                        DateTime.now().day.toString(),
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 33.0.sp,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('MMM', 'id_ID').format(DateTime.now()),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.0.sp,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('yyyy', 'id_ID').format(DateTime.now()),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.0.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.6.h,),
                                dbList.isNotEmpty
                                    ? Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 3.0.w,),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 18.0.w,
                                            child: Text(
                                              'Waktu',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10.0.sp,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Gerakan',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10.0.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 3.1.h,),
                                    SizedBox(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: dbList.length,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(top: 0),
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(3.3.w, 0, 3.3.w, 4.4.w),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 18.0.w,
                                                        child: Text(
                                                          dbList[index]['time'].toString().substring(
                                                              dbList[index]['time'].toString().length - 8,
                                                              dbList[index]['time'].toString().length),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.0.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 58.0.w,
                                                        child: Text(
                                                          dbList[index]['move'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.0.sp,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 1.7.w,
                                                        height: 1.7.w,
                                                        decoration: BoxDecoration(
                                                          color: Color(int.parse(dbList[index]['color'])),
                                                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 4.4.w),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )
                                    : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 2.5.h,),
                                        Text(
                                          "Belum Ada Data Tendangan",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0.sp,
                                          ),
                                        ),
                                        SizedBox(height: 2.5.h,),
                                        Image.asset(
                                          'images/no_contractions.png',
                                          width: 56.0.w,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: selectedTab == 'riwayat' ? true : false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder(
                                  future: dbKick.group(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 28.0.h,),
                                          SpinKitThreeBounce(
                                            color: Theme.of(context).primaryColor,
                                            size: 20,
                                          ),
                                        ],
                                      );
                                    }
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      dbGroup = snapshot.data;
                                    }
                                    return dbGroup.isNotEmpty
                                        ? Column(
                                      children: [
                                        SizedBox(height: 6.7.h,),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 3.0.w,),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 27.8.w,
                                                child: Text(
                                                  'Tanggal',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10.0.sp,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 28.9.w,
                                                child: Text(
                                                  'Tendangan ke-',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10.0.sp,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Dirasakan',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10.0.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 3.1.h,),
                                        SizedBox(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: dbGroup.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.only(top: 0),
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      prefs.setKickDay(dbGroup[index]['kickDay']);
                                                      Navigator.pushNamed(context, '/kickDetail');
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          bottom: BorderSide(
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets.fromLTRB(3.3.w, 0, 0, 4.4.w),
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 27.8.w,
                                                              child: Text(
                                                                dbGroup[index]['kickDay'],
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 12.0.sp,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 23.3.w,
                                                              child: Text(
                                                                dbGroup[index]['kickCount'].toString(),
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 12.0.sp,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            SizedBox(width: 5.6.w,),
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 7.4.w),
                                                              child: Container(
                                                                width: 1.7.w,
                                                                height: 1.7.w,
                                                                decoration: BoxDecoration(
                                                                  color: Color(int.parse(dbGroup[index]['color'])),
                                                                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                                                                ),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Image.asset(
                                                              'images/ic_right_arrow.png',
                                                              width: 8.9.w,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.4.w),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                        : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 8.0.h,),
                                            Text(
                                              "Belum Ada Data Tendangan",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.0.sp,
                                              ),
                                            ),
                                            SizedBox(height: 2.5.h,),
                                            Image.asset(
                                              'images/no_contractions.png',
                                              width: 56.0.w,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 11.3.h,),
                        ],
                      ),
                    ),
                  ),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  Icons.close,
                                  size: 7.0.w,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Column(
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
                                        'images/ic_forum_small.png',
                                      ),
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
    );
  }
}

class Kick extends StatefulWidget {
  const Kick({Key key}) : super(key: key);

  @override
  State<Kick> createState() => _KickState();
}

class _KickState extends State<Kick>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;
  var dbKick = KickDb();

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
              width: 72.2.w,
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
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.1.w,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 7.8.w,),
                        Text(
                          'Gerakan',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.0.sp,
                          ),
                        ),
                        SizedBox(height: 10.0.w,),
                        Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    dbKick.insert(DateFormat('d MMM yyyy HH:mm:ss', 'id_ID')
                                        .format(DateTime.now()), 'Tendangan Dominan', '0xff5299D3', DateFormat('EEEE, d/M/yy', 'id_ID').format(DateTime.now()));
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KickCounter(),));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 16.7.w,
                                        height: 16.7.w,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).bottomAppBarColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'images/ic_foot_white.png',
                                            height: 7.8.w,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.2.w,),
                                      SizedBox(
                                        width: 23.3.w,
                                        child: Text(
                                          'Tendangan Dominan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9.0.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 1.0.w,),
                                InkWell(
                                  onTap: () {
                                    dbKick.insert(DateFormat('d MMM yyyy HH:mm:ss', 'id_ID')
                                        .format(DateTime.now()), 'Gerakan Menggeliat', '0xffC09AC7', DateFormat('EEEE, d/M/yy', 'id_ID').format(DateTime.now()));
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KickCounter(),));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 16.7.w,
                                        height: 16.7.w,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'images/ic_move.png',
                                            height: 7.8.w,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.2.w,),
                                      SizedBox(
                                        width: 23.3.w,
                                        child: Text(
                                          'Gerakan Menggeliat',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9.0.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.4.w,),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    dbKick.insert(DateFormat('d MMM yyyy HH:mm:ss', 'id_ID')
                                        .format(DateTime.now()), 'Gerakan Kecil Kaki & Tangan', '0xffFCB800', DateFormat('EEEE, d/M/yy', 'id_ID').format(DateTime.now()));
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KickCounter(),));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 16.7.w,
                                        height: 16.7.w,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).indicatorColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'images/ic_foot_hand.png',
                                            height: 6.7.w,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.2.w,),
                                      SizedBox(
                                        width: 23.3.w,
                                        child: Text(
                                          'Gerakan Kecil Kaki & Tangan',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9.0.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 1.0.w,),
                                InkWell(
                                  onTap: () {
                                    dbKick.insert(DateFormat('d MMM yyyy HH:mm:ss', 'id_ID')
                                        .format(DateTime.now()), 'Hanya Gerakan Lembut', '0xffE4572E', DateFormat('EEEE, d/M/yy', 'id_ID').format(DateTime.now()));
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const KickCounter(),));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 16.7.w,
                                        height: 16.7.w,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).errorColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'images/ic_gentle.png',
                                            width: 7.8.w,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 2.2.w,),
                                      SizedBox(
                                        width: 23.3.w,
                                        child: Text(
                                          'Hanya Gerakan Lembut',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9.0.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 11.1.w,),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 19.0.w,
                          height: 10.9.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(40),
                              topLeft: Radius.circular(40),
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
                                  size: 7.0.w,
                                  color: Colors.white,
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
            ),
          ],
        ),
      ),
    );
  }
}
