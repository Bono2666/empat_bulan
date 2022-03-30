// @dart=2.9
// import 'dart:math';
// import 'package:empat_bulan/main.dart';
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var name = TextEditingController();
  String phone = '', isoCode = 'ID', dialCode = '+62';
  bool isNameError = false;
  bool isPhoneError = false;

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
    gestures: [
      GestureType.onTap,
      GestureType.onVerticalDragDown,
    ],
    child: Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.0.w,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 19.0.h,),
                  Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.0.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.8.w),
                        child: Text(
                          'Nama Lengkap',
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
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: name,
                    style: TextStyle(
                      fontSize: 15.0.sp,
                    ),
                    onChanged: (str) {
                      if (isNameError) {
                        setState(() {
                          isNameError = false;
                        });
                      }
                    },
                  ),
                  isNameError ? SizedBox(height: 1.0.h,) : Container(),
                  isNameError ? Row(
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
                        'Silahkan masukkan nama untuk melanjutkan',
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 10.0.sp,
                        ),
                      ),
                    ],
                  ) : Container(),
                  SizedBox(height: 3.0.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0.8.w),
                        child: Text(
                          'Nomor Ponsel',
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
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.3.h,),
                  InternationalPhoneNumberInput(
                    onInputChanged: (value) {
                      phone = value.phoneNumber;
                      isoCode = value.isoCode;
                      dialCode = value.dialCode;
                      if (isPhoneError) {
                        setState(() {
                          isPhoneError = false;
                        });
                      }
                    },
                    selectorConfig: SelectorConfig(
                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                      trailingSpace: false,
                    ),
                    keyboardType: TextInputType.phone,
                    selectorTextStyle: TextStyle(
                      fontSize: 20.0.sp,
                    ),
                    hintText: '',
                    textStyle: TextStyle(
                      fontSize: 20.0.sp,
                    ),
                    initialValue: PhoneNumber(isoCode: isoCode, phoneNumber: phone),
                    maxLength: 15,
                    searchBoxDecoration: InputDecoration(
                      hintText: 'Cari nama atau kode negara',
                      contentPadding: EdgeInsets.only(left: 4.8.w,),
                      alignLabelWithHint: false,
                    ),

                  ),
                  isPhoneError ? SizedBox(height: 1.0.h,) : Container(),
                  isPhoneError ? Row(
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
                        'Nomor Ponsel minimal harus memiliki 9 angka',
                        style: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 10.0.sp,
                        ),
                      ),
                    ],
                  ) : Container(),
                  SizedBox(height: 3.2.h,),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 10.0.sp,
                        fontFamily: GoogleFonts.josefinSans().fontFamily,
                        height: 1.6,
                      ),
                      children: [
                        TextSpan(
                          text: 'Dengan mendaftar, Bunda telah menyetujui ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Aturan Penggunaan',
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                        TextSpan(
                          text: ' dan ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Kebijakan Privasi',
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                          ),
                        ),
                        TextSpan(
                          text: ' Aplikasi EmpatBulan.',
                          style: TextStyle(
                            color: Colors.black,
                          ),
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
                    onTap: () {
                      if (name.text == '' || phone.length < 12) {
                        setState(() {
                          if (name.text == '') isNameError = true;
                          if (phone.length < 12) isPhoneError = true;
                        });
                      } else {
                        prefs.setName(name.text);
                        prefs.setIsoCode(isoCode);
                        prefs.setDialCode(dialCode);
                        prefs.setPhone(phone);
                        Navigator.pushNamed(context, '/verification');
                      }
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
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}