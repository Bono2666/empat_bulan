// @dart=2.9
import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:empat_bulan/main.dart';
import 'package:http/http.dart' as http;

int classId;
bool fromCart;

class Cart extends StatefulWidget {
  const Cart({Key key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List dbCart, dbGroupCart, dbUserCart, dbOtherCart, dbProfile;

  Future getCart() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_cart.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getGroupCart() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_group_cart.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future getOtherCart() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_other_cart.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updSelectedClass(int id, int selected) async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_selected_class.php?id=$id&selected=$selected');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future updSelectedAll(int selected) async {
    var url = Uri.parse('https://app.empatbulan.com/api/upd_selected_all.php?phone=${prefs.getPhone}&selected=$selected');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future delSelectedClass(int index) async {
    var url = 'https://app.empatbulan.com/api/del_selected_class.php';
    await http.post(Uri.parse(url), body: {
      'id' : dbCart[index]['id'],
    });
  }

  Future getProfile() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_profile.php?phone=${prefs.getPhone}');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/homeServices', (route) => true);
        return false;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: getGroupCart(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
              return
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitDoubleBounce(
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              dbGroupCart = snapshot.data as List;
            }
            return FutureBuilder(
              future: getCart(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                  return
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitDoubleBounce(
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  dbCart = snapshot.data as List;
                }
                return FutureBuilder(
                  future: getOtherCart(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                      return
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitDoubleBounce(
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      dbOtherCart = snapshot.data as List;
                    }
                    return FutureBuilder(
                      future: getProfile(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                          return
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SpinKitDoubleBounce(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ],
                            );
                        }
                        if (snapshot.connectionState == ConnectionState.done) {
                          dbProfile = snapshot.data as List;
                        }
                        return Stack(
                          children: [
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.7.w,),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 19.0.h,),
                                        Text(
                                          'Keranjang',
                                          style: TextStyle(
                                            fontSize: 24.0.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 0.2.h,),
                                        dbCart.isNotEmpty ? SizedBox(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: dbCart.length,
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(0),
                                            itemBuilder: (context, index) {
                                              return Dismissible(
                                                key: Key(dbCart[index].toString()),
                                                onDismissed: (direction) {
                                                  delSelectedClass(index);
                                                  dbCart.removeAt(index);
                                                  setState(() {});
                                                },
                                                child: InkWell(
                                                  onTap: () {
                                                    classId = int.parse(dbCart[index]['class_id']);
                                                    fromCart = true;
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
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 4.4.h,),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              int selected;
                                                              if (dbCart[index]['selected'] == '0') {
                                                                selected = 1;
                                                              } else {
                                                                selected = 0;
                                                              }
                                                              setState(() {
                                                                updSelectedClass(int.parse(dbCart[index]['id']), selected);
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets.only(bottom: 11.5.w,),
                                                              child: Image.asset(
                                                                dbCart[index]['selected'] == '1' ? 'images/ic_picked.png' : 'images/ic_unpicked.png',
                                                                width: 5.6.w,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 2.2.w,),
                                                          Expanded(
                                                            child: SizedBox(
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                children: [
                                                                  Text(
                                                                    dbCart[index]['title'],
                                                                    textAlign: TextAlign.right,
                                                                    style: TextStyle(
                                                                      fontSize: 13.0.sp,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 1.7.w,),
                                                                  Text(
                                                                    dbCart[index]['instructur'],
                                                                    textAlign: TextAlign.right,
                                                                    style: TextStyle(
                                                                      fontSize: 8.0.sp,
                                                                      color: Theme.of(context).backgroundColor,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 5.6.w,),
                                                                  Text(
                                                                    NumberFormat.currency(
                                                                      locale: 'id',
                                                                      symbol: 'Rp ',
                                                                      decimalDigits: 0,
                                                                    ).format(int.parse(dbCart[index]['total_price'])),
                                                                    style: TextStyle(
                                                                      fontSize: 9.0.sp,
                                                                      color: Colors.black,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 2.4.w,),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: 3.4.w,),
                                                          Container(
                                                            width: 28.5.w,
                                                            height: 29.0.w,
                                                            decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Theme.of(context).shadowColor,
                                                                    blurRadius: 6.0,
                                                                    offset: const Offset(0, 3),
                                                                  ),
                                                                ]
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: const BorderRadius.all(
                                                                Radius.circular(12),
                                                              ),
                                                              child: SizedBox(
                                                                width: 28.5.w,
                                                                height: 29.0.w,
                                                                child: Image.network(
                                                                  dbCart[index]['image'],
                                                                  fit: BoxFit.cover,
                                                                  loadingBuilder: (context, child, loadingProgress) {
                                                                    if (loadingProgress == null) return child;
                                                                    return SizedBox(
                                                                      height: 29.0.w,
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
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 2.2.h,),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color: Theme.of(context).dividerColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ) : Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 5.6.h,),
                                            Image.asset(
                                              'images/empty_cart.png',
                                              height: 52.0.w,
                                            ),
                                            SizedBox(height: 3.4.h,),
                                            Text(
                                              "Keranjang Bunda masih kosong",
                                              style: TextStyle(
                                                color: Theme.of(context).backgroundColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.0.sp,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(height: 1.3.h,),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 6.7.w),
                                              child: Text(
                                                'Masukkan kelas pertama Bunda ke keranjang dengan '
                                                    "mengetuk tombol pesan atau masukkan ke keranjang",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10.0.sp,
                                                  height: 1.2,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(height: 2.8.h,),
                                          ],
                                        ),
                                        Visibility(visible: dbOtherCart.isNotEmpty ? true : false, child: SizedBox(height: 3.8.h,)),
                                        Visibility(
                                          visible: dbOtherCart.isNotEmpty ? true : false,
                                          child: Text(
                                            'Kelas lainnya',
                                            style: TextStyle(
                                              fontSize: 24.0.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Visibility(visible: dbOtherCart.isNotEmpty ? true : false, child: SizedBox(height: 3.8.h,)),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: dbOtherCart.isNotEmpty ? true : false,
                                    child: SizedBox(
                                      height: 72.0.w,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: dbOtherCart.length,
                                        physics: const BouncingScrollPhysics(),
                                        padding: EdgeInsets.fromLTRB(6.7.w, 0, 3.4.w, 3.1.h),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  classId = int.parse(dbOtherCart[index]['id']);
                                                  fromCart = false;
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
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                                                      child: Container(
                                                        color: Theme.of(context).primaryColor,
                                                        child: Image.network(
                                                          dbOtherCart[index]['image'],
                                                          height: 40.0.w,
                                                          width: 61.1.w,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder: (context, child, loadingProgress) {
                                                            if (loadingProgress == null) return child;
                                                            return SizedBox(
                                                              height: 40.0.w,
                                                              width: 61.1.w,
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
                                                    SizedBox(height: 5.6.w,),
                                                    Text(
                                                      dbOtherCart[index]['type'],
                                                      style: TextStyle(
                                                        color: Theme.of(context).backgroundColor,
                                                        fontSize: 7.0.sp,
                                                      ),
                                                    ),
                                                    SizedBox(height: 1.4.w,),
                                                    SizedBox(
                                                      width: 61.1.w,
                                                      child: Text(
                                                        dbOtherCart[index]['title'],
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.0.sp,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 3.9.w,),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(top: 0.4.w,),
                                                          child: Text(
                                                            NumberFormat.currency(
                                                              locale: 'id',
                                                              symbol: 'Rp ',
                                                              decimalDigits: 0,
                                                            ).format(int.parse(dbOtherCart[index]['total_price'])),
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: 1.1.w,),
                                                        dbOtherCart[index]['discount'] == '0' ? Container() : StrikeThrough(
                                                          child: Text(
                                                            NumberFormat.currency(
                                                              locale: 'id',
                                                              symbol: 'Rp ',
                                                              decimalDigits: 0,
                                                            ).format(int.parse(dbOtherCart[index]['price'])),
                                                            style: TextStyle(
                                                              fontSize: 10.0.sp,
                                                              fontWeight: FontWeight.w700,
                                                              color: Theme.of(context).unselectedWidgetColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 3.3.w,),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 17.8.h,),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(context, '/homeServices', (route) => true);
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
                                            size: 5.2.w,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      Container(
                                        height: 12.0.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).shadowColor,
                                                blurRadius: 6.0,
                                                offset: const Offset(0, -1),
                                              ),
                                            ]
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 6.7.w, top: 4.7.w, right: 41.1.w,),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      int selectedAll;
                                                      if (dbGroupCart.isNotEmpty) {
                                                        if (int.parse(dbGroupCart[0]['selected_item']) == dbCart.length) {
                                                          selectedAll = 0;
                                                        } else {
                                                          selectedAll = 1;
                                                        }
                                                      } else {
                                                        selectedAll = 1;
                                                      }
                                                      setState(() {
                                                        updSelectedAll(selectedAll);
                                                      });
                                                    },
                                                    child: Image.asset(
                                                      dbGroupCart.isNotEmpty
                                                          ? int.parse(dbGroupCart[0]['selected_item']) == dbCart.length
                                                          ? 'images/ic_picked.png' : 'images/ic_unpicked.png'
                                                          : 'images/ic_unpicked.png',
                                                      height: 5.6.w,
                                                    ),
                                                  ),
                                                  SizedBox(width: 2.2.w,),
                                                  Padding(
                                                    padding: EdgeInsets.only(top: 1.0.w),
                                                    child: Text(
                                                      'Pilih Semua',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10.0.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Expanded(child: SizedBox()),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 1.2.w,),
                                                  Text(
                                                    NumberFormat.currency(
                                                      locale: 'id',
                                                      symbol: 'Rp ',
                                                      decimalDigits: 0,
                                                    ).format(dbGroupCart.isNotEmpty ? int.parse(dbGroupCart[0]['total_price']) : 0),
                                                    style: TextStyle(
                                                      fontSize: 11.0.sp,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(height: 1.3.w,),
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'images/ic_classes.png',
                                                        height: 4.7.w,
                                                      ),
                                                      SizedBox(width: 1.7.w,),
                                                      Padding(
                                                        padding: EdgeInsets.only(top: 0.8.w),
                                                        child: Text(
                                                          '${dbGroupCart.isNotEmpty ? dbGroupCart[0]['selected_item'] : 0} item',
                                                          style: TextStyle(
                                                            color: Theme.of(context).backgroundColor,
                                                            fontSize: 10.0.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (dbGroupCart.isNotEmpty) {
                                            if (dbProfile[0]['email'] == '') {
                                              Navigator.pushNamed(context, '/checkout');
                                            } else {
                                              prefs.setBackRoute('/cart');
                                              Navigator.pushReplacementNamed(context, '/confirm');
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: 34.2.w,
                                          height: 12.0.h,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).backgroundColor,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(40),
                                            ),
                                          ),
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
                                      ),
                                    ]
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
  const ViewClass({Key key}) : super(key: key);

  @override
  State<ViewClass> createState() => _ViewClassState();
}

class _ViewClassState extends State<ViewClass> {
  List dbSingle, dbSingleCart;
  DateTime classDate;
  double totalPrice;

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
          if (dbSingle[0]['discount_type'] == '0') {
            totalPrice = double.parse(dbSingle[0]['price']) - double.parse(dbSingle[0]['discount']);
          } else {
            totalPrice = double.parse(dbSingle[0]['price']) - ((int.parse(dbSingle[0]['discount']) / 100) * double.parse(dbSingle[0]['price']));
          }
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
                                  color: Theme.of(context).backgroundColor,
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
                                            fontSize: 10.0.sp,
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
                                      ).format(totalPrice),
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
                                      color: Theme.of(context).backgroundColor,
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
                              SizedBox(height: fromCart ? 11.7.w : 35.6.w,),
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
                          visible: fromCart ? false : true,
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
                                          'Layanan telah dimasukkan ke Keranjang.',
                                          style: TextStyle(
                                            fontFamily: 'Josefin Sans',
                                          ),
                                        ),
                                        backgroundColor: Theme.of(context).backgroundColor,
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
                                            'Layanan telah dimasukkan ke Keranjang.',
                                            style: TextStyle(
                                              fontFamily: 'Josefin Sans',
                                            ),
                                          ),
                                          backgroundColor: Theme.of(context).backgroundColor,
                                        ),
                                      );
                                    }
                                    Navigator.pop(context);
                                    Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                              secondaryAnimation) => const Cart(),
                                          transitionDuration: Duration.zero,
                                        ));
                                  },
                                  child: Container(
                                    width: 55.6.w,
                                    height: 20.8.w,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
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

  const StrikeThrough({Key key, @required Widget child}) : _child = child, super(key: key);

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
