// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:empat_bulan/main.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class Notifications extends StatefulWidget {
  const Notifications({Key key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List dbNotifications;

  Future getNotifications() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/get_notifications.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getNotifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitDoubleBounce(
                  color: Theme.of(context).primaryColor,
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            dbNotifications = snapshot.data as List;
          }
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 6.6.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 19.0.h,),
                          Text(
                            'Notifikasi',
                            style: TextStyle(
                              fontSize: 24.0.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 3.1.h,),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: dbNotifications.length,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 0, left: 6.6.w, right: 6.6.w),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.0.w),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    prefs.setQuestionId(dbNotifications[index]['question']);
                                    Navigator.pushReplacementNamed(context, '/questionView');
                                  },
                                  child: Container(
                                    width: 86.6.w,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        const BorderRadius.all(
                                          Radius.circular(12),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .shadowColor,
                                            blurRadius: 6.0,
                                            offset: const Offset(0, 3),
                                          ),
                                        ]),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(4.4.w, 5.6.w, 4.4.w, 5.6.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    alignment: AlignmentDirectional.center,
                                                    children: [
                                                      Container(
                                                        width: 6.7.w,
                                                        height: 6.7.w,
                                                        decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                          color: Theme.of(context).primaryColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 3.1.w,
                                                        height: 3.1.w,
                                                        child: FittedBox(
                                                          child: Image.asset(
                                                            'images/ic_profile.png',
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(width: 1.4.w,),
                                                  Column(
                                                    children: [
                                                      SizedBox(height: 0.8.w,),
                                                      Text(
                                                        dbNotifications[index]['name'] == '' ? 'Anonymous' : dbNotifications[index]['name'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10.0.sp,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Expanded(child: SizedBox()),
                                                  Text(
                                                    dbNotifications[index]['date'],
                                                    style: TextStyle(
                                                      color: Theme.of(context).unselectedWidgetColor,
                                                      fontSize: 7.0.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 3.3.w,),
                                              Text(
                                                'Menanggapi pertanyaan Anda: "${dbNotifications[index]['title']}"',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.0.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3.3.w,),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 11.3.h,),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
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
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
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
                                  color: Colors.white,
                                  size: 5.2.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
