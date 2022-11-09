import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:empat_bulan/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class QuestionView extends StatefulWidget {
  const QuestionView({Key? key}) : super(key: key);

  @override
  State<QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  late List dbQuestion, dbReply;
  var comment = TextEditingController();
  final picker = ImagePicker();
  File? img;
  int numLines = 0;
  int sensitif = 0;
  bool isSensitive = false;

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
      maxHeight: 600,
      maxWidth: 800,
      imageQuality: 50,
    );
    setState(() {
      img = File(picked!.path);
    });
  }

  Future addReply(int readed) async {
    var url = Uri.parse('https://app.empatbulan.com/api/add_reply.php');
    var req = http.MultipartRequest('POST', url);
    req.fields['phone'] = prefs.getPhone;
    req.fields['question'] = prefs.getQuestionId;
    req.fields['comment'] = comment.text;
    req.fields['sensitif'] = sensitif.toString();
    req.fields['date'] = DateFormat('d MMM yyyy HH:mm', 'id_ID').format(DateTime.now());
    req.fields['readed'] = readed.toString();
    if (img != null) {
      var pic = await http.MultipartFile.fromPath('image', img!.path);
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
    var url = Uri.parse('https://app.empatbulan.com/api/upd_read_notification.php?id=${prefs.getQuestionId}&phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updDeletedReply(String id) async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_deleted_reply.php?id=$id');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future delQuestion() async {
    var url = 'https://app.empatbulan.com/api/del_question.php';
    await http.post(Uri.parse(url), body: {
      'id' : prefs.getQuestionId,
    });
    var url2 = 'https://app.empatbulan.com/api/del_reply.php';
    await http.post(Uri.parse(url2), body: {
      'id' : prefs.getQuestionId,
    });
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
                                    Padding(
                                      padding: EdgeInsets.only(top: 1.0.w,),
                                      child: Text(
                                        'Ada persoalan? Diskusikan dengan pengguna lain',
                                        style: TextStyle(
                                          fontSize: 10.0.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
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
                                        dbQuestion[index]['photo'] == '' ? Container() : SizedBox(
                                          height: 43.0.w,
                                          width: 86.6.w,
                                          child: ClipRRect(
                                            borderRadius:
                                            const BorderRadius.only(
                                              topLeft:
                                              Radius.circular(12),
                                              topRight:
                                              Radius.circular(12),
                                            ),
                                            child: Container(
                                              color: Theme.of(context).primaryColor,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  Image.network(
                                                    dbQuestion[index]['photo'],
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
                                                  dbQuestion[index]['sensitif'] == '0' ? Container() : const Blur(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(4.4.w, 5.6.w, 4.4.w, 5.6.w),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    dbQuestion[index]['date'],
                                                    style: TextStyle(
                                                      color: Theme.of(context).unselectedWidgetColor,
                                                      fontSize: 7.0.sp,
                                                    ),
                                                  ),
                                                  const Expanded(child: SizedBox()),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => const Report(replyId: '0',),
                                                        barrierDismissible: false,
                                                      );
                                                    },
                                                    child: SizedBox(
                                                      width: 4.4.w,
                                                      height: 4.4.w,
                                                      child: FittedBox(
                                                        child: Image.asset(
                                                          'images/ic_flag.png',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 4.4.w,),
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
                                                      ),
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
                                    return Dismissible(
                                      key: Key(dbReply[index].toString()),
                                      confirmDismiss: (direction) async {
                                        if (dbReply[index]['telp'] == prefs.getPhone) {
                                          showModalBottomSheet(
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(40),
                                                topRight: Radius.circular(40),
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                            builder: (context) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .end,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets
                                                        .symmetric(
                                                      horizontal: 7.8.w,),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 11.1.w,),
                                                        Text(
                                                          'Hapus komentar ini?',
                                                          style: TextStyle(
                                                            fontSize: 23.0.sp,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .w700,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 3.9.w,),
                                                        Text(
                                                          "Setelah menghapus komentar ini, Bunda tidak dapat "
                                                              "mengembalikannya seperti semula.",
                                                          style: TextStyle(
                                                            fontSize: 13.0.sp,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 8.9.w,),
                                                      ],
                                                    ),
                                                  ),
                                                  Stack(
                                                    alignment: AlignmentDirectional.bottomEnd,
                                                    children: [
                                                      InkWell(
                                                        onTap: () async {
                                                          updDeletedReply(dbReply[index]['id']);
                                                          dbReply.removeAt(index);
                                                          Navigator.pop(context);
                                                          setState(() {});
                                                        },
                                                        child: Stack(
                                                          alignment: AlignmentDirectional
                                                              .centerEnd,
                                                          children: [
                                                            Container(
                                                              width: 45.0.w,
                                                              height: 20.8.w,
                                                              color: Theme
                                                                  .of(context)
                                                                  .primaryColor,
                                                            ),
                                                            SizedBox(
                                                              width: 34.4.w,
                                                              child: Center(
                                                                child: Text(
                                                                  'Ya',
                                                                  style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    fontSize: 13.0
                                                                        .sp,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            right: 34.4.w),
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            width: 40.0.w,
                                                            height: 20.8.w,
                                                            decoration: BoxDecoration(
                                                              color: Theme
                                                                  .of(context)
                                                                  .colorScheme
                                                                  .background,
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                    40),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                    40),
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'Tidak',
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight: FontWeight
                                                                      .w500,
                                                                  fontSize: 13.0
                                                                      .sp,
                                                                ),
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
                                        }
                                        return null;
                                      },
                                      child: Column(
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
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context: context,
                                                                  builder: (context) => Report(replyId: dbReply[index]['id'],),
                                                                  barrierDismissible: false,
                                                                );
                                                              },
                                                              child: SizedBox(
                                                                width: 2.8.w,
                                                                height: 2.8.w,
                                                                child: FittedBox(
                                                                  child: Image.asset(
                                                                    'images/ic_flag.png',
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 3.3.w,),
                                                        dbReply[index]['deleted'] == '1'
                                                            ? Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            SizedBox(width: 1.4.w,),
                                                            Image.asset(
                                                              'images/ic_del_msg.png',
                                                              height: 4.4.w,
                                                            ),
                                                            SizedBox(width: 2.4.w,),
                                                            Padding(
                                                              padding: EdgeInsets.only(top: 1.2.w,),
                                                              child: Text(
                                                                'Pesan ini telah dihapus',
                                                                style: TextStyle(
                                                                  fontSize: 13.0.sp,
                                                                  color: Theme.of(context).unselectedWidgetColor,
                                                                  fontStyle: FontStyle.italic,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                            : Text(
                                                          dbReply[index]['comment'],
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0.sp,
                                                          ),
                                                        ),
                                                        SizedBox(height: 3.3.w,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Text(
                                                              dbReply[index]['date'],
                                                              style: TextStyle(
                                                                color: Theme.of(context).unselectedWidgetColor,
                                                                fontSize: 7.0.sp,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  dbReply[index]['photo'] == ''
                                                      ? Container()
                                                      : dbReply[index]['deleted'] == '1'
                                                      ? Container()
                                                      : SizedBox(
                                                    height: 43.0.w,
                                                    width: 86.6.w,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      const BorderRadius.only(
                                                        bottomLeft: Radius.circular(12),
                                                        bottomRight: Radius.circular(12),
                                                      ),
                                                      child: Container(
                                                        color: Theme.of(context).primaryColor,
                                                        child: Stack(
                                                          fit: StackFit.expand,
                                                          children: [
                                                            Image.network(
                                                              dbReply[index]['photo'],
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
                                                            dbReply[index]['sensitif'] == '0' ? Container() : const Blur()
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 2.5.h,),
                                        ],
                                      ),
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
                            Visibility(
                              visible: dbQuestion[0]['telp'] == prefs.getPhone ? true : false,
                              child: Column(
                                children: [
                                  SizedBox(height: 5.6.h,),
                                  Padding(
                                    padding: EdgeInsets.only(right: 2.2.w,),
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40),
                                              topRight: Radius.circular(40),
                                            ),
                                          ),
                                          backgroundColor: Colors.white,
                                          builder: (context) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 7.8.w,),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(height: 11.1.w,),
                                                      Text(
                                                        'Hapus pertanyaan dari Forum?',
                                                        style: TextStyle(
                                                          fontSize: 23.0.sp,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                      SizedBox(height: 3.9.w,),
                                                      Text(
                                                        "Jika Bunda menghapus pertanyaan ini, maka seluruh diskusi "
                                                            "terkait pertanyaan ini akan dihapus.",
                                                        style: TextStyle(
                                                          fontSize: 13.0.sp,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(height: 8.9.w,),
                                                    ],
                                                  ),
                                                ),
                                                Stack(
                                                  alignment: AlignmentDirectional.bottomEnd,
                                                  children: [
                                                    InkWell(
                                                      onTap: () async {
                                                        delQuestion();
                                                        await Navigator.pushReplacementNamed(context, '/questionsList');
                                                      },
                                                      child: Stack(
                                                        alignment: AlignmentDirectional.centerEnd,
                                                        children: [
                                                          Container(
                                                            width: 45.0.w,
                                                            height: 20.8.w,
                                                            color: Theme
                                                                .of(context)
                                                                .primaryColor,
                                                          ),
                                                          SizedBox(
                                                            width: 34.4.w,
                                                            child: Center(
                                                              child: Text(
                                                                'Ya',
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
                                                      padding: EdgeInsets.only(right: 34.4.w),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          width: 40.0.w,
                                                          height: 20.8.w,
                                                          decoration: BoxDecoration(
                                                            color: Theme
                                                                .of(context)
                                                                .colorScheme.background,
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(40),
                                                              bottomRight: Radius.circular(40),
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Tidak',
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
                                              ],
                                            );
                                          },
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
                                                'images/ic_delete.png',
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
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 6.7.w, bottom: 4.4.w),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Foto',
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 1.0.w,),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    if (isSensitive) {
                                                      isSensitive = false;
                                                      sensitif = 0;
                                                    } else {
                                                      isSensitive = true;
                                                      sensitif = 1;
                                                    }
                                                  });
                                                },
                                                child: Image.asset(
                                                  isSensitive ? 'images/ic_picked.png' : 'images/ic_unpicked.png',
                                                  height: 5.6.w,
                                                ),
                                              ),
                                              SizedBox(width: 2.2.w,),
                                              Padding(
                                                padding: EdgeInsets.only(top: 1.0.w),
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                      fontSize: 10.0.sp,
                                                      fontFamily: 'Josefin Sans',
                                                    ),
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Tandai sebagai ',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'Konten-Sensitif',
                                                        style: TextStyle(
                                                          color: Theme.of(context).colorScheme.background,
                                                          fontWeight: FontWeight.w700,
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
                                    const Expanded(child: SizedBox()),
                                    Container(
                                      width: 20.0.w,
                                      height: 20.0.w,
                                      color: Theme.of(context).colorScheme.background,
                                      child: Image.file(
                                        img!,
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
                                                        // ignore: deprecated_member_use
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

class Report extends StatefulWidget {
  final String _replyId;
  const Report({Key? key, required String replyId}) : _replyId = replyId, super(key: key);

  @override
  // ignore: no_logic_in_create_state
  ReportState createState() => ReportState(replyId: _replyId);
}

class ReportState extends State<Report>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  late List dbReport;
  late String selectedReport;
  final String _replyId;

  ReportState({required String replyId}) : _replyId = replyId;

  Future getMasterReport() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_master_report.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future addReport(String masterReport, String questionId, int replyId) async {
    var url = Uri.parse('https://app.empatbulan.com/api/add_report.php');
    await http.post(url, body: {
      'master_report' : masterReport,
      'question_id' : questionId,
      'reply_id' : _replyId,
    });
    showDialog(
      context: context,
      builder: (_) => const Info(),
      barrierDismissible: false,
    );
  }

  @override
  void initState() {
    super.initState();

    selectedReport = '';

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMasterReport(),
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
          dbReport = snapshot.data as List;
        }
        return ScaleTransition(
          scale: scaleAnimation,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 91.0.w,
                  height: 88.0.h,
                  constraints: BoxConstraints(
                    minHeight: 24.0.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        blurRadius: 24,
                        offset: const Offset(0, 24),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 14.6.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'images/ic_flag.png',
                                        height: 3.3.w,
                                      ),
                                      SizedBox(width: 1.4.w,),
                                      Padding(
                                        padding: EdgeInsets.only(top: 0.4.w),
                                        child: Text(
                                          'Laporan pengguna',
                                          style: TextStyle(
                                            fontSize: 10.0.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.1.h,),
                                  Row(
                                    children: [
                                      Text(
                                        'Apa masalahnya?',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24.0.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1.5.h,),
                                ],
                              ),
                            ),
                            ListView.builder(
                              itemCount: dbReport.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(left: 5.2.w, right: 5.2.w, bottom: 3.8.h),
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedReport = dbReport[index]['id'];
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(height: 4.4.w,),
                                      Padding(padding: EdgeInsets.only(right: 1.6.w),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                child: Html(
                                                  data: dbReport[index]['desc'],
                                                  style: {
                                                    'body': Style(
                                                      fontSize: FontSize(17.0.sp),
                                                      color: Colors.black,
                                                      padding: const EdgeInsets.all(0),
                                                    ),
                                                  },
                                                ),
                                              ),
                                            ),
                                            Image.asset(
                                              dbReport[index]['id'] == selectedReport
                                                  ? 'images/ic_checked.png'
                                                  : 'images/ic_unchecked.png',
                                              height: 8.9.w,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4.4.w,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 1.6.w),
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
                                    ],
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                              child: Text(
                                'Perkataan atau gambar yang ditandai akan ditinjau oleh admin EmpatBulan '
                                    'selama 1 x 24 jam untuk menentukan apakah hal tersebut melanggar Aturan Penggunaan. '
                                    'Pengguna yang dikenakan sanksi karena pelanggaran Aturan Penggunaan dan pelanggaran '
                                    'serius atau berulang dapat menyebabkan pemblokiran akun.',
                                style: TextStyle(
                                  fontSize: 10.0.sp,
                                  color: Colors.black,
                                  height: 1.2,
                                ),
                              ),
                            ),
                            SizedBox(height: 14.0.h,),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 11.0.h,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(40),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.white,
                                            Colors.white.withOpacity(0.0),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      width: 19.0.w,
                                      height: 11.0.h,
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
                            ],
                          ),
                          const Expanded(child: SizedBox()),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 12.0.h,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(
                                          bottom: Radius.circular(40),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                            Colors.white,
                                            Colors.white.withOpacity(0.0),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  addReport(selectedReport, prefs.getQuestionId, 0);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 55.6.w,
                                  height: 12.0.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.background,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      bottomRight: Radius.circular(40),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Laporkan',
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.elasticInOut,
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84.0.w,
              constraints: BoxConstraints(
                minHeight: 24.4.w,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(40),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor,
                    blurRadius: 24,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 13.3.w,),
                        Text(
                          'Laporan Diterima',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 4.4.w,),
                        Text(
                          'Terima kasih telah ikut berpartisipasi menjaga forum EmpatBulan sebagai media komunikasi '
                              'Ibu Hamil dan Balita yang kondusif dan aman bagi kita bersama.\n\nInsya Allah '
                              'admin EmpatBulan akan meninjau laporan Bunda selama 1 x 24 jam untuk menentukan '
                              'apakah hal tersebut melanggar Aturan Penggunaan.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0.sp,
                            height: 1.2,
                          ),
                        ),
                        // SizedBox(height: 6.7.w,),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 28.0.w,
                              height: 20.0.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Ok',
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
          ],
        ),
      ),
    );
  }
}
