import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';

class UpdPregnancy extends StatefulWidget {
  const UpdPregnancy({Key? key}) : super(key: key);

  @override
  State<UpdPregnancy> createState() => _UpdPregnancyState();
}

class _UpdPregnancyState extends State<UpdPregnancy> {
  final name = TextEditingController();
  final hplText = TextEditingController();
  final hphtText = TextEditingController();
  final hplResult = TextEditingController();
  late List dbProfile;
  bool firstLoad = true;
  late String sextype, basecount, hplStr, hphtStr;
  late DateTime hpl, hpht;

  Future getProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updPregnancy() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_pregnancy.php?phone=${prefs.getPhone}'
        '&babys_name=${name.text}&sex=$sextype&hpl=$hplStr&hpht=$hphtStr&basecount=$basecount');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                if (firstLoad) {
                  name.text = dbProfile[0]['babys_name'];
                  sextype = dbProfile[0]['sex'];
                  basecount = dbProfile[0]['basecount'];

                  if (basecount != '') {
                    hpl = DateTime(
                        int.parse(dbProfile[0]['hpl'].substring(0, 4)),
                        int.parse(dbProfile[0]['hpl'].substring(5, 7)),
                        int.parse(dbProfile[0]['hpl'].substring(8, 10))
                    );

                    if (basecount == 'hpl') {
                      hpht = hpl.subtract(const Duration(days: 280));
                      hplText.text = DateFormat('d MMMM yyyy', 'id_ID').format(hpl);
                      hplResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl);
                    } else {
                      hpht = DateTime(
                          int.parse(dbProfile[0]['hpht'].substring(0, 4)),
                          int.parse(dbProfile[0]['hpht'].substring(5, 7)),
                          int.parse(dbProfile[0]['hpht'].substring(8, 10))
                      );

                      hphtText.text = DateFormat('d MMMM yyyy', 'id_ID').format(hpht);
                      hplResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl);
                    }

                    hplStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpl);
                    hphtStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpht);
                  }

                  firstLoad = false;
                }
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
                            'Profil Kehamilan',
                            style: TextStyle(
                              fontSize: 24.0.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5.3.h,),
                          Text(
                            'Nama Calon Bayi (Insya Allah)',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                          TextField(
                            controller: name,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                          SizedBox(height: 3.8.h,),
                          Text(
                            'Jenis Kelamin (Insya Allah)',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                          SizedBox(height: 1.0.h,),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).shadowColor,
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(8.8.w, 4.4.w, 8.8.w, 5.2.w),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/ic_gender.png',
                                                width: 4.2.w,
                                              ),
                                              SizedBox(width: 6.0.w,),
                                              Text(
                                                'Jenis Kelamin',
                                                style: TextStyle(
                                                  fontSize: 17.0.sp,
                                                  color: Theme.of(context).colorScheme.background,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 3.0.h,),
                                      Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Theme.of(context).dividerColor,
                                                ),
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                'Laki-laki',
                                                style: TextStyle(
                                                  fontSize: 13.0.sp,
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                              onTap: () {
                                                setState(() {
                                                  sextype = 'Laki-laki';
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Theme.of(context).dividerColor,
                                                ),
                                                bottom: BorderSide(
                                                  color: Theme.of(context).dividerColor,
                                                ),
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                'Perempuan',
                                                style: TextStyle(
                                                  fontSize: 13.0.sp,
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                              onTap: () {
                                                setState(() {
                                                  sextype = 'Perempuan';
                                                  Navigator.pop(context);
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.4.h,)
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 4.8.h,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      sextype,
                                      style: TextStyle(
                                        fontSize: 15.0.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.2.w,
                                    child: Image.asset(
                                      'images/ic_down.png',
                                    ),
                                  ),
                                  SizedBox(width: 2.2.w,)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 3.8.h,),
                          Text(
                            'Sudah tahu kapan HPL Bunda?',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                          TextField(
                            controller: hplText,
                            readOnly: true,
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
                                minTime: DateTime.now(),
                                maxTime: DateTime.now().add(const Duration(days: 280)),
                                onConfirm: (date) {
                                  setState(() {
                                    hpl = date;
                                    hpht = date.subtract(const Duration(days: 280));
                                    hplStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpl);
                                    hphtStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpht);
                                    basecount = 'hpl';
                                    hplText.text = DateFormat('d MMMM yyyy', 'id_ID').format(hpl);
                                    hphtText.text = '';
                                    hplResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl);
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
                              hintText: 'Masukkan HPL menurut dokter',
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15.0.sp,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                          SizedBox(height: 1.0.h,),
                          Row(
                            children: [
                              SizedBox(
                                width: 4.0.w,
                                height: 4.0.w,
                                child: Image.asset(
                                  'images/ic_info.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 1.0.w,),
                              Column(
                                children: [
                                  SizedBox(height: 0.5.h,),
                                  Text(
                                    'HPL : Hari Perkiraan Lahir',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 3.0.h,),
                          Text(
                            'atau',
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                          SizedBox(height: 3.0.h,),
                          Text(
                            'Hitung HPL berdasarkan HPHT',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                          TextField(
                            controller: hphtText,
                            readOnly: true,
                            onTap: () {
                              DatePicker.showDatePicker(
                                context,
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
                                minTime: DateTime.now().subtract(const Duration(days: 280)),
                                maxTime: DateTime.now(),
                                onConfirm: (date) {
                                  setState(() {
                                    hpht = date;
                                    hpl = date.add(const Duration(days: 280));
                                    hplStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpl);
                                    hphtStr = DateFormat('yyyy-MM-dd', 'id_ID').format(hpht);
                                    basecount = 'hpht';
                                    hplText.text = '';
                                    hphtText.text = DateFormat('d MMMM yyyy', 'id_ID').format(hpht);
                                    hplResult.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(hpl);
                                  });
                                },
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
                              hintText: 'Masukkan HPHT Bunda',
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 15.0.sp,
                              ),
                            ),
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontSize: 15.0.sp,
                            ),
                          ),
                          SizedBox(height: 1.0.h,),
                          Row(
                            children: [
                              SizedBox(
                                width: 4.0.w,
                                height: 4.0.w,
                                child: Image.asset(
                                  'images/ic_info.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 1.0.w,),
                              Column(
                                children: [
                                  SizedBox(height: 0.5.h,),
                                  Text(
                                    'HPHT : Hari Pertama Haid Terakhir',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    (hplText.text == '') && (hphtText.text == '') ? Container() : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3.0.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                          child: Text(
                            'Insya Allah hari perkiraan lahir dede bayi Bunda adalah',
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: 3.0.h,),
                        Container(
                          height: 10.0.h,
                          color: Theme.of(context).colorScheme.background,
                          padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                enabled: false,
                                controller: hplResult,
                                style: TextStyle(
                                    fontSize: 15.0.sp,
                                    color: Colors.white
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0.h,),
                  ],
                ),
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
                      updPregnancy();
                      Navigator.pop(context);
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
    );
  }
}
