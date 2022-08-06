// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'package:email_validator/email_validator.dart';

class UpdProfile extends StatefulWidget {
  const UpdProfile({Key key}) : super(key: key);

  @override
  State<UpdProfile> createState() => _UpdProfileState();
}

class _UpdProfileState extends State<UpdProfile> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  List dbProfile;
  bool isInvalid = false;
  bool firstLoad = true;
  bool emailOk = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  int _verified;

  Future getProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_profile.php?phone=${prefs.getPhone}&name=${_name.text}&email=${_email.text}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updVerified() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_verified.php?phone=${prefs.getPhone}&verified=$_verified');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future<void> checkEmailVerified() async {
    await user.reload();
    if (!user.emailVerified) {
      timer.cancel();
      _verified = 1;
      updVerified();
      auth.signOut();
    }
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
                  _name.text = dbProfile[0]['name'];
                  _phone.text = prefs.getFmtPhone;
                  _email.text = dbProfile[0]['email'];

                  firstLoad = false;
                }
              }
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0.w,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 19.0.h,),
                      Text(
                        'Profil Bunda',
                        style: TextStyle(
                          fontSize: 24.0.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 5.3.h,),
                      Text(
                        'Nama Lengkap',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                      ),
                      TextField(
                        controller: _name,
                        style: TextStyle(
                          fontSize: 15.0.sp,
                        ),
                      ),
                      SizedBox(height: 3.8.h,),
                      Text(
                        'Nomor Ponsel',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                      ),
                      TextField(
                        controller: _phone,
                        style: TextStyle(
                          fontSize: 15.0.sp,
                        ),
                        enabled: false,
                      ),
                      SizedBox(height: 3.8.h,),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Theme.of(context).unselectedWidgetColor,
                        ),
                      ),
                      TextField(
                        controller: _email,
                        style: TextStyle(
                          fontSize: 15.0.sp,
                        ),
                        onChanged: (str) {
                          if (isInvalid || emailOk) {
                            setState(() {
                              isInvalid = false;
                              emailOk = false;
                            });
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Visibility(
                        visible: isInvalid ? true : false,
                        child: SizedBox(height: 1.0.h,)
                      ),
                      isInvalid
                          ? Row(
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
                          Text(
                            'Alamat email tidak benar',
                            style: TextStyle(
                              color: Theme.of(context).errorColor,
                              fontSize: 10.0.sp,
                            ),
                          ),
                        ],
                      )
                          : Container(),
                      Visibility(
                        visible: emailOk && _email.text != '' && dbProfile[0]['verified'] == '0' ? true : false,
                        child: Column(
                          children: [
                            SizedBox(height: 1.0.h,),
                            Row(
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
                                Text(
                                  'Email belum diverifikasi',
                                  style: TextStyle(
                                    color: Theme.of(context).errorColor,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: emailOk && _email.text != '' && dbProfile[0]['verified'] == '1' ? true : false,
                        child: Column(
                          children: [
                            SizedBox(height: 1.0.h,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 4.0.w,
                                  height: 4.0.w,
                                  child: Image.asset(
                                    'images/ic_check.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 1.0.w,),
                                Text(
                                  'Email terverifikasi.',
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 10.0.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: dbProfile[0]['verified'] == '0' ? true : false,
                        child: Column(
                          children: [
                            SizedBox(height: 5.0.h,),
                            InkWell(
                              onTap: () async {
                                if (_email.text != '') {
                                  if (EmailValidator.validate(_email.text)) {
                                    try {
                                      await auth.signInWithEmailAndPassword(
                                          email: _email.text, password: '123456');
                                    } catch(e) {
                                      auth.createUserWithEmailAndPassword(email: _email
                                          .text, password: '123456').then((value) {
                                        updProfile();
                                        user = auth.currentUser;
                                        user.sendEmailVerification();
                                        timer = Timer.periodic(
                                            const Duration(seconds: 5), (timer) {
                                          checkEmailVerified();
                                        });
                                      });
                                    }

                                    if (auth.currentUser.uid != null) {
                                      auth.signOut();
                                      updProfile();
                                      _verified = 1;
                                      updVerified();
                                      // ignore: use_build_context_synchronously
                                      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UpdProfile(),));
                                    }
                                  } else {
                                    setState(() {
                                      isInvalid = true;
                                      emailOk = false;
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Verifikasi Email',
                                style: TextStyle(
                                  fontSize: 15.0.sp,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 17.5.h,),
                    ],
                  ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      if (_email.text != '' && EmailValidator.validate(_email.text)) {
                        try {
                          await auth.signInWithEmailAndPassword(
                              email: _email.text, password: '123456');
                        } catch(e) {
                          auth.createUserWithEmailAndPassword(email: _email
                              .text, password: '123456').then((value) {
                            updProfile();
                            user = auth.currentUser;
                            user.sendEmailVerification();
                            timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
                              checkEmailVerified();
                              // ignore: use_build_context_synchronously
                              await Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => true);
                            });
                          });
                        }

                        if (auth.currentUser.uid != null) {
                          auth.signOut();
                          updProfile();
                          _verified = 1;
                          updVerified();
                          // ignore: use_build_context_synchronously
                          await Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => true);
                        }
                      } else {
                        if (_email.text == '') {
                          updProfile();
                          _verified = 0;
                          updVerified();
                          // ignore: use_build_context_synchronously
                          await Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => true);
                        } else {
                          setState(() {
                            isInvalid = true;
                            emailOk = false;
                          });
                        }
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
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
