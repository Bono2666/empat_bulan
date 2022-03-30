// @dart=2.9
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Verification extends StatefulWidget {
  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  var code = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDReceived = '';
  bool isInvalid = false;

  @override
  void initState() {
    super.initState();

    auth.verifyPhoneNumber(
      phoneNumber: prefs.getPhone,
      verificationCompleted: (creds) async {
        await auth.signInWithCredential(creds).then((value) => print('Berhasil masuk'));
      },
      verificationFailed: (e) {
        print(e.message);
      },
      codeSent: (verificationID, resendToken) {
        verificationIDReceived = verificationID;
      },
      codeAutoRetrievalTimeout: (verificationID) {

      },
    );
  }

  Future addUser() async {
    var url = 'https://empatbulan.bonoworks.id/api/add_user.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'name' : prefs.getName,
      'isoCode' : prefs.getIsoCode,
      'dialCode' : prefs.getDialCode,
    });
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
    gestures: [
      GestureType.onTap,
      GestureType.onVerticalDragDown,
    ],
    child: Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView (
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.0.w,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 19.0.h,),
                  Text(
                    'Masukkan Kode',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 1.9.h,),
                  Text(
                    'Masukkan Kode yang dikirim melalui SMS.',
                    style: TextStyle(
                      fontSize: 15.0.sp,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(width: 1.6.h,),
                  TextField(
                    controller: code,
                    onChanged: (str) {
                      if (isInvalid) {
                        setState(() {
                          isInvalid = false;
                        });
                      }
                    },
                    style: TextStyle(
                      fontSize: 20.0.sp,
                    ),
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                  ),
                  isInvalid ? Row(
                    children: [
                      Container(
                        width: 4.0.w,
                        height: 4.0.w,
                        child: Image.asset(
                          'images/ic_error.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 1.0.w,),
                      Text(
                        'Kode OTP tidak valid',
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 10.0.sp,
                        ),
                      ),
                    ],
                  ) : Container(),
                  SizedBox(height: 5.0.h,),
                  InkWell(
                    onTap: () {
                      auth.verifyPhoneNumber(
                        phoneNumber: prefs.getPhone,
                        verificationCompleted: (creds) async {
                          await auth.signInWithCredential(creds).then((value) => print('Berhasil masuk'));
                        },
                        verificationFailed: (e) {
                          print(e.message);
                        },
                        codeSent: (verificationID, resendToken) {
                          verificationIDReceived = verificationID;
                        },
                        codeAutoRetrievalTimeout: (verificationID) {

                        },
                      );
                    },
                    child: Text(
                      'Kirim Ulang Kode',
                      style: TextStyle(
                        fontSize: 15.0.sp,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.2.h,),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Ganti Nomor',
                      style: TextStyle(
                        fontSize: 15.0.sp,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 11.3.h,),
                ],
              ),
            ),
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
                    borderRadius: BorderRadius.only(
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
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () async {
                      PhoneAuthCredential creds = PhoneAuthProvider.credential(
                        verificationId: verificationIDReceived,
                        smsCode: code.text,
                      );
                      await auth.signInWithCredential(creds).then((value) {
                        prefs.setIsSignIn(true);
                        addUser();
                        Navigator.pushReplacementNamed(context, prefs.getGoRoute);
                      }).catchError((onError) {
                        setState(() {
                          isInvalid = true;
                        });;
                      });
                    },
                    child: Container(
                      width: 74.0.w,
                      height: 12.0.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Verifikasi',
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
  );
}
