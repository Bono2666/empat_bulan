// @dart=2.9
import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class Schedule extends StatefulWidget {
  const Schedule({Key key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List dbSchedule;
  String _time, _title = '';
  int isDone = 0;

  Future getSchedule() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_schedule.php?phone=${prefs.getPhone}&date=${DateFormat('yyyy-MM-dd').format(_focusedDay)}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updSchedule() async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_check_sched.php?phone=${prefs.getPhone}&time=$_time&title=$_title&is_done=$isDone&date=${DateFormat('yyyy-MM-dd').format(_focusedDay)}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future delSchedule(int index) async {
    var url = 'https://app.empatbulan.com/api/del_schedule.php';
    await http.post(Uri.parse(url), body: {
      'phone' : dbSchedule[index]['phone'],
      'date' : dbSchedule[index]['date'],
      'time' : dbSchedule[index]['time'],
      'title' : dbSchedule[index]['title'],
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
                    'Jadwal Kontrol',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3.8.h,),
                  TableCalendar(
                    calendarFormat: _calendarFormat,
                    focusedDay: _focusedDay,
                    firstDay: DateTime.utc(2022),
                    lastDay: DateTime.utc(2050),

                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    locale: 'id_ID',
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(
                        fontSize: 12.0.sp,
                      ),
                      todayTextStyle: TextStyle(
                        fontSize: 12.0.sp,
                        color: Colors.white,
                      ),
                      weekendTextStyle: TextStyle(
                        fontSize: 12.0.sp,
                        color: Theme.of(context).backgroundColor,
                      ),
                      selectedTextStyle: TextStyle(
                        fontSize: 12.0.sp,
                        color: Colors.white,
                      ),
                      outsideDaysVisible: false,
                      todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).backgroundColor,
                      ),
                      selectedDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                      titleTextStyle: TextStyle(
                        color: Theme.of(context).backgroundColor,
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      headerPadding: EdgeInsets.only(left: 2.8.w, bottom: 4.8.w,),
                    ),
                  ),
                  SizedBox(height: 5.0.h,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'images/ic_schedule_color.png',
                        height: 3.2.w,
                      ),
                      SizedBox(width: 1.4.w,),
                      Text(
                        'Jadwal Bunda',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10.0.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.8.h,),
                  FutureBuilder(
                    future: getSchedule(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SpinKitThreeBounce(
                              color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                          ],
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        dbSchedule = snapshot.data;
                      }
                      return SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dbSchedule.length,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 0),
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(dbSchedule[index].toString()),
                              onDismissed: (direction) {
                                delSchedule(index);
                                dbSchedule.removeAt(index);
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
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dbSchedule[index]['title'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.0.sp,
                                                ),
                                              ),
                                              SizedBox(height: 0.6.w,),
                                              Text(
                                                'Jam ${dbSchedule[index]['time']} ${dbSchedule[index]['notes']}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 8.0.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Expanded(child: SizedBox()),
                                          InkWell(
                                            onTap: () {
                                              prefs.setIsUpdSched(true);
                                              prefs.setSchedTitle(dbSchedule[index]['title']);
                                              prefs.setSchedDate(dbSchedule[index]['date']);
                                              prefs.setSchedTime(dbSchedule[index]['time']);
                                              prefs.setSchedNotes(dbSchedule[index]['notes']);
                                              Navigator.pushReplacementNamed(context, '/updSchedule');
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
                                              _title = dbSchedule[index]['title'];
                                              _time = dbSchedule[index]['time'];
                                              if (dbSchedule[index]['is_done'] == '0') {
                                                isDone = 1;
                                              } else {
                                                isDone = 0;
                                              }
                                              setState(() {
                                                updSchedule();
                                              });
                                            },
                                            child: SizedBox(
                                              width: 6.7.w,
                                              child: FittedBox(
                                                child: dbSchedule[index]['is_done'] == '0'
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
                    prefs.setIsUpdSched(false);
                    Navigator.pushReplacementNamed(context, '/updSchedule');
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
