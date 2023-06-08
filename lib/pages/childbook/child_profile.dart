import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as date_picker;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:empat_bulan/main.dart';
import 'package:http/http.dart' as http;

class ChildProfile extends StatefulWidget {
  const ChildProfile({Key? key}) : super(key: key);

  @override
  State<ChildProfile> createState() => _ChildProfileState();
}

class _ChildProfileState extends State<ChildProfile> {
  final name = TextEditingController();
  final birthDate = TextEditingController();
  String sextype = '';
  String premature = '';
  late String formattedDate;
  late DateTime pickDate;
  late DateTime currentDate;
  double weight = 3.0;
  double height = 50;
  double circle = 34.0;
  double prematureWeek = 37;
  late List dbProfile, dbChildBook;
  bool firstLoad = true;
  bool error = false;

  Future getProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getChildBook() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_childbook.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updChildsProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_childs_profile.php?phone=${prefs.getPhone}'
        '&childs_name=${name.text}&childs_sex=$sextype&birth_date=$formattedDate'
        '&premature=$premature&premature_week=$prematureWeek');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updChildBook() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_childbook.php?phone=${prefs.getPhone}'
        '&birth_date=$formattedDate&weight=$weight&height=$height&circle=${circle.toStringAsFixed(1)}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future addChildBook() async {
    var url = 'https://app.empatbulan.com/api/add_childbook.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'base' : '1',
      'growth_date' : formattedDate,
      'weight' : weight.toStringAsFixed(1),
      'height' : height.toString(),
      'circle' : circle.toStringAsFixed(1),
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (prefs.getBackRoute == '/profile') {
          Navigator.pop(context);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
        }
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

                  if (firstLoad) {
                    name.text = dbProfile[0]['childs_name'];
                    if (dbProfile[0]['birth_date'].toString().isNotEmpty) {
                      currentDate = DateTime(
                          int.parse(dbProfile[0]['birth_date'].substring(0, 4)),
                          int.parse(dbProfile[0]['birth_date'].substring(5, 7)),
                          int.parse(dbProfile[0]['birth_date'].substring(8, 10))
                      );
                      formattedDate = DateFormat('yyyy-MM-dd', 'id_ID').format(currentDate);
                      birthDate.text = DateFormat('d MMM yyyy', 'id_ID').format(currentDate);
                    }
                    sextype = dbProfile[0]['childs_sex'];
                    premature = dbProfile[0]['premature'];
                    prematureWeek = double.parse(dbProfile[0]['premature_week']);
                  }
                }
                return FutureBuilder(
                  future: getChildBook(),
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
                        if (dbChildBook.isNotEmpty) {
                          weight = double.parse(dbChildBook[0]['weight']);
                          height = double.parse(dbChildBook[0]['height']);
                          circle = double.parse(dbChildBook[0]['head']);
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
                                  'Profil Anak',
                                  style: TextStyle(
                                    fontSize: 24.0.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 5.3.h,),
                                Visibility(
                                  visible: error ? true : false,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 2.8.w,
                                            height: 15.6.w,
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                          SizedBox(width: 4.0.w,),
                                          Expanded(
                                            child: Text(
                                              'Bunda belum melengkapi semua data. Pastikan semua data '
                                                  'Profil Anak telah terisi dengan benar.',
                                              style: TextStyle(
                                                fontSize: 13.0.sp,
                                                color: Theme.of(context).colorScheme.error,
                                                height: 1.16,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.visible,
                                              softWrap: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 3.8.h,),
                                    ],
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.8.w),
                                      child: Text(
                                        'Nama Lengkap Anak',
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
                                  controller: name,
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      error = false;
                                    });
                                  },
                                ),
                                SizedBox(height: 3.8.h,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.8.w),
                                      child: Text(
                                        'Tanggal Lahir',
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
                                  controller: birthDate,
                                  readOnly: true,
                                  onTap: () {
                                    date_picker.DatePicker.showDatePicker(
                                      context,
                                      minTime: DateTime.now().subtract(const Duration(days: 1825)),
                                      maxTime: DateTime.now(),
                                      onConfirm: (date) {
                                        setState(() {
                                          pickDate = date;
                                          formattedDate = DateFormat('yyyy-MM-dd', 'id_ID').format(pickDate);
                                          birthDate.text = DateFormat('d MMM yyyy', 'id_ID').format(pickDate);
                                          error = false;
                                        });
                                      },
                                      theme: date_picker.DatePickerTheme(
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
                                      locale: date_picker.LocaleType.id,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.8.w),
                                      child: Text(
                                        'Jenis Kelamin',
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
                                                        error = false;
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
                                                        error = false;
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
                                  'DATA KELAHIRAN',
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    color: Theme.of(context).unselectedWidgetColor,
                                  ),
                                ),
                                SizedBox(height: 2.4.h,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.8.w),
                                      child: Text(
                                        'Apakah anak Bunda lahir prematur?',
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 1.2.w,),
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
                                                padding: EdgeInsets.symmetric(horizontal: 8.8.w, vertical: 5.2.w),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Lahir Prematur?',
                                                      style: TextStyle(
                                                        fontSize: 16.0.sp,
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
                                                      'Ya',
                                                      style: TextStyle(
                                                        fontSize: 13.0.sp,
                                                      ),
                                                    ),
                                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                                    onTap: () {
                                                      setState(() {
                                                        premature = 'Ya';
                                                        error = false;
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
                                                      'Tidak',
                                                      style: TextStyle(
                                                        fontSize: 13.0.sp,
                                                      ),
                                                    ),
                                                    contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                                                    onTap: () {
                                                      setState(() {
                                                        premature = 'Tidak';
                                                        error = false;
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
                                            premature,
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
                                Visibility(
                                  visible: premature == 'Ya' ? true : false,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 3.8.h,),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 36.7.w,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 0.8.w),
                                              child: Text(
                                                'Lahir di Pekan ke-',
                                                style: TextStyle(
                                                  fontSize: 13.0.sp,
                                                  color: Colors.black,
                                                ),
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
                                              if (prematureWeek > 1) {
                                                setState(() {
                                                  prematureWeek -= 1;
                                                });
                                              }
                                            },
                                            child: Image.asset(
                                              prematureWeek == 1
                                                  ? 'images/ic_decrement_inactive.png'
                                                  : 'images/ic_decrement.png',
                                              width: 9.4.w,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 16.9.w,
                                            child: Text(
                                              prematureWeek.toStringAsFixed(0),
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
                                                prematureWeek += 1;
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
                                SizedBox(height: 3.8.h,),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 28.8.w,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 0.8.w),
                                        child: Text(
                                          'Berat Badan saat lahir (kg)',
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            color: Colors.black,
                                          ),
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
                                    SizedBox(
                                      width: 30.0.w,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 0.8.w),
                                        child: Text(
                                          'Tinggi Badan saat lahir (cm)',
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            color: Colors.black,
                                          ),
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
                                SizedBox(height: 3.8.h,),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 28.0.w,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 0.8.w),
                                        child: Text(
                                          'Lingkar Kepala saat lahir (cm)',
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(width: 1.1.w,),
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
                                        if (circle > 1) {
                                          setState(() {
                                            circle -= 0.1;
                                          });
                                        }
                                      },
                                      child: Image.asset(
                                        circle.toStringAsFixed(1) == '0.1'
                                            ? 'images/ic_decrement_inactive.png'
                                            : 'images/ic_decrement.png',
                                        width: 9.4.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.9.w,
                                      child: Text(
                                        circle.toStringAsFixed(1),
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
                                          circle += 0.1;
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
                    if (prefs.getBackRoute == '/profile') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
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
                          if (name.text != '' && birthDate.text != '' && sextype != '' && premature != '') {
                            updChildsProfile();
                            if (dbChildBook.isNotEmpty) {
                              updChildBook();
                            } else {
                              addChildBook();
                            }
                            if (prefs.getBackRoute == '/profile') {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacementNamed(context, '/childChart');
                            }
                          } else {
                            setState(() {
                              error = true;
                            });
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
