import 'dart:async';
import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:empat_bulan/pages/db/contractions_db.dart';

class Contractions extends StatefulWidget {
  const Contractions({Key? key}) : super(key: key);

  @override
  State<Contractions> createState() => _ContractionsState();
}

class _ContractionsState extends State<Contractions> {
  late List dbNotifications;
  List? dbList, dbDay;
  String selectedTab = 'catat';
  var dbContractions = ContractionsDb();
  late int lastDay;
  int selectedIndex = 0;
  String selectedDay = '';

  Future getNotifications() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_notifications.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    if (prefs.getLastContraction != '') {
      lastDay = DateTime.parse(prefs.getLastContraction).day;
      if (DateTime.now().day - lastDay > 0) {
        prefs.setLastContraction('');
        prefs.setTotalDuration(0);
        prefs.setCountDuration(0);
      }
    }

    if (prefs.getTotalInterval > 10) {
      int intervalAvg = prefs.getTotalInterval ~/ prefs.getCountInterval;
      if (intervalAvg < 5) {
        int durationAvg = prefs.getTotalDuration ~/ prefs.getCountDuration;
        if (durationAvg > 0) {
          prefs.setWarning(true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
        return false;
      },
      child: Scaffold(
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
                          'Kontraksi',
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
                                  selectedTab = 'catat';
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                                    border: Border.all(
                                        color: selectedTab == 'catat'
                                            ? Colors.transparent : Theme.of(context).primaryColor
                                    ),
                                    color: selectedTab == 'catat'
                                        ? Theme.of(context).primaryColor : Colors.transparent
                                ),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(4.4.w, 3.9.w, 4.4.w, 3.6.w),
                                  child: Text(
                                    'Catat',
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: selectedTab == 'catat'
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
                          visible: selectedTab == 'catat' ? true : false,
                          child: Column(
                            children: [
                              SizedBox(height: 3.8.h,),
                              Visibility(
                                visible: prefs.getWarning ? true : false,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 32.0.w,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.error,
                                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).shadowColor,
                                            blurRadius: 6.0,
                                            offset: const Offset(0,3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4.4.w, vertical: 5.6.w),
                                        child: Text(
                                          'Kontraksi Bunda sekarang berjarak kurang dari 5 menit. '
                                              'Pertimbangkan untuk pergi ke rumah sakit atau menghubungi dokter/bidan Bunda.',
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            color: Colors.white,
                                            height: 1.16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 3.8.h,),
                                  ],
                                ),
                              ),
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
                                      'Ketuk gambar untuk memulai kontraksi Bunda',
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
                                    alignment: AlignmentDirectional.bottomStart,
                                    children: [
                                      Container(
                                        width: 53.3.w,
                                        height: 53.3.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1.0,
                                            style: BorderStyle.solid,
                                            color: Theme.of(context).colorScheme.background,
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(100)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(3.3.w),
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => const TimeCounter(),
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
                                                  'images/baby.png',
                                                  height: 18.3.w,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            dbContractions.del();
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
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.4.h,),
                              FutureBuilder(
                                future: dbContractions.list(DateFormat('d MMM yyyy HH:mm:ss', 'id_ID')
                                    .format(DateTime.now()).substring(0, 11)),
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
                                    dbList = snapshot.data as List?;
                                  }
                                  return dbList!.isNotEmpty ? Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 3.0.w,),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 40.0.w,
                                              child: Text(
                                                'Mulai',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10.0.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22.4.w,
                                              child: Text(
                                                'Durasi',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10.0.sp,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Interval',
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
                                          itemCount: dbList!.length,
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
                                                          width: 40.0.w,
                                                          child: Text(
                                                            dbList![index]['start'],
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 22.4.w,
                                                          child: Text(
                                                            dbList![index]['duration'],
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          dbList![index]['interval'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.0.sp,
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
                                  ) : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: 5.6.h,),
                                          Text(
                                            "Belum Ada Data Kontraksi",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.0.sp,
                                            ),
                                          ),
                                          SizedBox(height: 4.0.h,),
                                          Image.asset(
                                            'images/no_contractions.png',
                                            width: 40.0.w,
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
                        Visibility(
                          visible: selectedTab == 'riwayat' ? true : false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future: dbContractions.group(),
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
                                    dbDay = snapshot.data as List?;
                                    if (dbDay!.isNotEmpty) {
                                      selectedDay = dbDay![selectedIndex]['contractionDay'].substring(0, 11);
                                    }
                                  }
                                  return dbDay!.isNotEmpty ? Column(
                                    children: [
                                      SizedBox(height: 2.0.h,),
                                      SizedBox(
                                        height: 11.7.w,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: dbDay!.length,
                                          physics: const BouncingScrollPhysics(),
                                          padding: const EdgeInsets.only(top: 0),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = index;
                                                  selectedDay = dbDay![index]['contractionDay'];
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                                                        border: Border.all(
                                                            color: selectedIndex == index
                                                                ? Colors.transparent : Theme.of(context).colorScheme.background
                                                        ),
                                                        color: selectedIndex == index
                                                            ? Theme.of(context).colorScheme.background : Colors.transparent
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.fromLTRB(4.4.w, 3.9.w, 4.4.w, 3.6.w),
                                                      child: Text(
                                                        dbDay![index]['contractionDay'].toString().substring(0, 6),
                                                        style: TextStyle(
                                                          fontSize: 12.0.sp,
                                                          color: selectedIndex == index
                                                              ? Colors.white : Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 2.2.w,),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ) : Container();
                                },
                              ),
                              FutureBuilder(
                                future: dbContractions.list(selectedDay),
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
                                    dbList = snapshot.data as List?;
                                  }
                                  return dbList!.isNotEmpty ? Column(
                                    children: [
                                      SizedBox(height: 6.7.h,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 3.0.w,),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 40.0.w,
                                              child: Text(
                                                'Mulai',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10.0.sp,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 22.4.w,
                                              child: Text(
                                                'Durasi',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10.0.sp,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Interval',
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
                                          itemCount: dbList!.length,
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
                                                          width: 40.0.w,
                                                          child: Text(
                                                            dbList![index]['start'],
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 22.4.w,
                                                          child: Text(
                                                            dbList![index]['duration'],
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0.sp,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          dbList![index]['interval'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12.0.sp,
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
                                  ) : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: 9.2.h,),
                                          Text(
                                            "Belum Ada Data Kontraksi",
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
                      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true),
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
                                          color: Theme.of(context).colorScheme.error,
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
        ),
      ),
    );
  }
}

class TimeCounter extends StatefulWidget {
  const TimeCounter({Key? key}) : super(key: key);

  @override
  State<TimeCounter> createState() => _TimeCounterState();
}

class _TimeCounterState extends State<TimeCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  final f = NumberFormat('00');
  var dbContractions = ContractionsDb();
  bool stop = false;
  late Timer timeCount;
  late DateTime lastContraction;
  late String interval, start;
  late int hr, mn, sc;

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

    if (prefs.getLastContraction == '') {
      interval = '-';
      prefs.setTotalInterval(0);
      prefs.setCountInterval(0);
    } else {
      lastContraction = DateTime.parse(prefs.getLastContraction);
      if (DateTime.now().difference(lastContraction).inSeconds < 60) {
        sc = DateTime.now().difference(lastContraction).inSeconds;
      } else {
        sc = DateTime.now().difference(lastContraction).inSeconds % 60;
      }
      if (DateTime.now().difference(lastContraction).inMinutes < 60) {
        mn = DateTime.now().difference(lastContraction).inMinutes;
      } else {
        mn = DateTime.now().difference(lastContraction).inMinutes % 60;
      }
      hr = DateTime.now().difference(lastContraction).inHours;
      interval = '${f.format(hr)}:${f.format(mn)}:${f.format(sc)}';
      prefs.setTotalInterval(prefs.getTotalInterval + mn);
      prefs.setCountInterval(prefs.getCountInterval + 1);
    }
    start = DateFormat('d MMM yyyy HH:mm:ss', 'id_ID').format(DateTime.now());
    prefs.setLastContraction(DateTime.now().toIso8601String());
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timeCount = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (stop) {
          timer.cancel();
        } else {
          seconds += 1;
          if (seconds > 59) {
            minutes += 1;
            seconds = 0;
            if (minutes > 59) {
              hours += 1;
              minutes = 0;
            }
          }
        }
      },
      );
    },
    );
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
                        Text(
                          'Durasi Kontraksi',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 13.0.sp,
                          ),
                        ),
                        SizedBox(height: 14.4.w,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${f.format(hours)}:${f.format(minutes)}',
                              style: TextStyle(
                                fontSize: 32.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              ':${f.format(seconds)}',
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.6.w,),
                        Text(
                          'Rahim Bunda aktif',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.0.sp,
                          ),
                        ),
                        SizedBox(height: 2.2.w,),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 10.0.sp,
                              fontFamily: 'Josefin Sans',
                              height: 1.6,
                              color: Colors.black,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Rahim Bunda sudah mulai berkontraksi sebagai awal proses persalinan. ',
                              ),
                              TextSpan(
                                text: 'Tekan stop ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: 'saat merasa kontraksi berhenti.',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.8.w,),
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
                              stop = true;
                              prefs.setTotalDuration(prefs.getTotalDuration + minutes);
                              prefs.setCountDuration(prefs.getCountDuration + 1);
                              dbContractions.insert(
                                  start, '${f.format(hours)}:${f.format(minutes)}:${f.format(seconds)}', interval);
                              Navigator.pushReplacement(context, PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const Contractions(),
                                  transitionDuration: Duration.zero));
                            },
                            child: Container(
                              width: 48.0.w,
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
                                  'Stop',
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
