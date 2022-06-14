// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:empat_bulan/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:phone_number/phone_number.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List dbUser;
  RegionInfo region = RegionInfo(
    name: prefs.getIsoCode,
    code: prefs.getIsoCode,
    prefix: int.parse(prefs.getDialCode.substring(1, prefs.getDialCode.length)),
  );
  String phone = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  File img;
  final picker = ImagePicker();

  Future getUser() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/get_user.php?phone=' + prefs.getPhone);
    var response = await http.get(url);
    phone = await PhoneNumberUtil().format(prefs.getPhone, region.code);
    return json.decode(response.body);
  }

  Future pickImg() async {
    var picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 180,
      maxWidth: 180,
    );
    setState(() {
      img = File(picked.path);
    });
    upload();
  }

  Future upload() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/upload_avatar.php');
    var req = http.MultipartRequest('POST', url);
    req.fields['phone'] = prefs.getPhone;
    var pic = await http.MultipartFile.fromPath('image', img.path);
    req.files.add(pic);
    var response = await req.send();

    if (response.statusCode == 200) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: getUser(),
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
              dbUser = snapshot.data as List;
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.0.w,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 18.8.h,),
                        Row(
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      width: 21.7.w,
                                      height: 21.7.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Visibility(
                                        visible: dbUser[0]['avatar'] == '' ? false : true,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          child: Image.network(
                                            dbUser[0]['avatar'],
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return SizedBox(
                                                height: 21.7.w,
                                                child: Center(
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
                                    Visibility(
                                      visible: dbUser[0]['avatar'] == '' ? true : false,
                                      child: Container(
                                        width: 11.1.w,
                                        height: 11.1.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_profile.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    pickImg();
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Container(
                                        width: 6.7.w,
                                        height: 6.7.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        width: 2.8.w,
                                        height: 2.8.w,
                                        child: FittedBox(
                                          child: Image.asset(
                                            'images/ic_cam.png',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 5.0.w,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    child: Text(
                                      dbUser[0]['name'],
                                      style: TextStyle(
                                        fontSize: 16.0.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    visible: dbUser[0]['name'].toString().isEmpty ? false : true,
                                  ),
                                  Visibility(
                                    visible: dbUser[0]['name'].toString().isEmpty ? false : true,
                                    child: SizedBox(height: 0.9.h,),
                                  ),
                                  Text(
                                    phone,
                                    style: TextStyle(
                                      fontSize: 13.0.sp,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.1.h,),
                        Text(
                          'AKTIVITAS',
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                        ),
                        SizedBox(height: 3.1.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.2.w,),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 16.7.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: AlignmentDirectional.center,
                                      children: [
                                        Container(
                                          width: 11.1.w,
                                          height: 11.1.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                            color: Theme.of(context).backgroundColor,
                                          ),
                                        ),
                                        Container(
                                          width: 5.6.w,
                                          height: 5.6.w,
                                          child: FittedBox(
                                            child: Image.asset(
                                              'images/ic_forum.png',
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 2.0.w,),
                                    Text(
                                      'Forum Saya',
                                      style: TextStyle(
                                        fontSize: 10.0.sp,
                                        color: Colors.black,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  prefs.setBackRoute('/profile');
                                  Navigator.pushNamed(context, '/schedule');
                                },
                                child: SizedBox(
                                  width: 16.7.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Container(
                                            width: 11.1.w,
                                            height: 11.1.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              color: Theme.of(context).backgroundColor,
                                            ),
                                          ),
                                          Container(
                                            width: 5.6.w,
                                            height: 5.6.w,
                                            child: FittedBox(
                                              child: Image.asset(
                                                'images/ic_schedule.png',
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 2.0.w,),
                                      Text(
                                        'Jadwal Kontrol',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          color: Colors.black,
                                          height: 1.2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/todo');
                                },
                                child: SizedBox(
                                  width: 16.7.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Container(
                                            width: 11.1.w,
                                            height: 11.1.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(30)),
                                              color: Theme.of(context).backgroundColor,
                                            ),
                                          ),
                                          Container(
                                            width: 5.6.w,
                                            height: 5.6.w,
                                            child: FittedBox(
                                              child: Image.asset(
                                                'images/ic_checklist.png',
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 2.5.w,),
                                      Text(
                                        'To Do List',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(flex: 7),
                            ],
                          ),
                        ),
                        SizedBox(height: 4.1.h,),
                        Text(
                          'PROFIL',
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                        ),
                        SizedBox(height: 2.5.h,),
                        Row(
                          children: [
                            Text(
                              'Profil Bunda',
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Container(
                              width: 6.7.w,
                              height: 6.7.w,
                              child: FittedBox(
                                child: Image.asset(
                                  'images/ic_profile_color.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 2.5.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.5.h,),
                        Row(
                          children: [
                            Text(
                              'Profil Kehamilan',
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Container(
                              width: 6.7.w,
                              height: 6.7.w,
                              child: FittedBox(
                                child: Image.asset(
                                  'images/ic_pregnant.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 2.5.h,
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
                          'UMUM',
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            color: Theme.of(context).unselectedWidgetColor,
                          ),
                        ),
                        SizedBox(height: 2.5.h,),
                        Row(
                          children: [
                            Text(
                              'Kebijakan Privasi',
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Container(
                              width: 6.7.w,
                              height: 6.7.w,
                              child: FittedBox(
                                child: Image.asset(
                                  'images/ic_letter.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 2.5.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.5.h,),
                        Row(
                          children: [
                            Text(
                              'Aturan Penggunaan',
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Container(
                              width: 6.7.w,
                              height: 6.7.w,
                              child: FittedBox(
                                child: Image.asset(
                                  'images/ic_rules.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 2.5.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.5.h,),
                        Row(
                          children: [
                            Text(
                              'Tentang Kami',
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                color: Colors.black,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Container(
                              width: 6.7.w,
                              height: 6.7.w,
                              child: FittedBox(
                                child: Image.asset(
                                  'images/ic_about.png',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 2.5.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 2.5.h,),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        width: 19.0.w,
                                        height: 14.6.h,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40),
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
                                                color: Colors.white,
                                                size: 7.0.w,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () => Navigator.pop(context),
                                    ),
                                    SizedBox(height: 6.7.w,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Bunda yakin ingin keluar?',
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.7.w,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            prefs.setIsSignIn(false);
                                            await auth.signOut();
                                            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                          },
                                          child: Container(
                                            width: 55.6.w,
                                            height: 20.8.w,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).backgroundColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(40),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Keluar',
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
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Keluar',
                                style: TextStyle(
                                  fontSize: 13.0.sp,
                                  color: Theme.of(context).backgroundColor,
                                ),
                              ),
                              Expanded(child: SizedBox(),),
                            ],
                          ),
                        ),
                        Container(
                          height: 2.5.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
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
                      onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
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
                                Icons.close,
                                size: 7.0.w,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Padding(
                      padding: EdgeInsets.only(right: 6.6.w, top: 5.6.h,),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {

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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).shadowColor,
                                          blurRadius: 6.0,
                                          offset: Offset(0,3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 5.6.w,
                                  height: 5.6.w,
                                  child: FittedBox(
                                    child: Image.asset('images/ic_forum_small.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.2.w,),
                          InkWell(
                            onTap: () {
                              prefs.setBackRoute('/profile');
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(Radius.circular(30)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).shadowColor,
                                          blurRadius: 6.0,
                                          offset: Offset(0,3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 5.6.w,
                                  height: 5.6.w,
                                  child: FittedBox(
                                    child: Image.asset('images/ic_menu.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
