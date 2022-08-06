// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:empat_bulan/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class QuestionView extends StatefulWidget {
  const QuestionView({Key key}) : super(key: key);

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  List dbQuestion, dbReply;
  var comment = TextEditingController();
  final picker = ImagePicker();
  File img;
  int numLines = 0;

  Future getQuestion() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_single_question.php?id=${prefs.getQuestionId}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getReply(String id) async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_reply.php?id=$id');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future pickImg() async {
    var picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 3000,
      maxWidth: 3000,
      imageQuality: 100,
    );
    setState(() {
      img = File(picked.path);
    });
  }

  Future addReply(int readed) async {
    var url = Uri.parse('https://app.empatbulan.com/api/add_reply.php');
    var req = http.MultipartRequest('POST', url);
    req.fields['phone'] = prefs.getPhone;
    req.fields['question'] = prefs.getQuestionId;
    req.fields['comment'] = comment.text;
    req.fields['date'] = DateFormat('d MMM yyyy HH:mm', 'id_ID').format(DateTime.now());
    req.fields['readed'] = readed.toString();
    if (img != null) {
      var pic = await http.MultipartFile.fromPath('image', img.path);
      req.files.add(pic);
    }
    var response = await req.send();
    // ignore: use_build_context_synchronously
    if (response.statusCode == 200) {
      setState(() {
        img = null;
        comment.text = '';
        FocusManager.instance.primaryFocus?.unfocus();
      });
    }
  }

  Future updRead() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_read_notification.php?id=${prefs.getQuestionId}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    updRead();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (prefs.getBackRoute == '/home') {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
        }
        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: getQuestion(),
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
              dbQuestion = snapshot.data as List;
            }
            return FutureBuilder(
              future: getReply(prefs.getQuestionId),
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
                  dbReply = snapshot.data as List;
                }
                return Stack(
                  children: [
                    SingleChildScrollView(
                      reverse: true,
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
                                  'Forum',
                                  style: TextStyle(
                                    fontSize: 24.0.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 1.9.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/ic_forum_small.png',
                                      height: 3.3.w,
                                    ),
                                    SizedBox(width: 1.4.w,),
                                    Text(
                                      'Ada persoalan? Diskusikan dengan pengguna lain',
                                      style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 3.1.h,),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: dbQuestion.length,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 0, left: 6.6.w, right: 6.6.w),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 1.0.w),
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
                                        dbQuestion[index]['photo'] == '' ? Container() : ClipRRect(
                                          borderRadius:
                                          const BorderRadius.only(
                                            topLeft:
                                            Radius.circular(12),
                                            topRight:
                                            Radius.circular(12),
                                          ),
                                          child: Container(
                                            color: Theme.of(context).primaryColor,
                                            child: Image.network(
                                              dbQuestion[index]['photo'],
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
                                                    SpinKitDoubleBounce(
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
                                          padding: EdgeInsets.fromLTRB(4.4.w, 5.6.w, 4.4.w, 5.6.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    dbQuestion[index]['date'],
                                                    style: TextStyle(
                                                      color: Theme.of(context).unselectedWidgetColor,
                                                      fontSize: 7.0.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 1.1.w,),
                                              Text(
                                                dbQuestion[index]['title'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.0.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(height: 2.8.w,),
                                              Text(
                                                dbQuestion[index]['description'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.0.sp,
                                                ),
                                              ),
                                              SizedBox(height: 3.3.w,),
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
                                                        dbQuestion[index]['name'] == '' ? 'Anonymous' : dbQuestion[index]['name'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10.0.sp,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Expanded(child: SizedBox()),
                                                  FutureBuilder(
                                                    future: getReply(dbQuestion[index]['id']),
                                                    builder: (context, snapshot) {
                                                      if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                                                        return Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SpinKitThreeBounce(
                                                              color: Theme.of(context).primaryColor,
                                                              size: 16,
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      if (snapshot.connectionState == ConnectionState.done) {
                                                        dbReply = snapshot.data as List;
                                                      }
                                                      return dbReply.isEmpty ? Container() : Text(
                                                        '${dbReply.length.toString()} Tanggapan',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10.0.sp,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 2.5.h,),
                          dbReply.isEmpty ? Container() : Column(
                            children: [
                              SizedBox(height: 1.9.h,),
                              Padding(
                                padding: EdgeInsets.only(left: 6.7.w,),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'images/ic_forum_small.png',
                                      height: 3.3.w,
                                    ),
                                    SizedBox(width: 1.4.w,),
                                    Text(
                                      'Tanggapan',
                                      style: TextStyle(
                                        fontSize: 10.0.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.9.h,),
                              SizedBox(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: dbReply.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(top: 0, left: 6.6.w, right: 6.6.w),
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 1.0.w),
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
                                                                dbReply[index]['name'] == '' ? 'Anonymous' : dbReply[index]['name'],
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
                                                            dbReply[index]['date'],
                                                            style: TextStyle(
                                                              color: Theme.of(context).unselectedWidgetColor,
                                                              fontSize: 7.0.sp,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 3.3.w,),
                                                      Text(
                                                        dbReply[index]['comment'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                dbReply[index]['photo'] == '' ? Container() : ClipRRect(
                                                  borderRadius:
                                                  const BorderRadius.only(
                                                    bottomLeft: Radius.circular(12),
                                                    bottomRight: Radius.circular(12),
                                                  ),
                                                  child: Container(
                                                    color: Theme.of(context).primaryColor,
                                                    child: Image.network(
                                                      dbReply[index]['photo'],
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
                                                            SpinKitDoubleBounce(
                                                              color: Colors
                                                                  .white,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 2.5.h,),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: img != null ? 24.8.h : 13.5.h,),
                          SizedBox(height: numLines == 2 ? 3.1.h : 0,),
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
                                if (prefs.getBackRoute == '/home') {
                                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
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
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 5.6.h,),
                                Padding(
                                  padding: EdgeInsets.only(right: 6.6.w,),
                                  child: InkWell(
                                    onTap: () {
                                      if (!prefs.getIsSignIn) {
                                        prefs.setGoRoute('/newquestion');
                                        Navigator.pushNamed(context, '/register');
                                      } else {
                                        Navigator.pushReplacementNamed(context, '/newquestion');
                                      }
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
                                              'images/ic_plus.png',
                                            ),
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
                        const Expanded(child: SizedBox()),
                        Container(
                          width: 100.0.w,
                          constraints: const BoxConstraints(
                            maxHeight: double.infinity,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 8.0,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              img != null
                                  ? Container(
                                width: 100.0.w,
                                height: 20.0.w,
                                color: const Color(0x40C09AC7),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 6.7.w, bottom: 4.4.w),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Image.asset(
                                            'images/ic_image_black.png',
                                            height: 6.7.w,
                                          ),
                                          SizedBox(width: 3.3.w,),
                                          Text(
                                            'Foto',
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Container(
                                      width: 20.0.w,
                                      height: 20.0.w,
                                      color: Theme.of(context).backgroundColor,
                                      child: Image.file(
                                        img,
                                        height: 20.0.w,
                                        width: 20.0.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : Container(),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.4.w, horizontal: 6.7.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 2.5.w,),
                                      child: InkWell(
                                        onTap: () {
                                          if (!prefs.getIsSignIn) {
                                            prefs.setGoRoute('/questionView');
                                            Navigator.pushNamed(context, '/register');
                                          } else {
                                            pickImg();
                                          }
                                        },
                                        child: Image.asset(
                                          'images/ic_image.png',
                                          height: 6.7.w,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6.7.w,),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (!prefs.getIsSignIn) {
                                            prefs.setGoRoute('/questionView');
                                            Navigator.pushNamed(context, '/register');
                                          }
                                        },
                                        child: Container(
                                          constraints: const BoxConstraints(
                                            maxHeight: double.infinity,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: const BorderRadius.all(Radius.circular(24)),
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 4.4.w, right: 15.6.w),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(height: 3.3.w,),
                                                InkWell(
                                                  onTap: () {
                                                    if (!prefs.getIsSignIn) {
                                                      prefs.setGoRoute('/questionView');
                                                      Navigator.pushNamed(context, '/register');
                                                    }
                                                  },
                                                  child: TextField(
                                                    controller: comment,
                                                    onChanged: (String str) {
                                                      if (str != '') {
                                                        // setState(() {
                                                        //   numLines = '\n'.allMatches(str).length + 1;
                                                        // });
                                                      }
                                                    },
                                                    minLines: 1,
                                                    maxLines: 6,
                                                    keyboardType: TextInputType.multiline,
                                                    textCapitalization: TextCapitalization.sentences,
                                                    enabled: prefs.getIsSignIn ? true : false,
                                                    cursorColor: Colors.black,
                                                    style: TextStyle(
                                                      fontSize: 13.0.sp,
                                                      height: 1.2,
                                                    ),
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.zero,
                                                      border: InputBorder.none,
                                                      focusedBorder: InputBorder.none,
                                                      hintText: 'Aa',
                                                      hintStyle: TextStyle(
                                                        color: Theme.of(context).toggleableActiveColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 3.3.w,),
                                              ],
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
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10.0.w, bottom: 8.4.w,),
                              child: InkWell(
                                onTap: () {
                                  if (!prefs.getIsSignIn) {
                                    prefs.setGoRoute('/questionView');
                                    Navigator.pushNamed(context, '/register');
                                  } else {
                                    if (prefs.getPhone == dbQuestion[0]['telp']) {
                                      addReply(1);
                                    } else {
                                      addReply(0);
                                    }
                                  }
                                },
                                child: Image.asset(
                                  'images/ic_send.png',
                                  height: 4.8.w,
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
}
