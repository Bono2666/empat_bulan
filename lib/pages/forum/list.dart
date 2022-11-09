import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:empat_bulan/main.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class QuestionsList extends StatefulWidget {
  const QuestionsList({Key? key}) : super(key: key);

  @override
  State<QuestionsList> createState() => _QuestionsListState();
}

class _QuestionsListState extends State<QuestionsList> {
  late List dbQuestions, dbReply;

  Future getQuestion() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_questions.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getReply(String id) async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_reply.php?id=$id');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            dbQuestions = snapshot.data as List;
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
                        children: [
                          SizedBox(height: 19.0.h,),
                          Text(
                            'Pertanyaan Bunda',
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
                    dbQuestions.isNotEmpty
                        ? SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: dbQuestions.length,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 0, left: 6.6.w, right: 6.6.w),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                child: InkWell(
                                  onTap: () async {
                                    prefs.setQuestionId(dbQuestions[index]['id']);
                                    Navigator.pushNamed(context, '/questionView');
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
                                        dbQuestions[index]['photo'] == '' ? Container() : ClipRRect(
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
                                              dbQuestions[index]['photo'],
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
                                                    dbQuestions[index]['date'],
                                                    style: TextStyle(
                                                      color: Theme.of(context).unselectedWidgetColor,
                                                      fontSize: 7.0.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 1.1.w,),
                                              Text(
                                                dbQuestions[index]['title'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.0.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              SizedBox(height: 2.8.w,),
                                              Text(
                                                dbQuestions[index]['description'],
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
                                                        dbQuestions[index]['name'] == '' ? 'Anonymous' : dbQuestions[index]['name'],
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
                                                    future: getReply(dbQuestions[index]['id']),
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
                                ),
                              ),
                              SizedBox(height: 2.5.h,),
                            ],
                          );
                        },
                      ),
                    )
                        : Column(
                      children: [
                        SizedBox(height: 2.5.h,),
                        Image.asset(
                          'images/no_questions.png',
                          height: 62.0.w,
                        ),
                        SizedBox(height: 3.4.h,),
                        Text(
                          "Buat pertanyaan pertama Bunda",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.0.sp,
                          ),
                        ),
                        SizedBox(height: 1.3.h,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.7.w),
                          child: Text(
                            'Ketuk ikon tambah di pojok kanan atas '
                                "untuk memasukkan pertanyaan Bunda ke forum.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.0.sp,
                              height: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.5.h,),
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
                            Navigator.pushReplacementNamed(context, '/newquestion');
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
            ],
          );
        },
      ),
    );
  }
}
