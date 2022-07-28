// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';

class UpdTodo extends StatefulWidget {
  const UpdTodo({Key key}) : super(key: key);

  @override
  State<UpdTodo> createState() => _UpdTodoState();
}

class _UpdTodoState extends State<UpdTodo> {
  final _title = TextEditingController();

  Future addTodo() async {
    var url = 'https://empatbulan.bonoworks.id/api/add_todo.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'title' : _title.text,
    });
  }

  Future getTodo() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/get_single_todo.php?id=${prefs.getTodoId}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updTodo() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/upd_single_todo.php?id=${prefs.getTodoId}&new_title=${_title.text}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    if (prefs.getIsUpdTodo) {
      _title.text = prefs.getTodoTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/todo');
        return false;
      },
      child: Scaffold(
        body: Stack(
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
                      'Yang akan dilakukan',
                      style: TextStyle(
                        fontSize: 24.0.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.0.h,),
                    Text(
                      'Apa yang akan Bunda lakukan',
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                    ),
                    TextField(
                      controller: _title,
                      style: TextStyle(
                        fontSize: 15.0.sp,
                      ),
                    ),
                    SizedBox(height: 17.5.h,),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Navigator.pushReplacementNamed(context, '/todo'),
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
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (prefs.getIsUpdTodo) {
                          updTodo();
                        } else {
                          addTodo();
                        }
                        await Navigator.pushReplacementNamed(context, '/todo');
                      },
                      child: Container(
                        width: 74.0.w,
                        height: 12.0.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(40),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Simpan',
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
    );
  }
}
