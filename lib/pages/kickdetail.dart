import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:empat_bulan/pages/db/kick_db.dart';

class KickDetail extends StatefulWidget {
  const KickDetail({Key? key}) : super(key: key);

  @override
  State<KickDetail> createState() => _KickDetailState();
}

class _KickDetailState extends State<KickDetail> {
  late List dbList;
  var dbKick = KickDb();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: dbKick.list(prefs.getKickDay),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
            return
              SizedBox(
                  width: 100.0.w,
                  height: 100.0.h,
                  child: Center(
                      child: SpinKitDoubleBounce(
                        color: Theme.of(context).primaryColor,
                      )
                  )
              );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            dbList = snapshot.data as List;
          }
          return Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7.0.w,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 19.0.h,),
                      Text(
                        'Detail Tendangan',
                        style: TextStyle(
                          fontSize: 24.0.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.0.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/ic_contractions_small.png',
                            height: 3.3.w,
                          ),
                          SizedBox(width: 1.4.w,),
                          Padding(
                            padding: EdgeInsets.only(top: 1.6.w),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  fontFamily: 'Josefin Sans',
                                  fontWeight: FontWeight.w700,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Tendangan yang dirasakan pada ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: dbList[0]['kickdate'],
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.4.h,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.0.w,),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 18.0.w,
                              child: Text(
                                'Waktu',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10.0.sp,
                                ),
                              ),
                            ),
                            Text(
                              'Gerakan',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10.0.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.1.h,),
                      SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dbList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(3.3.w, 0, 3.3.w, 4.4.w),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 18.0.w,
                                          child: Text(
                                            dbList[index]['time'].toString().substring(
                                                dbList[index]['time'].toString().length - 8,
                                                dbList[index]['time'].toString().length),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0.sp,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 58.0.w,
                                          child: Text(
                                            dbList[index]['move'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0.sp,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1.7.w,
                                          height: 1.7.w,
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(dbList[index]['color'])),
                                            borderRadius: const BorderRadius.all(Radius.circular(100)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.4.w),
                              ],
                            );
                          },
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
            ],
          );
        },
      ),
    );
  }
}