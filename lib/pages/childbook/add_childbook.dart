import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:empat_bulan/main.dart';
import 'package:http/http.dart' as http;

class AddChildBook extends StatefulWidget {
  const AddChildBook({Key? key}) : super(key: key);

  @override
  State<AddChildBook> createState() => _AddChildBookState();
}

class _AddChildBookState extends State<AddChildBook> {
  final growthDate = TextEditingController();
  late String formattedDate;
  late DateTime pickDate;
  double weight = 3.0;
  double height = 50;
  late List dbChildBook, dbProfile, dbChildMonth;
  bool firstLoad = true;
  late int ageMonth;
  late DateTime birthDate;
  late Duration duration;

  Future getAllChildBook() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_all_childbook.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getChildMonth() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_child_month.php?phone=${prefs.getPhone}&age_month=$ageMonth');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future addChildBook() async {
    var url = 'https://app.empatbulan.com/api/add_childbook.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'base' : '0',
      'growth_date' : formattedDate,
      'age_month' : ageMonth.toString(),
      'weight' : weight.toStringAsFixed(1),
      'height' : height.toString(),
    });
  }

  Future updChildBook() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_child_growth.php?phone=${prefs.getPhone}'
        '&age_month=$ageMonth&weight=${weight.toStringAsFixed(1)}&height=$height');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/childChart');
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            FutureBuilder(
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
                return FutureBuilder(
                  future: getAllChildBook(),
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

                      if (firstLoad) {
                        birthDate = DateTime(
                            int.parse(dbProfile[0]['birth_date'].substring(0, 4)),
                            int.parse(dbProfile[0]['birth_date'].substring(5, 7)),
                            int.parse(dbProfile[0]['birth_date'].substring(8, 10))
                        );
                        duration = DateTime.now().difference(birthDate);
                        ageMonth = duration.inDays ~/ 30;
                        formattedDate = DateFormat('yyyy-MM-dd', 'id_ID').format(DateTime.now());
                        growthDate.text = DateFormat('d MMM yyyy', 'id_ID').format(DateTime.now());
                        weight = double.parse(dbChildBook[dbChildBook.length - 1]['weight']);
                        height = double.parse(dbChildBook[dbChildBook.length - 1]['height']);
                        firstLoad = false;
                      }
                    }
                    return FutureBuilder(
                      future: getChildMonth(),
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
                          dbChildMonth = snapshot.data as List;
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
                                      'Data Pertumbuhan',
                                      style: TextStyle(
                                        fontSize: 24.0.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(height: 5.3.h,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 0.8.w),
                                          child: Text(
                                            'Tanggal Pertumbuhan',
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 1.1.w,),
                                        Container(
                                          width: 1.7.w,
                                          height: 1.7.w,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.background,
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextField(
                                      controller: growthDate,
                                      readOnly: true,
                                      onTap: () {
                                        DatePicker.showDatePicker(
                                          context,
                                          minTime: birthDate.add(const Duration(days: 30)),
                                          maxTime: DateTime.now(),
                                          onConfirm: (date) {
                                            setState(() {
                                              pickDate = date;
                                              duration = pickDate.difference(birthDate);
                                              ageMonth = duration.inDays ~/ 30;
                                              formattedDate = DateFormat('yyyy-MM-dd', 'id_ID').format(pickDate);
                                              growthDate.text = DateFormat('d MMM yyyy', 'id_ID').format(pickDate);
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
                                      ),
                                      style: TextStyle(
                                        fontSize: 15.0.sp,
                                      ),
                                    ),
                                    SizedBox(height: 3.8.h,),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 0.8.w),
                                          child: Text(
                                            'Berat Badan (kg)',
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 1.1.w,),
                                        Container(
                                          width: 1.7.w,
                                          height: 1.7.w,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.background,
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          ),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        InkWell(
                                          onTap: () {
                                            if (weight > 0.1) {
                                              setState(() {
                                                weight -= 0.1;
                                              });
                                            }
                                          },
                                          child: Image.asset(
                                            weight.toStringAsFixed(1) == '0.1'
                                                ? 'images/ic_decrement_inactive.png'
                                                : 'images/ic_decrement.png',
                                            width: 9.4.w,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.9.w,
                                          child: Text(
                                            weight.toStringAsFixed(1),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              weight += 0.1;
                                            });
                                          },
                                          child: Image.asset(
                                            'images/ic_increment.png',
                                            width: 9.4.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 3.8.h,),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 0.8.w),
                                          child: Text(
                                            'Tinggi Badan (cm)',
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 1.1.w,),
                                        Container(
                                          width: 1.7.w,
                                          height: 1.7.w,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.background,
                                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                                          ),
                                        ),
                                        const Expanded(child: SizedBox(),),
                                        InkWell(
                                          onTap: () {
                                            if (height > 1) {
                                              setState(() {
                                                height -= 1;
                                              });
                                            }
                                          },
                                          child: Image.asset(
                                            height == 1
                                                ? 'images/ic_decrement_inactive.png'
                                                : 'images/ic_decrement.png',
                                            width: 9.4.w,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16.9.w,
                                          child: Text(
                                            height.toStringAsFixed(0),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              height += 1;
                                            });
                                          },
                                          child: Image.asset(
                                            'images/ic_increment.png',
                                            width: 9.4.w,
                                          ),
                                        ),
                                      ],
                                    ),
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
                    Navigator.pushReplacementNamed(context, '/childChart');
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
                          if (dbChildMonth.isNotEmpty) {
                            updChildBook();
                          } else {
                            addChildBook();
                          }
                          await Navigator.pushReplacementNamed(context, '/childChart');
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
                              'Simpan',
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
