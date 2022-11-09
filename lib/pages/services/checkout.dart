import 'dart:convert';
import 'dart:core';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:empat_bulan/main.dart';
import 'package:http/http.dart' as http;

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final _email = TextEditingController();
  final _igAccount = TextEditingController();
  final _health = TextEditingController();
  final _complaint = TextEditingController();
  int pregnantNo = 0, pregnantWeek = 0;
  bool isInvalid = false;
  bool error = false;
  bool firstLoad = true;
  late int currentAge;
  late List dbProfile, dbTimeline;

  Future getProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updCustomerProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_customer_profile.php?phone=${prefs.getPhone}'
        '&email=${_email.text}&ig_account=${_igAccount.text}&pregnant_no=$pregnantNo'
        '&pregnant_week=$pregnantWeek&health_history=${_health.text}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getTimeline() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_timeline.php?id=$currentAge');
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
                    _email.text = dbProfile[0]['email'];
                    _igAccount.text = dbProfile[0]['ig_account'];
                    pregnantNo = int.parse(dbProfile[0]['pregnant_no']);
                    pregnantWeek = int.parse(dbProfile[0]['pregnant_week']);
                    _health.text = dbProfile[0]['health_history'];
                    _complaint.text = prefs.getComplaint;

                    if (dbProfile[0]['basecount'] != '') {
                      DateTime hpht = DateTime(
                          int.parse(dbProfile[0]['hpht'].substring(0, 4)),
                          int.parse(dbProfile[0]['hpht'].substring(5, 7)),
                          int.parse(dbProfile[0]['hpht'].substring(8, 10))
                      );
                      currentAge = (DateTime.now().difference(hpht).inDays);
                    }
                  }
                }
                return FutureBuilder(
                  future: getTimeline(),
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
                      dbTimeline = snapshot.data as List;

                      if (firstLoad) {
                        if (dbProfile[0]['basecount'] != '') {
                          pregnantWeek = int.parse(dbTimeline[0]['week']);
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
                                  'Informasi Pemesan',
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
                                              'Bunda belum melengkapi email Bunda. Pastikan semua data '
                                                  'pemessan telah terisi dengan benar.',
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
                                        'Email',
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
                                  controller: _email,
                                  style: TextStyle(
                                    fontSize: 15.0.sp,
                                  ),
                                  onChanged: (str) {
                                    if (isInvalid) {
                                      setState(() {
                                        isInvalid = false;
                                      });
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                Visibility(
                                    visible: isInvalid ? true : false,
                                    child: SizedBox(height: 1.0.h,)
                                ),
                                isInvalid ? Row(
                                  children: [
                                    SizedBox(
                                      width: 4.0.w,
                                      height: 4.0.w,
                                      child: Image.asset(
                                        'images/ic_error.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 1.0.w,),
                                    Padding(
                                      padding: EdgeInsets.only(top: 0.8.w),
                                      child: Text(
                                        'Alamat email tidak benar',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.error,
                                          fontSize: 10.0.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ) : Container(),
                                SizedBox(height: 3.8.h,),
                                Text(
                                  'Akun IG',
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                TextField(
                                  controller: _igAccount,
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
                                        'Hamil Ke',
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: SizedBox(),),
                                    InkWell(
                                      onTap: () {
                                        if (pregnantNo > 0) {
                                          setState(() {
                                            pregnantNo -= 1;
                                          });
                                        }
                                      },
                                      child: Image.asset(
                                        pregnantNo == 0
                                            ? 'images/ic_decrement_inactive.png'
                                            : 'images/ic_decrement.png',
                                        width: 9.4.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.9.w,
                                      child: Text(
                                        pregnantNo.toString(),
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
                                          pregnantNo += 1;
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
                                        'Usia Kehamilan\n(Pekan)',
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Colors.black,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    const Expanded(child: SizedBox(),),
                                    InkWell(
                                      onTap: () {
                                        if (pregnantWeek > 0) {
                                          setState(() {
                                            pregnantWeek -= 1;
                                          });
                                        }
                                      },
                                      child: Image.asset(
                                        pregnantWeek == 0
                                            ? 'images/ic_decrement_inactive.png'
                                            : 'images/ic_decrement.png',
                                        width: 9.4.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 16.9.w,
                                      child: Text(
                                        pregnantWeek.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (pregnantWeek < 45) {
                                          setState(() {
                                            pregnantWeek += 1;
                                          });
                                        }
                                      },
                                      child: Image.asset(
                                        pregnantWeek == 44
                                            ? 'images/ic_increment_inactive.png'
                                            : 'images/ic_increment.png',
                                        width: 9.4.w,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.8.h,),
                                Text(
                                  'Riwayat Sakit',
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: double.infinity,
                                  ),
                                  child: TextField(
                                    controller: _health,
                                    minLines: 1,
                                    maxLines: 6,
                                    keyboardType: TextInputType.multiline,
                                    textCapitalization: TextCapitalization.sentences,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      fontSize: 15.0.sp,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3.8.h,),
                                Text(
                                  'Keluhan',
                                  style: TextStyle(
                                    fontSize: 13.0.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: double.infinity,
                                  ),
                                  child: TextField(
                                    controller: _complaint,
                                    minLines: 1,
                                    maxLines: 6,
                                    keyboardType: TextInputType.multiline,
                                    textCapitalization: TextCapitalization.sentences,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      fontSize: 15.0.sp,
                                      height: 1.2,
                                    ),
                                  ),
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
                          if (_email.text != '') {
                            if (EmailValidator.validate(_email.text)) {
                              updCustomerProfile();
                              prefs.setComplaint(_complaint.text);
                              if (prefs.getBackRoute == '/cart') {
                                await Navigator.pushNamedAndRemoveUntil(context, '/confirm', (route) => true);
                              } else {
                                await Navigator.pushNamed(context, '/confirm');
                              }
                            } else {
                              setState(() {
                                isInvalid = true;
                              });
                            }
                          } else {
                            setState(() {
                              error = false;
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
