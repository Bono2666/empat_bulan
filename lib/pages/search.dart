import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:empat_bulan/main.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;

late int classId;

class Search extends StatefulWidget {
  final String _type;
  const Search({Key? key, required String type}) : _type = type, super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<Search> createState() => _SearchState(type: _type);
}

class _SearchState extends State<Search> {
  var keyText = TextEditingController();
  String keySearch = '';
  late List dbArticle, dbForum, dbServices;
  int isNotEmpty = 0;
  int forumNotEmpty = 0;
  int serviceNotEmpty = 0;
  final String _type;

  _SearchState({required String type}) : _type = type;

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

  Future getServices() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_search_services.php?keyword=$keySearch');
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
                SpinKitDoubleBounce(
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
                    SpinKitDoubleBounce(
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
              return FutureBuilder(
                future: getServices(),
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
                    dbServices = snapshot.data as List;
                  }
                  if (keySearch != '' && dbServices.isNotEmpty) {
                    serviceNotEmpty = 1;
                  }
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 19.0.h,),
                            _type == 'layanan' ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                serviceNotEmpty == 0 ? Container() : Padding(
                                  padding: EdgeInsets.only(left: 6.7.w),
                                  child: Text(
                                    'LAYANAN',
                                    style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: Theme.of(context).unselectedWidgetColor,
                                    ),
                                  ),
                                ),
                                serviceNotEmpty == 0 ? Container() : SizedBox(height: 1.8.h,),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: dbServices.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(top: 0),
                                  itemBuilder: (context, index) {
                                    if (keySearch != '') {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              classId = int.parse(dbServices[index]['id']);
                                              showModalBottomSheet(
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(40),
                                                    topRight: Radius.circular(40),
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                                constraints: BoxConstraints(
                                                  minHeight: 165.0.w,
                                                  maxHeight: 165.0.w,
                                                ),
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) {
                                                  return const ViewClass();
                                                },
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 6.7.w, right: 7.2.w,),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                    child: Container(
                                                      color: Theme.of(context).primaryColor,
                                                      child: dbServices[index]['image'] == ''
                                                          ? Image.asset(
                                                        'images/no_img.png',
                                                        height: 13.3.w,
                                                        width: 13.3.w,
                                                        fit: BoxFit.cover,
                                                      )
                                                          : Image.network(
                                                        dbServices[index]['image'],
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
                                                      dbServices[index]['title'],
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
                            ) : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                                          : SizedBox(
                                                        height: 13.3.w,
                                                        width: 13.3.w,
                                                        child: Stack(
                                                          fit: StackFit.expand,
                                                          children: [
                                                            Image.network(
                                                              dbForum[index]['photo'],
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
                                                            dbForum[index]['sensitif'] == '0' ? Container() : BackdropFilter(
                                                              filter: ImageFilter.blur(
                                                                sigmaX: 10,
                                                                sigmaY: 10,
                                                              ),
                                                              child: Container(
                                                                color: Theme.of(context).colorScheme.background.withOpacity(0.8),
                                                                child: Center(
                                                                  child: SizedBox(
                                                                    width: 5.2.w,
                                                                    child: FittedBox(
                                                                      child: Image.asset(
                                                                        'images/ic_sensitive.png',
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                              prefs.setBackRoute('/home');
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
                                          hintText: _type == 'layanan' ? 'Layanan yang dicari?' : 'Cari pertanyaan, artikel',
                                          hintStyle: TextStyle(
                                            // ignore: deprecated_member_use
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
                                onTap: () {
                                  if (prefs.getBackRoute == '/homeServices') {
                                    Navigator.pushNamedAndRemoveUntil(context, prefs.getBackRoute, (route) => true);
                                  } else {
                                    Navigator.pop(context);
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
          );
        },
      ),
    ),
  );
}

class ViewClass extends StatefulWidget {
  const ViewClass({Key? key}) : super(key: key);

  @override
  State<ViewClass> createState() => _ViewClassState();
}

class _ViewClassState extends State<ViewClass> {
  late List dbSingle, dbSingleCart;
  late DateTime classDate;

  Future getSingleClass() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_single_class.php?id=$classId');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getSingleCart() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_single_cart.php?phone=${prefs.getPhone}&class_id=$classId');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future addCart() async {
    var url = 'https://app.empatbulan.com/api/add_cart.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'class_id' : classId.toString(),
    });
  }

  Future updSelectedClass(int id, int selected) async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_selected_class.php?id=$id&selected=$selected');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSingleClass(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SpinKitDoubleBounce(
                color: Colors.white,
              ),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          dbSingle = snapshot.data as List;

          classDate = DateTime(
              int.parse(dbSingle[0]['date'].substring(0, 4)),
              int.parse(dbSingle[0]['date'].substring(5, 7)),
              int.parse(dbSingle[0]['date'].substring(8, 10))
          );
        }
        return FutureBuilder(
          future: getSingleCart(),
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
              dbSingleCart = snapshot.data as List;
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        height: 66.7.w,
                        child: Image.network(
                          dbSingle[0]['image'],
                          width: 100.0.w,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: 66.7.w,
                              child: const Center(
                                child: SpinKitPulse(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 19.0.w,
                        height: 14.6.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                        ),
                        child: Stack(
                          alignment:
                          AlignmentDirectional.bottomCenter,
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
                    ),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: 98.0.w,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.9.w,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 11.7.w,),
                              Text(
                                '${DateFormat('d MMM yyyy', 'id_ID').format(classDate)} ${dbSingle[0]['time']}',
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.background,
                                ),
                              ),
                              SizedBox(height: 2.2.w,),
                              Text(
                                dbSingle[0]['title'],
                                style: TextStyle(
                                  fontSize: 23.0.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 2.2.w,),
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
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontFamily: 'Josefin Sans',
                                            color: Colors.black,
                                            fontSize: 9.6.sp,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: 'Instruktur',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' | ${dbSingle[0]['instructur']}',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.2.w,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 1.4.w,),
                                    child: Text(
                                      NumberFormat.currency(
                                        locale: 'id',
                                        symbol: 'Rp ',
                                        decimalDigits: 0,
                                      ).format(int.parse(dbSingle[0]['total_price'])),
                                      style: TextStyle(
                                        fontSize: 17.0.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1.1.w,),
                                  dbSingle[0]['discount'] == '0' ? Container() : Padding(
                                    padding: EdgeInsets.only(top: 1.4.w,),
                                    child: StrikeThrough(
                                      child: Text(
                                        NumberFormat.currency(
                                          locale: 'id',
                                          symbol: 'Rp ',
                                          decimalDigits: 0,
                                        ).format(int.parse(dbSingle[0]['price'])),
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).unselectedWidgetColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Expanded(child: SizedBox(),),
                                  Container(
                                    width: 24.4.w,
                                    height: 5.8.w,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                      color: Theme.of(context).colorScheme.background,
                                    ),
                                    child: Center(
                                      child: Text(
                                        dbSingle[0]['type'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8.0.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.6.w,),
                              Html(
                                data: dbSingle[0]['description'],
                                style: {
                                  'body': Style(
                                    color: Colors.black,
                                    fontSize: FontSize(12.0.sp),
                                    margin: const EdgeInsets.all(0),
                                  )
                                },
                              ),
                              SizedBox(height: 35.6.w,),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          height: 16.4.w,
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
                        SizedBox(height: 47.5.w,),
                        Visibility(
                          visible: classDate.compareTo(DateTime.now()) <= 0 ? false : true,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                height: 34.4.w,
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
                              InkWell(
                                onTap: () async {
                                  if (dbSingleCart.isEmpty) {
                                    addCart();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'Kelas telah dimasukkan ke Keranjang.',
                                          style: TextStyle(
                                            fontFamily: 'Josefin Sans',
                                          ),
                                        ),
                                        backgroundColor: Theme.of(context).colorScheme.background,
                                      ),
                                    );
                                  }
                                  prefs.setBackRoute('/classes');
                                  await Navigator.pushNamed(context, '/cart');
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.centerEnd,
                                  children: [
                                    Container(
                                      width: 38.6.w,
                                      height: 20.8.w,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    SizedBox(
                                      width: 27.8.w,
                                      child: Center(
                                        child: Text(
                                          'Pesan',
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
                                  onTap: () async {
                                    if (dbSingleCart.isEmpty) {
                                      addCart();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Kelas telah dimasukkan ke Keranjang.',
                                            style: TextStyle(
                                              fontFamily: 'Josefin Sans',
                                            ),
                                          ),
                                          backgroundColor: Theme.of(context).colorScheme.background,
                                        ),
                                      );
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 55.6.w,
                                    height: 20.8.w,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.background,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Tambah ke Keranjang',
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
    );
  }
}

class StrikeThrough extends StatelessWidget {
  final Widget _child;

  const StrikeThrough({Key? key, required Widget child}) : _child = child, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/line_through.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: _child,
    );
  }
}