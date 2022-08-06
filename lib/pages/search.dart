// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:empat_bulan/main.dart';
import 'package:sizer/sizer.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var keyText = TextEditingController();
  String keySearch = '';
  List dbArticle, dbForum;
  int isNotEmpty = 0;
  int forumNotEmpty = 0;

  Future getSearch() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_search_article.php?keyword=$keySearch');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getForum() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_search_forum.php?keyword=$keySearch');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
    gestures: const [
      GestureType.onTap,
      GestureType.onVerticalDragDown,
    ],
    child: Scaffold(
      body: FutureBuilder(
        future: getForum(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitPulse(
                  color: Theme.of(context).primaryColor,
                ),
              ],
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            dbForum = snapshot.data as List;
          }
          if (keySearch != '' && dbForum.isNotEmpty) {
            forumNotEmpty = 1;
          }
          return FutureBuilder(
            future: getSearch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitPulse(
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                dbArticle = snapshot.data as List;
              }
              if (keySearch != '' && dbArticle.isNotEmpty) {
                isNotEmpty = 1;
              }
              return Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 19.0.h,),
                        forumNotEmpty == 0 ? Container() : Padding(
                          padding: EdgeInsets.only(left: 6.7.w),
                          child: Text(
                            'FORUM',
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                        ),
                        forumNotEmpty == 0 ? Container() : SizedBox(height: 1.8.h,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: dbForum.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            if (keySearch != '') {
                              return Column(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6.7.w, right: 7.2.w,),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                                            child: Container(
                                              color: Theme.of(context).primaryColor,
                                              child: dbForum[index]['photo'] == ''
                                                  ? Image.asset(
                                                'images/no_img.png',
                                                height: 13.3.w,
                                                width: 13.3.w,
                                                fit: BoxFit.cover,
                                              )
                                                  : Image.network(
                                                dbForum[index]['photo'],
                                                height: 13.3.w,
                                                width: 13.3.w,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return SizedBox(
                                                    height: 13.3.w,
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
                                          SizedBox(width: 4.4.w,),
                                          Flexible(
                                            child: Text(
                                              dbForum[index]['title'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
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
                                      prefs.setQuestionId(dbForum[index]['id']);
                                      Navigator.pushNamed(context, '/questionView');
                                    },
                                  ),
                                  SizedBox(height: 2.2.h,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 6.7.w, right: 7.2.w,),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.0.h,),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                        forumNotEmpty == 0 ? Container() : SizedBox(height: 3.8.h,),
                        isNotEmpty == 0 ? Container() : Padding(
                          padding: EdgeInsets.only(left: 6.7.w),
                          child: Text(
                            'ARTIKEL',
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: Theme.of(context).unselectedWidgetColor,
                            ),
                          ),
                        ),
                        isNotEmpty == 0 ? Container() : SizedBox(height: 1.8.h,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: dbArticle.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            if (keySearch != '') {
                              return Column(
                                children: [
                                  InkWell(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 6.7.w, right: 7.2.w,),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                                            child: Container(
                                              color: Theme.of(context).primaryColor,
                                              child: Image.network(
                                                dbArticle[index]['image'],
                                                height: 13.3.w,
                                                width: 13.3.w,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (context, child, loadingProgress) {
                                                  if (loadingProgress == null) return child;
                                                  return SizedBox(
                                                    height: 13.3.w,
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
                                          SizedBox(width: 4.4.w,),
                                          Flexible(
                                            child: Text(
                                              dbArticle[index]['title'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
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
                                      prefs.setArticleId(dbArticle[index]['id']);
                                      Navigator.pushNamed(context, '/viewarticle');
                                    },
                                  ),
                                  SizedBox(height: 2.2.h,),
                                  Padding(
                                    padding: EdgeInsets.only(left: 6.7.w, right: 7.2.w,),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.0.h,),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
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
                  Padding(
                    padding: EdgeInsets.only(left: 22.8.w),
                    child: SizedBox(
                      height: 15.0.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.2.h),
                            child: Container(
                              width: 70.5.w,
                              height: 11.7.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(24)),
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.0.w),
                                    child: Image.asset(
                                      'images/ic_search.png',
                                      height: 5.3.w,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 36.4.w, right: 18.8.w),
                    child: SizedBox(
                      height: 15.0.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.2.h),
                            child: SizedBox(
                              height: 11.7.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextField(
                                    controller: keyText,
                                    onChanged: (String str) {
                                      setState(() {
                                        keySearch = str;
                                        forumNotEmpty = 0;
                                        isNotEmpty = 0;
                                      });
                                    },
                                    autofocus: true,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: 'Cari pertanyaan, artikel',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).toggleableActiveColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  keyText.text == '' ? Container() : SizedBox(
                    height: 15.0.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 11.0.w, bottom: 2.2.h),
                              child: SizedBox(
                                height: 11.7.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          keyText.text = '';
                                          keySearch = '';
                                          forumNotEmpty = 0;
                                          isNotEmpty = 0;
                                        });
                                      },
                                      child: Image.asset(
                                        'images/ic_clear.png',
                                        height: 4.4.w,
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
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
          );
        },
      ),
    ),
  );
}
