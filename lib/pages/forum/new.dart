import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'package:image_picker/image_picker.dart';

class NewQuestions extends StatefulWidget {
  const NewQuestions({Key? key}) : super(key: key);

  @override
  State<NewQuestions> createState() => _NewQuestionsState();
}

class _NewQuestionsState extends State<NewQuestions> {
  String title = '';
  var questions = TextEditingController();
  final picker = ImagePicker();
  File? img;
  late List dbNotifications;
  bool isError = false;
  bool isSensitive = false;
  int sensitif = 0;

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

  Future addQuestion() async {
    var url = Uri.parse('https://app.empatbulan.com/api/add_question.php');
    var req = http.MultipartRequest('POST', url);
    req.fields['phone'] = prefs.getPhone;
    req.fields['title'] = title;
    req.fields['description'] = questions.text;
    req.fields['sensitif'] = sensitif.toString();
    req.fields['date'] = DateFormat('d MMM yyyy HH:mm', 'id_ID').format(DateTime.now());
    if (img != null) {
      var pic = await http.MultipartFile.fromPath('image', img!.path);
      req.files.add(pic);
    }
    var response = await req.send();
    // ignore: use_build_context_synchronously
    if (response.statusCode == 200) await Navigator.pushReplacementNamed(context, '/questionsList');
  }

  Future getNotifications() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_notifications.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) => KeyboardDismisser(
    gestures: const [
      // GestureType.onTap,
      // GestureType.onVerticalDragDown,
    ],
    child: Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (prefs.getBackRoute == '/home') {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
          }
          return false;
        },
        child: FutureBuilder(
          future: getNotifications(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
              return
                SizedBox(
                    width: 100.0.w,
                    height: 100.0.h,
                    child: const Center(
                        child: SpinKitDoubleBounce(
                          color: Colors.white,
                        )
                    )
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
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 19.4.h,),
                            Text(
                              'Tulis pertanyaan baru',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.0.sp,
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
                                    'Tanyakan persoalan Anda di forum',
                                    style: TextStyle(
                                      fontSize: 10.0.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 3.8.h,),
                            Visibility(
                              visible: isError ? true : false,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 5.2.w,
                                    height: 5.2.w,
                                    child: Image.asset(
                                      'images/ic_error.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 2.0.w,),
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 1.0.w),
                                      child: Text(
                                        'Bunda belum melengkapi Judul Pertanyaan dan Persoalan Bunda, mohon dilengkapi ya...',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.error,
                                          fontSize: 10.0.sp,
                                          height: 1.4,
                                        ),
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.4.h,),
                            TextField(
                              onChanged: (String str) {
                                setState(() {
                                  title = str;
                                  if (isError) {
                                    isError = false;
                                  }
                                });
                              },
                              cursorColor: Colors.black,
                              style: TextStyle(
                                fontSize: 13.0.sp,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Ketik judul pertanyaan',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 15.0.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.4.w,),
                            TextField(
                              controller: questions,
                              minLines: 1,
                              maxLines: 6,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                hintText: 'Ceritakan persoalan Bunda...',
                                hintStyle: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontSize: 15.0.sp,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                height: 1.5,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (isError) {
                                    isError = false;
                                  }
                                });
                              },
                            ),
                            SizedBox(height: 4.4.w,),
                            img != null
                                ? ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(
                                    width: 1.0,
                                    style: BorderStyle.solid,
                                    color: Theme.of(context).highlightColor,
                                  ),
                                ),
                                child: Image.file(
                                  img!,
                                  height: 46.7.w,
                                  width: 86.7.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                                : Container(),
                            img != null ? SizedBox(height: 3.8.h,) : Container(),
                            img != null ? Row(
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
                            ) : Container(),
                            SizedBox(height: 25.6.h,),
                          ],
                        ),
                      ),
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
                    const Expanded(child: SizedBox()),
                    Stack(
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
                          onTap: () {
                            if (title != '' && questions.text != '') {
                              addQuestion();
                            } else {
                              setState(() {
                                isError = true;
                              });
                            }
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: [
                              Container(
                                width: 45.6.w,
                                height: 20.8.w,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                width: 34.4.w,
                                child: Center(
                                  child: Text(
                                    'Kirim',
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
                              pickImg();
                            },
                            child: Container(
                              width: 48.9.w,
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
                                  'Upload Foto',
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 5.6.h,),
                        Padding(
                          padding: EdgeInsets.only(right: 2.2.w,),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/notifications');
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
                                      'images/ic_forum_small.png',
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: dbNotifications.isNotEmpty ? true : false,
                                  child: Positioned(
                                    left: 7.8.w,
                                    top: 2.2.w,
                                    child: Container(
                                      width: 2.2.w,
                                      height: 2.2.w,
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.error,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(50),
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 5.6.h,),
                        Padding(
                          padding: EdgeInsets.only(right: 6.6.w,),
                          child: InkWell(
                            onTap: () {
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
                                      'images/ic_menu.png',
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
      ),
    ),
  );
}
