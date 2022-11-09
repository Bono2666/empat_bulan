import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class ToDo extends StatefulWidget {
  const ToDo({Key? key}) : super(key: key);

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  late List dbTodo;
  String _id = '';
  int isDone = 0;

  Future getTodo() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_todo.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updTodo() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_check_todo.php?id=$_id&is_done=$isDone');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future delTodo(int index) async {
    var url = 'https://app.empatbulan.com/api/del_todo.php';
    await http.post(Uri.parse(url), body: {
      'id' : dbTodo[index]['id'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'To Do List',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.4.h,),
                  FutureBuilder(
                    future: getTodo(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 28.0.h,),
                            SpinKitThreeBounce(
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ],
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        dbTodo = snapshot.data as List;
                      }
                      return dbTodo.isNotEmpty
                          ? SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dbTodo.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(dbTodo[index].toString()),
                              onDismissed: (direction) {
                                delTodo(index);
                                dbTodo.removeAt(index);
                                setState(() {});
                              },
                              child: Column(
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
                                      padding: EdgeInsets.fromLTRB(3.3.w, 0, 3.3.w, 3.3.w),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 61.1.w,
                                            child: Text(
                                              dbTodo[index]['title'],
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.0.sp,
                                              ),
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          InkWell(
                                            onTap: () {
                                              prefs.setIsUpdTodo(true);
                                              prefs.setTodoId(dbTodo[index]['id']);
                                              prefs.setTodoTitle(dbTodo[index]['title']);
                                              Navigator.pushReplacementNamed(context, '/updTodo');
                                            },
                                            child: SizedBox(
                                              width: 4.4.w,
                                              height: 4.4.w,
                                              child: FittedBox(
                                                child: Image.asset('images/ic_edit.png'),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 4.4.w,),
                                          InkWell(
                                            onTap: () {
                                              if (dbTodo[index]['is_done'] == '0') {
                                                isDone = 1;
                                              } else {
                                                isDone = 0;
                                              }
                                              setState(() {
                                                _id = dbTodo[index]['id'];
                                                updTodo();
                                              });
                                            },
                                            child: SizedBox(
                                              width: 6.7.w,
                                              child: FittedBox(
                                                child: dbTodo[index]['is_done'] == '0'
                                                    ? Image.asset('images/ic_uncheck.png')
                                                    : Image.asset('images/ic_checked.png'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4.4.w),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                          : Column(
                        children: [
                          SizedBox(height: 6.4.h,),
                          Image.asset(
                            'images/no_todo.png',
                            height: 44.0.w,
                          ),
                          SizedBox(height: 6.4.h,),
                          Text(
                            "Buat 'to do list' pertama Bunda",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.0.sp,
                            ),
                          ),
                          SizedBox(height: 1.3.h,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.2.w),
                            child: Text(
                              'Ketuk ikon tambah di pojok kanan atas '
                                  "untuk menambah 'to do list' Bunda ke daftar ini.",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10.0.sp,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      );
                    },
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
          Row(
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
                          size: 5.2.w,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.only(top: 5.6.w, right: 6.6.w,),
                child: InkWell(
                  onTap: () {
                    prefs.setIsUpdTodo(false);
                    Navigator.pushReplacementNamed(context, '/updTodo');
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
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 6.0,
                                offset: const Offset(0,3),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.6.w,
                        height: 5.6.w,
                        child: FittedBox(
                          child: Image.asset('images/ic_plus.png'),
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
    );
  }
}
