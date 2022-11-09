import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:empat_bulan/main.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ViewArticle extends StatefulWidget {
  const ViewArticle({Key? key}) : super(key: key);

  @override
  State<ViewArticle> createState() => _ViewArticleState();
}

class _ViewArticleState extends State<ViewArticle> {
  late List dbArticle, dbRelated;

  Future getArticle() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_single_article.php?id=${prefs.getArticleId}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getRelated() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_related_article.php?id=${prefs.getArticleId}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder(
        future: getArticle(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SpinKitPulse(
                  color: Colors.white,
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            dbArticle = snapshot.data as List;
          }
          return FutureBuilder(
              future: getRelated(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SpinKitPulse(
                        color: Colors.white,
                      ),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  dbRelated = snapshot.data as List;
                }
                return Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    Container(
                      height: 100.0.h,
                      color: Theme.of(context).primaryColor,
                      child: Column(
                        children: [
                          Image.network(
                            dbArticle[0]['image'],
                            height: 74.0.h,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15.8.h),
                                    child: const SpinKitPulse(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          Container(
                            height: 26.0.h,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    DraggableScrollableSheet(
                      expand: false,
                      initialChildSize: 0.54,
                      minChildSize: 0.54,
                      maxChildSize: 1.0,
                      builder: (context, scrollController) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            width: 100.0.w,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(56),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 1.7.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8.6.w,
                                      height: 0.5.h,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6.0.h,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.6.w),
                                  child: Text(
                                    dbArticle[0]['title'],
                                    style: TextStyle(
                                      fontSize: 20.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 1.9.h,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                                  child: Html(
                                    data: dbArticle[0]['content'],
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
                                            Theme.of(context).colorScheme.background,
                                        fontSize: FontSize.rem(1.5),
                                        lineHeight: LineHeight.rem(1),
                                      ),
                                      'h2': Style(
                                        color: Theme.of(context).colorScheme.background,
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
                                        color: Theme.of(context).colorScheme.background,
                                      ),
                                    },
                                    onLinkTap: (url, context, attributes,
                                        element) async {
                                      // ignore: deprecated_member_use
                                      if (await canLaunch(url!)) {
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
                                SizedBox(height: 4.4.h,),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.6.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/ic_article_small.png',
                                        height: 3.2.w,
                                      ),
                                      SizedBox(
                                        width: 1.4.w,
                                      ),
                                      Text(
                                        'Artikel lainnya',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 2.8.h,),
                                SizedBox(
                                  height: 66.0.w,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dbRelated.length,
                                    physics: const BouncingScrollPhysics(),
                                    padding: EdgeInsets.only(top: 0, left: 6.6.w, right: 1.1.w),
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                            child: InkWell(
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
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(12),
                                                      ),
                                                      child: Container(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        child: Image.network(
                                                          dbRelated[index]['image'],
                                                          height: 43.0.w,
                                                          width: 86.6.w,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return SizedBox(
                                                              height: 43.0.w,
                                                              child: const Center(
                                                                child:
                                                                    SpinKitPulse(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              3.8.w,
                                                              5.0.w,
                                                              3.8.w,
                                                              5.6.w),
                                                      child: Text(
                                                        dbRelated[index]['title'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0.sp,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                prefs.setArticleId(
                                                    dbRelated[index]['id']);
                                                Navigator.pushNamed(
                                                    context, '/viewarticle');
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 3.9.w,)
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 12.5.h,),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 15.0.h,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    SizedBox(
                                      height: 19.0.w,
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 6.6.w,),
                                        child: InkWell(
                                          onTap: () {
                                            final box = context.findRenderObject() as RenderBox;
                                            Share.share(
                                              dbArticle[0]['share'],
                                              sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
                                            );
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
                                                    borderRadius: const BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        blurRadius: 6.0,
                                                        color: Theme.of(context).shadowColor,
                                                        offset: const Offset(0, 3),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.6.w,
                                                height: 5.6.w,
                                                child: FittedBox(
                                                  child: Image.asset(
                                                    'images/ic_share.png',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
              });
        },
      ),
    );
  }
}
