// @dart=2.9
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';

class UpdSched extends StatefulWidget {
  const UpdSched({Key key}) : super(key: key);

  @override
  State<UpdSched> createState() => _UpdSchedState();
}

class _UpdSchedState extends State<UpdSched> {
  final _title = TextEditingController();
  final _date = TextEditingController();
  final _time = TextEditingController();
  final _notes = TextEditingController();
  // String _reminder = '';
  String _scheduleDate = '';
  final int _reminderInMin = 0;

  Future addSchedule() async {
    var url = 'https://empatbulan.bonoworks.id/api/add_schedule.php';
    await http.post(Uri.parse(url), body: {
      'phone' : prefs.getPhone,
      'date' : _scheduleDate,
      'time' : _time.text,
      'title' : _title.text,
      'notes' : _notes.text,
      'reminder' : _reminderInMin.toString(),
    });
  }

  Future updSchedule() async {
    var url = Uri.parse('https://empatbulan.bonoworks.id/api/upd_single_sched.php?phone=${prefs.getPhone}&time=${prefs.getSchedTime}&title=${prefs.getSchedTitle}&date=${prefs.getSchedDate}&new_title=${_title.text}&new_date=$_scheduleDate&new_time=${_time.text}&new_notes=${_notes.text}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    if (prefs.getIsUpdSched) {
      _date.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime(
          int.parse(prefs.getSchedDate.substring(0, 4)),
          int.parse(prefs.getSchedDate.substring(5, 7)),
          int.parse(prefs.getSchedDate.substring(8, 10))
      ));
      _title.text = prefs.getSchedTitle;
      _scheduleDate = prefs.getSchedDate;
      _time.text = prefs.getSchedTime;
      _notes.text = prefs.getSchedNotes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/schedule');
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
                      'Buat Jadwal',
                      style: TextStyle(
                        fontSize: 24.0.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.0.h,),
                    Text(
                      'Judul Pertemuan',
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
                    SizedBox(height: 3.0.h,),
                    Text(
                      'Tanggal Pertemuan',
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                    ),
                    TextField(
                      controller: _date,
                      readOnly: true,
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          minTime: DateTime.now(),
                          onConfirm: (date) {
                            setState(() {
                              _date.text = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
                              _scheduleDate = DateFormat('yyyy-MM-dd').format(date);
                            });
                          },
                          theme: DatePickerTheme(
                            itemStyle: TextStyle(
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                              fontSize: 15.0.sp,
                              color: Theme.of(context).backgroundColor,
                            ),
                            doneStyle: TextStyle(
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                              color: Theme.of(context).backgroundColor,
                            ),
                            cancelStyle: TextStyle(
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                              color: Colors.black,
                            ),
                          ),
                          locale: LocaleType.id,
                        );
                      },
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          margin: EdgeInsets.fromLTRB(4.4.w, 2.2.w, 2.2.w, 4.4.w),
                          height: 3.0.h,
                          child: Image.asset(
                            'images/ic_date.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        hintText: 'Pilih tanggal',
                        hintStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 15.0.sp,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 15.0.sp,
                      ),
                    ),
                    SizedBox(height: 3.0.h,),
                    Text(
                      'Jam Pertemuan',
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                    ),
                    TextField(
                      controller: _time,
                      readOnly: true,
                      onTap: () {
                        DatePicker.showTimePicker(
                          context,
                          onConfirm: (time) {
                            setState(() {
                              _time.text = DateFormat('HH.mm', 'id_ID').format(time);
                            });
                          },
                          showSecondsColumn: false,
                          locale: LocaleType.id,
                          theme: DatePickerTheme(
                            itemStyle: TextStyle(
                              fontSize: 15.0.sp,
                              color: Theme.of(context).backgroundColor,
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                            ),
                            cancelStyle: TextStyle(
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                              color: Colors.black,
                            ),
                            doneStyle: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontFamily: GoogleFonts.josefinSans().fontFamily,
                            ),
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        suffixIcon: Container(
                          margin: EdgeInsets.fromLTRB(4.4.w, 2.2.w, 2.2.w, 4.4.w),
                          height: 3.0.h,
                          child: Image.asset(
                            'images/ic_schedule_color.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        hintText: 'Pilih waktu',
                        hintStyle: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontSize: 15.0.sp,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 15.0.sp,
                      ),
                    ),
                    SizedBox(height: 3.0.h,),
                    Text(
                      'Catatan',
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Theme.of(context).unselectedWidgetColor,
                      ),
                    ),
                    TextField(
                      controller: _notes,
                      style: TextStyle(
                        fontSize: 15.0.sp,
                      ),
                    ),
                    // SizedBox(height: 3.0.h,),
                    // Text(
                    //   'Pengingat',
                    //   style: TextStyle(
                    //     fontSize: 13.0.sp,
                    //     color: Theme.of(context).unselectedWidgetColor,
                    //   ),
                    // ),
                    // SizedBox(height: 1.0.h,),
                    // InkWell(
                    //   onTap: () {
                    //     showModalBottomSheet(
                    //       context: context,
                    //       builder: (builder) {
                    //         return Column(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Container(
                    //               decoration: BoxDecoration(
                    //                 color: Colors.white,
                    //                 boxShadow: [
                    //                   BoxShadow(
                    //                     color: Theme.of(context).shadowColor,
                    //                     blurRadius: 8,
                    //                     offset: Offset(0, 3),
                    //                   ),
                    //                 ],
                    //               ),
                    //               child: Padding(
                    //                 padding: EdgeInsets.fromLTRB(8.8.w, 4.4.w, 8.8.w, 5.2.w),
                    //                 child: Row(
                    //                   mainAxisAlignment: MainAxisAlignment.start,
                    //                   crossAxisAlignment: CrossAxisAlignment.center,
                    //                   children: [
                    //                     Image.asset(
                    //                       'images/ic_schedule_color.png',
                    //                       width: 4.2.w,
                    //                     ),
                    //                     SizedBox(width: 6.0.w,),
                    //                     Text(
                    //                       'Pengingat',
                    //                       style: TextStyle(
                    //                         fontSize: 17.0.sp,
                    //                         color: Theme.of(context).backgroundColor,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(height: 3.0.h,),
                    //             Column(
                    //               children: [
                    //                 Container(
                    //                   child: ListTile(
                    //                     title: Text(
                    //                       '15 menit sebelumnya',
                    //                       style: TextStyle(
                    //                         fontSize: 13.0.sp,
                    //                       ),
                    //                     ),
                    //                     contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                    //                     onTap: () {
                    //                       setState(() {
                    //                         _reminder = '15 menit sebelumnya';
                    //                         _reminderInMin = 15;
                    //                         Navigator.pop(context);
                    //                       });
                    //                     },
                    //                   ),
                    //                   decoration: BoxDecoration(
                    //                     border: Border(
                    //                       top: BorderSide(
                    //                         color: Theme.of(context).dividerColor,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   child: ListTile(
                    //                     title: Text(
                    //                       '30 menit sebelumnya',
                    //                       style: TextStyle(
                    //                         fontSize: 13.0.sp,
                    //                       ),
                    //                     ),
                    //                     contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                    //                     onTap: () {
                    //                       setState(() {
                    //                         _reminder = '30 menit sebelumnya';
                    //                         _reminderInMin = 30;
                    //                         Navigator.pop(context);
                    //                       });
                    //                     },
                    //                   ),
                    //                   decoration: BoxDecoration(
                    //                     border: Border(
                    //                       top: BorderSide(
                    //                         color: Theme.of(context).dividerColor,
                    //                       ),
                    //                       bottom: BorderSide(
                    //                         color: Theme.of(context).dividerColor,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   child: ListTile(
                    //                     title: Text(
                    //                       '1 jam sebelumnya',
                    //                       style: TextStyle(
                    //                         fontSize: 13.0.sp,
                    //                       ),
                    //                     ),
                    //                     contentPadding: EdgeInsets.fromLTRB(8.8.w,3.4.w,8.8.w,3.2.w),
                    //                     onTap: () {
                    //                       setState(() {
                    //                         _reminder = '1 jam sebelumnya';
                    //                         _reminderInMin = 60;
                    //                         Navigator.pop(context);
                    //                       });
                    //                     },
                    //                   ),
                    //                   decoration: BoxDecoration(
                    //                     border: Border(
                    //                       top: BorderSide(
                    //                         color: Theme.of(context).dividerColor,
                    //                       ),
                    //                       bottom: BorderSide(
                    //                         color: Theme.of(context).dividerColor,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(height: 4.4.h,)
                    //           ],
                    //         );
                    //       },
                    //     );
                    //   },
                    //   child: Container(
                    //     height: 4.8.h,
                    //     decoration: BoxDecoration(
                    //       border: Border(
                    //         bottom: BorderSide(
                    //           color: Theme.of(context).dividerColor,
                    //         ),
                    //       ),
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: [
                    //         Expanded(
                    //           child: Text(
                    //             _reminder,
                    //             style: TextStyle(
                    //               fontSize: 15.0.sp,
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 2.2.w,
                    //           child: Image.asset(
                    //             'images/ic_down.png',
                    //           ),
                    //         ),
                    //         SizedBox(width: 2.2.w,),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                  onTap: () => Navigator.pushReplacementNamed(context, '/schedule'),
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
                        if (prefs.getIsUpdSched) {
                          updSchedule();
                        } else {
                          addSchedule();
                        }
                        await Navigator.pushReplacementNamed(context, '/schedule');
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
