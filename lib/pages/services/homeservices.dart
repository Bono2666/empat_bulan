import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:empat_bulan/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

late int classId;

class HomeServices extends StatefulWidget {
  const HomeServices({Key? key}) : super(key: key);

  @override
  State<HomeServices> createState() => _HomeServicesState();
}

class _HomeServicesState extends State<HomeServices> {
  late List dbHome, dbClass, dbNotifications, dbCart;
  bool firstLoad = true;
  int currentAge = 0;
  late DateTime classDate;

  Future getHomeImage() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_home_services.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getClass() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_home_class.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getNotifications() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_notifications.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getCart() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_cart.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true);
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
            return FutureBuilder(
              future: getClass(),
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
                  dbClass = snapshot.data as List;
                }
                return FutureBuilder(
                  future: getHomeImage(),
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
                      dbHome = snapshot.data as List;
                    }
                    return FutureBuilder(
                      future: getCart(),
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
                          dbCart = snapshot.data as List;
                        }
                        return Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 100.0.w,
                                      height: 74.0.h,
                                      child: Image.network(
                                        dbHome[0]['image'],
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(top: 72.0.w),
                                                child: const SpinKitThreeBounce(
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: 26.0.h,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: 31.1.w,),
                                        Text(
                                          'Layanan',
                                          style: TextStyle(
                                            fontSize: 37.0.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context).colorScheme.background,
                                          ),
                                        ),
                                        SizedBox(height: 2.2.w,),
                                        Text(
                                          'Layanan terbaik bagi bumil & balita\n'
                                              'dengan instruktur & terapis terpercaya',
                                          style: TextStyle(
                                            fontSize: 10.0.sp,
                                            color: Theme.of(context).colorScheme.background,
                                            height: 1.2,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(height: 4.4.w,),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context, '/classes');
                                          },
                                          child: Container(
                                            width: 47.2.w,
                                            height: 14.4.w,
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(26)),
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Yuk, lihat!',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13.0.sp,
                                                  color: Colors.white,
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
                            DraggableScrollableSheet(
                              expand: false,
                              initialChildSize: 0.54,
                              minChildSize: 0.54,
                              maxChildSize: 1.0,
                              builder: (context, scrollController) {
                                return SingleChildScrollView(
                                  controller: scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 0.6.w,),
                                        child: Container(
                                          width: 99.4.w,
                                          height: 8.0.h,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).highlightColor,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(56),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 0.3.w,),
                                        child: Container(
                                          width: 100.0.w,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(56),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 1.8.h,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 8.6.w,
                                                    height: 0.5.h,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(context).primaryColor,
                                                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 3.8.h,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Search(type: 'layanan',),));
                                                  },
                                                  child: Container(
                                                    height: 11.7.w,
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                                                      border: Border.all(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'images/ic_search.png',
                                                          height: 5.3.w,
                                                        ),
                                                        SizedBox(width: 3.3.w,),
                                                        Text(
                                                          'Layanan apa yang Bunda cari?',
                                                          style: TextStyle(
                                                            fontSize: 12.0.sp,
                                                            color: Theme.of(context).primaryColorDark,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 3.1.h,),
                                              Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'images/ic_article_small.png',
                                                          height: 3.2.w,
                                                        ),
                                                        SizedBox(width: 1.4.w,),
                                                        Column(
                                                          children: [
                                                            SizedBox(height: 0.8.w,),
                                                            Text(
                                                              'Layanan',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 10.0.sp,
                                                                fontWeight: FontWeight.w700,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 2.8.h,),
                                                  ],
                                                ),
                                              ),
                                              dbClass.isNotEmpty ? Column(
                                                children: [
                                                  SizedBox(
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: dbClass.length,
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      padding: EdgeInsets.only(top: 0, left: 6.7.w, right: 6.7.w),
                                                      itemBuilder: (context, index) {
                                                        classDate = DateTime(
                                                            int.parse(dbClass[index]['date'].substring(0, 4)),
                                                            int.parse(dbClass[index]['date'].substring(5, 7)),
                                                            int.parse(dbClass[index]['date'].substring(8, 10))
                                                        );
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.symmetric(vertical: 1.0.w),
                                                              child: InkWell(
                                                                onTap: () async {
                                                                  classId = int.parse(dbClass[index]['id']);
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
                                                                      dbClass[index]['image'] == '' ? Container() : ClipRRect(
                                                                        borderRadius:
                                                                        const BorderRadius.only(
                                                                          topLeft: Radius.circular(12),
                                                                          topRight: Radius.circular(12),
                                                                        ),
                                                                        child: Container(
                                                                          color: Theme.of(context).primaryColor,
                                                                          child: Image.network(
                                                                            dbClass[index]['image'],
                                                                            height: 43.1.w,
                                                                            width: 86.7.w,
                                                                            fit: BoxFit.cover,
                                                                            loadingBuilder: (context, child, loadingProgress) {
                                                                              if (loadingProgress == null) {
                                                                                return child;
                                                                              }
                                                                              return SizedBox(
                                                                                height: 43.0.w,
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
                                                                      Padding(
                                                                        padding: EdgeInsets.fromLTRB(4.4.w, 5.6.w, 4.4.w, 6.1.w),
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
                                                                                          'images/ic_book_white.png',
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
                                                                                      dbClass[index]['title'],
                                                                                      style: TextStyle(
                                                                                        color: Colors.black,
                                                                                        fontSize: 10.0.sp,
                                                                                        fontWeight: FontWeight.w700,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 2.8.w,),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  '${DateFormat('d MMM yyyy', 'id_ID').format(classDate)} ${dbClass[index]['time']}',
                                                                                  style: TextStyle(
                                                                                    color: Theme.of(context).unselectedWidgetColor,
                                                                                    fontSize: 8.0.sp,
                                                                                  ),
                                                                                ),
                                                                                const Expanded(child: SizedBox()),
                                                                                Text(
                                                                                  dbClass[index]['type'],
                                                                                  style: TextStyle(
                                                                                    color: Theme.of(context).colorScheme.background,
                                                                                    fontSize: 8.0.sp,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(height: 2.2.w,),
                                                                            Text(
                                                                              dbClass[index]['description'],
                                                                              style: TextStyle(
                                                                                color: Theme.of(context).primaryColorDark,
                                                                                fontSize: 13.0.sp,
                                                                              ),
                                                                              overflow: TextOverflow.ellipsis,
                                                                              maxLines: 4,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 3.1.h,),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 0.6.h,),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pushNamed(context, '/classes');
                                                      },
                                                      child: Container(
                                                        height: 11.7.w,
                                                        decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(Radius.circular(24)),
                                                          border: Border.all(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Lihat semua kelas',
                                                            style: TextStyle(
                                                              fontSize: 12.0.sp,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ) : Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'images/no_class.png',
                                                    height: 28.0.w,
                                                  ),
                                                  SizedBox(height: 3.4.h,),
                                                  Text(
                                                    "Tidak ada kelas saat ini",
                                                    style: TextStyle(
                                                      color: Theme.of(context).colorScheme.background,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 12.0.sp,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 1.3.h,),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 12.4.w),
                                                    child: Text(
                                                      'Coba kembali beberapa waktu ke depan untuk mendapatkan '
                                                          "informasi terbaru kelas-kelas selanjutnya",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10.0.sp,
                                                        height: 1.2,
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(height: 24.4.h,),
                                                ],
                                              ),
                                              SizedBox(height: 11.3.h,),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true),
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
                                            size: 7.0.w,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Column(
                                  children: [
                                    SizedBox(height: 5.6.h,),
                                    Padding(
                                      padding: EdgeInsets.only(right: 2.2.w,),
                                      child: InkWell(
                                        onTap: () {
                                          prefs.setBackRoute('/homeServices');
                                          Navigator.pushNamed(context, '/cart');
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
                                                  'images/ic_cart.png',
                                                ),
                                              ),
                                            ),
                                            Visibility(
                                              visible: dbCart.isNotEmpty ? true : false,
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSingleClass(),
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
                children: [
                  SpinKitDoubleBounce(
                    color: Theme.of(context).primaryColor,
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
                                child: SpinKitDoubleBounce(
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
                              onTap: () async {
                                if (dbSingleCart.isEmpty) {
                                  addCart();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        'Layanan telah dimasukkan ke Keranjang.',
                                        style: TextStyle(
                                          fontFamily: 'Josefin Sans',
                                        ),
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.background,
                                    ),
                                  );
                                }
                                prefs.setBackRoute('/homeServices');
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
                                          'Layanan telah dimasukkan ke Keranjang.',
                                          style: TextStyle(
                                            fontFamily: 'Josefin Sans',
                                          ),
                                        ),
                                        backgroundColor: Theme.of(context).colorScheme.background,
                                      ),
                                    );
                                  }
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) => const HomeServices(),
                                        transitionDuration: Duration.zero,
                                      ));
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
