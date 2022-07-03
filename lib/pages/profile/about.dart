// @dart=2.9
// import 'dart:math';
// import 'package:empat_bulan/main.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({Key key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  List dbAbout;

  Future getAbout() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/get_about.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: getAbout(),
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
                dbAbout = snapshot.data as List;
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
                          Row(
                            children: [
                              Text(
                                'Tentang Kami',
                                style: TextStyle(
                                  fontSize: 24.0.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.3.h,),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      child: Html(
                        data: dbAbout[0]['content'],
                        style: {
                          'body': Style(
                            fontSize: FontSize.rem(1),
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            padding: const EdgeInsets.all(0),
                            lineHeight: LineHeight.rem(1.1875),
                          ),
                          'h1': Style(
                            color:
                            Theme.of(context).backgroundColor,
                            fontSize: FontSize.rem(1.5),
                            lineHeight: LineHeight.rem(1),
                          ),
                          'h2': Style(
                            color: Theme.of(context).backgroundColor,
                            lineHeight: LineHeight.rem(1),
                          ),
                          'h3': Style(
                              textAlign: TextAlign.right,
                              fontFamily: 'Uthmanic'
                          ),
                          'li': Style(
                            padding: const EdgeInsets.only(left: 0),
                          ),
                          'a': Style(
                            color: Theme.of(context).backgroundColor,
                          ),
                        },
                        onLinkTap: (url, context, attributes,
                            element) async {
                          // ignore: deprecated_member_use
                          if (await canLaunch(url)) {
                            // ignore: deprecated_member_use
                            await launch(
                              url,
                            );
                          } else {
                            throw 'Could not launch &url';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 11.3.h,),
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
      ),
    );
  }
}
