import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:empat_bulan/main.dart';
import 'package:http/http.dart' as http;

class TimeSchedule extends StatefulWidget {
  const TimeSchedule({Key? key}) : super(key: key);

  @override
  State<TimeSchedule> createState() => _TimeScheduleState();
}

class _TimeScheduleState extends State<TimeSchedule> {
  final _date = TextEditingController();
  final _time = TextEditingController();
  String _scheduleDate = '';
  String _scheduleTime = '';
  late List dbProfile, dbSelectedPrivate;

  Future getSelectedPrivate() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_selected_private.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (prefs.getBackRoute == '/cart') {
          Navigator.pop(context);
        } else {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            backgroundColor: Colors.white,
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.8.w,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 11.1.w,),
                        Text(
                          'Batalkan pemesanan?',
                          style: TextStyle(
                            fontSize: 23.0.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 3.9.w,),
                        Text(
                          'Jika Bunda keluar dari proses pemesanan, pesanan Bunda akan dibatalkan.',
                          style: TextStyle(
                            fontSize: 13.0.sp,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.9.w,),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/homeServices', (route) => true);
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: [
                            Container(
                              width: 45.0.w,
                              height: 20.8.w,
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                            SizedBox(
                              width: 34.4.w,
                              child: Center(
                                child: Text(
                                  'Ya',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 27.8.w),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 40.0.w,
                            height: 20.8.w,
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .colorScheme.background,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Tidak',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
              future: getSelectedPrivate(),
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
                  dbSelectedPrivate = snapshot.data as List;
                }
                return FutureBuilder(
                  future: getProfile(),
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
                      dbProfile = snapshot.data as List;
                    }
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 7.0.w,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 19.0.h,),
                                Text(
                                  'Jadwal Pertemuan',
                                  style: TextStyle(
                                    fontSize: 24.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 0.2.h,),
                                SizedBox(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: dbSelectedPrivate.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.all(0),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          SizedBox(height: 4.4.h,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(width: 2.2.w,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    dbSelectedPrivate[index]['title'],
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 13.0.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.7.w,),
                                                  Text(
                                                    dbSelectedPrivate[index]['instructur'],
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                      fontSize: 8.0.sp,
                                                      color: Theme.of(context).colorScheme.background,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5.6.w,),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: 24.4.w,
                                                        height: 5.8.w,
                                                        decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                          color: Theme.of(context).colorScheme.background,
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            dbSelectedPrivate[index]['type'],
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 8.0.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 12.0.w,),
                                                      Text(
                                                        NumberFormat.currency(
                                                          locale: 'id',
                                                          symbol: 'Rp ',
                                                          decimalDigits: 0,
                                                        ).format(int.parse(dbSelectedPrivate[index]['total_price'])),
                                                        style: TextStyle(
                                                          fontSize: 9.0.sp,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 3.4.w,),
                                              Container(
                                                width: 28.5.w,
                                                height: 29.0.w,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Theme.of(context).shadowColor,
                                                        blurRadius: 6.0,
                                                        offset: const Offset(0, 3),
                                                      ),
                                                    ]
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: const BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                  child: SizedBox(
                                                    width: 28.5.w,
                                                    height: 29.0.w,
                                                    child: Image.network(
                                                      dbSelectedPrivate[index]['image'],
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context, child, loadingProgress) {
                                                        if (loadingProgress == null) return child;
                                                        return SizedBox(
                                                          height: 29.0.w,
                                                          child: const Center(
                                                            child: SpinKitDoubleBounce(
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2.2.h,),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                  color: Theme.of(context).dividerColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 4.1.h,),
                                Text(
                                  'Tanggal Pertemuan',
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                TextField(
                                  controller: _date,
                                  readOnly: true,
                                  onTap: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      minTime: DateTime.now().add(const Duration(hours: 24)),
                                      onConfirm: (date) {
                                        setState(() {
                                          _date.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
                                          _scheduleDate = DateFormat('yyyy-MM-dd').format(date);
                                        });
                                      },
                                      theme: DatePickerTheme(
                                        itemStyle: TextStyle(
                                          fontFamily: 'Josefin Sans',
                                          fontSize: 15.0.sp,
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                        doneStyle: TextStyle(
                                          fontFamily: 'Josefin Sans',
                                          color: Theme.of(context).colorScheme.background,
                                        ),
                                        cancelStyle: const TextStyle(
                                          fontFamily: 'Josefin Sans',
                                          color: Colors.black,
                                        ),
                                      ),
                                      locale: LocaleType.id,
                                    );
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: Container(
                                      margin: EdgeInsets.fromLTRB(4.4.w, 2.2.w, 2.2.w, 4.4.w),
                                      height: 3.0.h,
                                      child: Image.asset(
                                        'images/ic_date.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    hintText: 'Pilih tanggal',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 15.0.sp,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                  ),
                                ),
                                SizedBox(height: 3.0.h,),
                                Text(
                                  'Jam Pertemuan (WIB)',
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                TextField(
                                  controller: _time,
                                  readOnly: true,
                                  onTap: () {
                                    DatePicker.showTimePicker(
                                      context,
                                      onConfirm: (time) {
                                        setState(() {
                                          _time.text = DateFormat('HH.mm', 'id_ID').format(time);
                                          _scheduleTime = DateFormat('HH:mm', 'id_ID').format(time);
                                        });
                                      },
                                      showSecondsColumn: false,
                                      locale: LocaleType.id,
                                      theme: DatePickerTheme(
                                        itemStyle: TextStyle(
                                          fontSize: 15.0.sp,
                                          color: Theme.of(context).colorScheme.background,
                                          fontFamily: 'Josefin Sans',
                                        ),
                                        cancelStyle: const TextStyle(
                                          fontFamily: 'Josefin Sans',
                                          color: Colors.black,
                                        ),
                                        doneStyle: TextStyle(
                                          color: Theme.of(context).colorScheme.background,
                                          fontFamily: 'Josefin Sans',
                                        ),
                                      ),
                                    );
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: Container(
                                      margin: EdgeInsets.fromLTRB(4.4.w, 2.2.w, 2.2.w, 4.4.w),
                                      height: 3.0.h,
                                      child: Image.asset(
                                        'images/ic_schedule_color.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    hintText: 'Pilih waktu',
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      fontSize: 15.0.sp,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                  ),
                                ),
                                SizedBox(height: 3.0.h,),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0.h,),
                        ],
                      ),
                    );
                  },
                );
              },
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (prefs.getBackRoute == '/cart') {
                      Navigator.pop(context);
                    } else {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        backgroundColor: Colors.white,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 7.8.w,),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 11.1.w,),
                                    Text(
                                      'Batalkan pemesanan?',
                                      style: TextStyle(
                                        fontSize: 23.0.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 3.9.w,),
                                    Text(
                                      'Jika Bunda keluar dari proses pemesanan, pesanan Bunda akan dibatalkan.',
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 8.9.w,),
                                  ],
                                ),
                              ),
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(context, '/homeServices', (route) => true);
                                    },
                                    child: Stack(
                                      alignment: AlignmentDirectional.centerEnd,
                                      children: [
                                        Container(
                                          width: 45.0.w,
                                          height: 20.8.w,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(
                                          width: 34.4.w,
                                          child: Center(
                                            child: Text(
                                              'Ya',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13.0.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 27.8.w),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 40.0.w,
                                        height: 20.8.w,
                                        decoration: BoxDecoration(
                                          color: Theme
                                              .of(context)
                                              .colorScheme.background,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(40),
                                            bottomRight: Radius.circular(40),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Tidak',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.0.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }
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
                            Icons.arrow_back_ios_new_rounded,
                            size: 5.2.w,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 6.4.h,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.white, Colors.white.withOpacity(0.0),
                                  ],
                                )
                            ),
                          ),
                          Container(
                            height: 5.0.h,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () async {
                          if (_scheduleDate != '' && _scheduleTime != '') {
                            Duration difference = DateTime.parse('$_scheduleDate $_scheduleTime').difference(DateTime.now());
                            if (difference.inHours + 1 > 24) {
                              prefs.setPrivateDate(_scheduleDate);
                              prefs.setPrivateTime(_time.text);
                              if (dbProfile[0]['email'] == '') {
                                Navigator.pushNamed(context, '/checkout');
                              } else {
                                prefs.setBackRoute('/cart');
                                Navigator.pushReplacementNamed(
                                    context, '/confirm');
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Waktu pertemuan paling cepat 24 jam ke depan.',
                                    style: TextStyle(
                                      fontFamily: 'Josefin Sans',
                                    ),
                                  ),
                                  backgroundColor: Theme
                                      .of(context)
                                      .colorScheme
                                      .background,
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'Bunda belum melengkapi Jadwal Pertemuan.',
                                  style: TextStyle(
                                    fontFamily: 'Josefin Sans',
                                  ),
                                ),
                                backgroundColor: Theme.of(context).colorScheme.background,
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: 74.0.w,
                          height: 12.0.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Lanjutkan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 13.0.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
