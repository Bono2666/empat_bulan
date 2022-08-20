// @dart=2.9
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:mailer/smtp_server.dart';
import 'package:sizer/sizer.dart';
import 'package:empat_bulan/main.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import '../../api/google_auth_api.dart';

String imgUrl, classTitle;

class Confirm extends StatefulWidget {
  const Confirm({Key key}) : super(key: key);

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  List dbSelectedCart, dbProfile, dbGroupCart;

  Future getSelectedCart() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_selected_cart.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updSelectedClass(int id, int selected) async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_selected_class.php?id=$id&selected=$selected');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future delSelectedClass(int index) async {
    var url = 'https://app.empatbulan.com/api/del_selected_class.php';
    await http.post(Uri.parse(url), body: {
      'id' : dbSelectedCart[index]['id'],
    });
  }

  Future addOrder(String orderId) async {
    var url = 'https://app.empatbulan.com/api/add_class_order.php';
    await http.post(Uri.parse(url), body: {
      'id' : orderId,
      'order_date' : DateFormat('yyyy-MM-dd', 'id_ID').format(DateTime.now()),
      'phone' : prefs.getPhone,
      'complaint' : prefs.getComplaint,
    });
  }

  Future addDetOrder(String orderId, int id) async {
    var url = 'https://app.empatbulan.com/api/add_det_class_order.php';
    await http.post(Uri.parse(url), body: {
      'id' : orderId,
      'class_id' : id.toString(),
    });
  }

  Future getProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getGroupCart() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_group_cart.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future sendEmail(String mailTo) async {
    // GoogleAuthApi.signOut();
    // return;
    final user = await GoogleAuthApi.signIn();

    if (user == null) return;

    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken;

    final smtpServer = gmailSaslXoauth2(email, token);
    final message = Message()
      ..from = Address(email, 'EmpatBulan')
      ..recipients = [mailTo]
      ..subject = 'Registrasi Layanan Bunda'
      ..html = 'Dear Bunda,<br><br>'
          'Terima kasih Bunda telah melakukan registrasi layanan melalui aplikasi <span style="color: #C09AC7;"><b>EmpatBulan</b></span>.<br><br>'
          'Pastikan ponsel Bunda selalu dalam keadaan aktif. Insya Allah kami akan segera menghubungi Bunda.<br><br>'
          'Mohon untuk tidak membalas email ini. Terima kasih.<br><br>'
          'Salam,<br><b>Tim <span style="color: #C09AC7;">EmpatBulan</b></span>';

    try {
      await send(message, smtpServer);
      showDialog(
        context: context,
        builder: (_) => const Info(),
        barrierDismissible: false,
      );
    } on MailerException {
      // print(e);
    }
  }

  Future sendEmailJS(String email) async {
    const serviceId = 'service_m0ba253';
    const templateId = 'template_77rgate';
    const userId = 'DNTUlAAVJc9Ax1HeJ';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'to_email': email,
        }
      }),
    );

    showDialog(
      context: context,
      builder: (_) => const Info(),
      barrierDismissible: false,
    );
    // print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (prefs.getBackRoute == '/cart') {
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
                    padding: EdgeInsets.symmetric(horizontal: 7.8.w,),
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
                              color: Theme.of(context).backgroundColor,
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
        } else {
          Navigator.pushNamedAndRemoveUntil(context, '/checkout', (route) => true);
        }
        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: getSelectedCart(),
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
              dbSelectedCart = snapshot.data as List;
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
                return FutureBuilder(
                  future: getGroupCart(),
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
                      dbGroupCart = snapshot.data as List;
                    }
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 19.0.h,),
                                    Text(
                                      'Konfirmasi Pesanan',
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
                                        itemCount: dbSelectedCart.length,
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
                                                  Expanded(
                                                    child: SizedBox(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Text(
                                                            dbSelectedCart[index]['title'],
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 13.0.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          SizedBox(height: 1.7.w,),
                                                          Text(
                                                            dbSelectedCart[index]['instructur'],
                                                            textAlign: TextAlign.right,
                                                            style: TextStyle(
                                                              fontSize: 8.0.sp,
                                                              color: Theme.of(context).backgroundColor,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5.6.w,),
                                                          Text(
                                                            NumberFormat.currency(
                                                              locale: 'id',
                                                              symbol: 'Rp ',
                                                              decimalDigits: 0,
                                                            ).format(int.parse(dbSelectedCart[index]['total_price'])),
                                                            style: TextStyle(
                                                              fontSize: 9.0.sp,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          SizedBox(height: 2.4.w,),
                                                        ],
                                                      ),
                                                    ),
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
                                                          dbSelectedCart[index]['image'],
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
                                    Row(
                                      children: [
                                        Text(
                                          'DATA PEMESAN',
                                          style: TextStyle(
                                            fontSize: 10.0.sp,
                                            color: Theme.of(context).backgroundColor,
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context, '/checkout');
                                          },
                                          child: SizedBox(
                                            width: 4.4.w,
                                            height: 4.4.w,
                                            child: FittedBox(
                                              child: Image.asset('images/ic_edit.png'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4.7.h,),
                                    Row(
                                      children: [
                                        Text(
                                          'Akun IG',
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Text(
                                          dbProfile[0]['ig_account'],
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.4.h,),
                                    Row(
                                      children: [
                                        Text(
                                          'Hamil ke/Usia Hamil',
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Text(
                                          '${dbProfile[0]['pregnant_no'] == '0' ? '-' : dbProfile[0]['pregnant_no']}/${dbProfile[0]['pregnant_week'] == '0' ? '-' : dbProfile[0]['pregnant_week']}',
                                          style: TextStyle(
                                            fontSize: 12.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.4.h,),
                                    Text(
                                      'Riwayat Sakit & Keluhan',
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 1.4.h,),
                                    Text(
                                      '${dbProfile[0]['health_history'] == '' || dbProfile[0]['health_history'] == null
                                          ? '' : dbProfile[0]['health_history'] + ', '}${prefs.getComplaint}',
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: Theme.of(context).unselectedWidgetColor,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: 3.8.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context).dividerColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4.1.h,),
                                    Text(
                                      'BIAYA',
                                      style: TextStyle(
                                        fontSize: 10.0.sp,
                                        color: Theme.of(context).backgroundColor,
                                      ),
                                    ),
                                    SizedBox(height: 4.7.h,),
                                    Row(
                                      children: [
                                        Text(
                                          'Total Harga',
                                          style: TextStyle(
                                            fontSize: 14.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(int.parse(dbGroupCart[0]['price'])),
                                          style: TextStyle(
                                            fontSize: 14.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.3.h,),
                                    Row(
                                      children: [
                                        Text(
                                          'Diskon',
                                          style: TextStyle(
                                            fontSize: 14.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(int.parse(dbGroupCart[0]['price']) - int.parse(dbGroupCart[0]['total_price'])),
                                          style: TextStyle(
                                            fontSize: 14.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.5.h,),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context).dividerColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4.4.h,),
                                    Row(
                                      children: [
                                        Text(
                                          'Total (IDR)',
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const Expanded(child: SizedBox()),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 0,
                                          ).format(int.parse(dbGroupCart[0]['total_price'])),
                                          style: TextStyle(
                                            fontSize: 17.0.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 17.8.h,),
                            ],
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                if (prefs.getBackRoute == '/cart') {
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
                                            padding: EdgeInsets.symmetric(horizontal: 7.8.w,),
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
                                                      color: Theme.of(context).backgroundColor,
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
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(context, '/checkout', (route) => true);
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
                                      String orderId = DateFormat('yyyyMMddHHmm', 'id_ID').format(DateTime.now());
                                      await addOrder(orderId);
                                      for (int i=0; i < dbSelectedCart.length; i++ ) {
                                        addDetOrder(orderId, int.parse(dbSelectedCart[0]['class_id']));
                                        await delSelectedClass(i);
                                      }

                                      imgUrl = dbSelectedCart[0]['image'];
                                      classTitle = dbSelectedCart[0]['title'];
                                      // sendEmail(dbProfile[0]['email']);

                                      sendEmailJS(dbProfile[0]['email']);
                                    },
                                    child: Container(
                                      width: 74.4.w,
                                      height: 12.0.h,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).backgroundColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(40),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Kirim Pesanan',
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

class Info extends StatefulWidget {
  const Info({Key key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

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
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Image.network(
                        imgUrl,
                        height: 54.4.w,
                        width: 84.0.w,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return SizedBox(
                            height: 54.4.w,
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.7.w,),
                        Text(
                          classTitle,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 4.4.w,),
                        Text(
                          'Alhamdulillah, pesanan Bunda telah kami terima. Kami telah mengirimkan email untuk pesanan'
                              ' Bunda, pastikan email tersebut tidak masuk ke dalam email sampah dan pastikan ponsel '
                              'Bunda selalu dalam keadaan aktif.\n\nInsya Allah kami akan segera menghubungi Bunda.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0.sp,
                            height: 1.2,
                          ),
                        ),
                        // SizedBox(height: 6.7.w,),
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
                              Navigator.pushNamedAndRemoveUntil(context, '/homeServices', (route) => true);
                            },
                            child: Container(
                              width: 28.0.w,
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
                                  'Ok',
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