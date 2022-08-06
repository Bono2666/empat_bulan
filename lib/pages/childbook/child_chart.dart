// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class ChildChart extends StatefulWidget {
  const ChildChart({Key key}) : super(key: key);

  @override
  State<ChildChart> createState() => _ChildChartState();
}

class _ChildChartState extends State<ChildChart> {
  List dbNotifications, dbChildBook, dbProfile, dbZScore, dbZScoreAge;
  bool firstLoad = true;
  DateTime growthDate;
  int ageMonth, ageYear;
  double weightUnder1, weightUnder6, weightUnder12;
  String status, chartType, sex;
  TooltipBehavior tooltipBehavior;

  Future getNotifications() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_notifications.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getAllChildBook() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_all_childbook.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getZScore() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_zscore.php?chart_type=$chartType&sex=$sex');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getZScoreAge() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_zscore_age.php?chart_type=$chartType&sex=$sex&age_mo=$ageMonth');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    tooltipBehavior = TooltipBehavior(
      decimalPlaces: 1,
      enable: true,
      textStyle: const TextStyle(
        fontFamily: 'Josefin Sans',
      ),
    );
    super.initState();
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
            return FutureBuilder(
              future: getAllChildBook(),
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
                  dbChildBook = snapshot.data as List;

                  if (firstLoad) {
                    ageMonth = int.parse(dbChildBook[dbChildBook.length - 1]['age_month']);

                    if (ageMonth <= 6) {
                      chartType = 'under6_mo';
                    }

                    firstLoad = false;
                  }
                }
                return FutureBuilder(
                  future: getProfile(),
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
                      dbProfile = snapshot.data as List;
                      // sex = dbProfile[0]['childs_sex'];
                      sex = 'Laki-laki';
                    }
                    return FutureBuilder(
                      future: getZScore(),
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
                          dbZScore = snapshot.data as List;
                        }
                        return FutureBuilder(
                          future: getZScoreAge(),
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
                              dbZScoreAge = snapshot.data as List;

                              if (double.parse(dbChildBook[dbChildBook.length - 1]['weight']) < double.parse(dbZScoreAge[0]['weight_min2'])) {
                                status = "Gizi Kurang";
                              } else if (double.parse(dbChildBook[dbChildBook.length - 1]['weight']) <= double.parse(dbZScoreAge[0]['weight_plus2'])) {
                                status = "Normal";
                              } else {
                                status = "Obesitas";
                              }
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
                                          'Pertumbuhan',
                                          style: TextStyle(
                                            fontSize: 24.0.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 2.5.h,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'images/ic_weight.png',
                                              height: 3.3.w,
                                            ),
                                            SizedBox(width: 1.4.w,),
                                            Padding(
                                              padding: EdgeInsets.only(top: 0.8.w),
                                              child: Text(
                                                'Berat badan sesuai usia',
                                                style: TextStyle(
                                                  fontSize: 10.0.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
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
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 6.6.w,
                                                          height: 6.6.w,
                                                          decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.all(
                                                                Radius.circular(30),
                                                              ),
                                                              color: Theme.of(context).backgroundColor
                                                          ),
                                                          child: Center(
                                                            child: SizedBox(
                                                              width: 3.3.w,
                                                              height: 3.3.w,
                                                              child: FittedBox(
                                                                child: Image.asset(
                                                                    'images/ic_child_book.png'
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 1.6.w,),
                                                        Text(
                                                          '${dbChildBook[dbChildBook.length - 1]['weight']} kg',
                                                          style: TextStyle(
                                                            fontSize: 10.0.sp,
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(width: 10.0.w,),
                                                        Container(
                                                          width: 6.6.w,
                                                          height: 6.6.w,
                                                          decoration: BoxDecoration(
                                                              borderRadius: const BorderRadius.all(
                                                                Radius.circular(30),
                                                              ),
                                                              color: Theme.of(context).backgroundColor
                                                          ),
                                                          child: Center(
                                                            child: SizedBox(
                                                              width: 3.3.w,
                                                              child: FittedBox(
                                                                child: Image.asset(
                                                                    'images/ic_ruler_white.png'
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 1.6.w,),
                                                        Text(
                                                          '${dbChildBook[dbChildBook.length - 1]['height']} cm',
                                                          style: TextStyle(
                                                            fontSize: 10.0.sp,
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 3.3.w,),
                                                    RichText(
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 13.0.sp,
                                                          fontFamily: 'Josefin Sans',
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                        children: [
                                                          const TextSpan(
                                                            text: 'Berat Badan ',
                                                            style: TextStyle(
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: status,
                                                            style: TextStyle(
                                                              color: Theme.of(context).backgroundColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 1.2.w,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 2.35.w),
                                                child: Html(
                                                  data: 'Berat badan anak sesuai umur. Pantau ulang berat badan secara berkala.',
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
                                        SizedBox(height: 3.8.h,),
                                        Container(
                                          width: 86.7.w,
                                          constraints: BoxConstraints(
                                            minHeight: 95.8.w,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                                            border: Border.all(
                                              color: Theme.of(context).primaryColor,
                                              width: 1,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(3.2.w, 6.7.w, 5.6.w, 8.8.w),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Grafik Pertumbuhan',
                                                  style: TextStyle(
                                                    fontSize: 17.0.sp,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 1.1.w,),
                                                Text(
                                                  'Grafik WHO digunakan untuk anak\nusia 0 - 5 tahun',
                                                  style: TextStyle(
                                                    fontSize: 10.0.sp,
                                                    color: Colors.black,
                                                    height: 1.2,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(height: 4.4.w,),
                                                SfCartesianChart(
                                                  series: <ChartSeries> [
                                                    SplineAreaSeries (
                                                      dataSource: dbZScore,
                                                      xValueMapper: (data, index) => dbZScore[index]['age_mo'],
                                                      yValueMapper: (data, index) => num.parse(dbZScore[index]['weight_min3']),
                                                      color: Colors.transparent,
                                                      borderColor: Theme.of(context).backgroundColor,
                                                      borderWidth: 1,
                                                      enableTooltip: false,
                                                    ),
                                                    SplineAreaSeries (
                                                      dataSource: dbZScore,
                                                      xValueMapper: (data, index) => dbZScore[index]['age_mo'],
                                                      yValueMapper: (data, index) => num.parse(dbZScore[index]['weight_min2']),
                                                      color: Colors.transparent,
                                                      borderWidth: 1,
                                                      borderColor: Theme.of(context).errorColor,
                                                      enableTooltip: false,
                                                    ),
                                                    SplineAreaSeries (
                                                      dataSource: dbZScore,
                                                      xValueMapper: (data, index) => dbZScore[index]['age_mo'],
                                                      yValueMapper: (data, index) => num.parse(dbZScore[index]['weight0']),
                                                      color: Colors.transparent,
                                                      borderWidth: 1,
                                                      borderColor: Theme.of(context).focusColor,
                                                      enableTooltip: false,
                                                    ),
                                                    SplineAreaSeries (
                                                      dataSource: dbZScore,
                                                      xValueMapper: (data, index) => dbZScore[index]['age_mo'],
                                                      yValueMapper: (data, index) => num.parse(dbZScore[index]['weight_plus2']),
                                                      color: Colors.transparent,
                                                      borderWidth: 1,
                                                      borderColor: Theme.of(context).errorColor,
                                                      enableTooltip: false,
                                                    ),
                                                    SplineAreaSeries (
                                                      dataSource: dbZScore,
                                                      xValueMapper: (data, index) => dbZScore[index]['age_mo'],
                                                      yValueMapper: (data, index) => num.parse(dbZScore[index]['weight_plus3']),
                                                      color: Theme.of(context).backgroundColor,
                                                      gradient: const LinearGradient(
                                                        begin: Alignment.topCenter,
                                                        end: Alignment.bottomCenter,
                                                        colors: [
                                                          Color(0x80C09AC7),
                                                          Color(0x00ffffff),
                                                        ],
                                                      ),
                                                      borderColor: Theme.of(context).backgroundColor,
                                                      borderWidth: 1,
                                                      enableTooltip: false,
                                                    ),
                                                    SplineAreaSeries (
                                                      dataSource: dbChildBook,
                                                      xValueMapper: (data, index) => dbChildBook[index]['age_month'],
                                                      yValueMapper: (data, index) => num.parse(dbChildBook[index]['weight']),
                                                      color: Colors.transparent,
                                                      markerSettings: MarkerSettings(
                                                        color: Theme.of(context).backgroundColor,
                                                        isVisible: true,
                                                        height: 2.2.w,
                                                        width: 2.2.w,
                                                        borderWidth: 0,
                                                      ),
                                                      borderColor: Theme.of(context).backgroundColor,
                                                      borderWidth: 1,
                                                      enableTooltip: true,
                                                      name: 'Berat (kg)',
                                                    ),
                                                  ],
                                                  primaryXAxis: CategoryAxis(
                                                    title: AxisTitle(
                                                      text: 'bulan',
                                                      alignment: ChartAlignment.far,
                                                      textStyle: TextStyle(
                                                        fontSize: 7.0.sp,
                                                        color: Colors.black,
                                                        fontFamily: 'Josefin Sans',
                                                      ),
                                                    ),
                                                    labelStyle: TextStyle(
                                                      fontFamily: 'Josefin Sans',
                                                      fontSize: 10.0.sp,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  primaryYAxis: NumericAxis(
                                                    labelStyle: const TextStyle(
                                                      fontFamily: 'Josefin Sans',
                                                      color: Colors.black,
                                                    ),
                                                    title: AxisTitle(
                                                      text: 'kg',
                                                      textStyle: TextStyle(
                                                        fontFamily: 'Josefin Sans',
                                                        color: Colors.black,
                                                        fontSize: 7.0.sp,
                                                      ),
                                                      alignment: ChartAlignment.far,
                                                    ),
                                                  ),
                                                  tooltipBehavior: tooltipBehavior,
                                                ),
                                                SizedBox(height: 2.2.w,),
                                                Row(
                                                  children: [
                                                    SizedBox(width: 8.0.w,),
                                                    Container(
                                                      width: 2.2.w,
                                                      height: 2.2.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                                                        color: Theme.of(context).backgroundColor,
                                                      ),
                                                    ),
                                                    SizedBox(width: 1.2.w,),
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 0.8.w),
                                                      child: Text(
                                                        'Data Pertumbuhan Si Kecil',
                                                        style: TextStyle(
                                                          fontSize: 7.0.sp,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 3.8.h,),
                                        Text(
                                          'Titik data pertumbuhan yang tercatat di EmpatBulan '
                                              'akan otomatis diplot ke kurva pertumbuhan yang tersedia. '
                                              'Secara umum, pertumbuhan yang baik ditandai dengan garis '
                                              'data anak yang sejajar dengan garis hijau (z-score 0) dan '
                                              'berada di antara 2 garis merah (z-score 2 dan -2)',
                                          style: TextStyle(
                                            fontSize: 10.0.sp,
                                            color: Colors.black,
                                            height: 1.2,
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
                                              Navigator.pushReplacementNamed(context, '/addChildBook');
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
                                                      'images/ic_plus.png',
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