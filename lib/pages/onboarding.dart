import 'dart:async';
import 'dart:convert';
import 'package:empat_bulan/main.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late List dbOnboarding;
  PageController pageController = PageController();
  int currentPage = 0, prevPage = 0;
  late int totRec;

  Future getOnboarding() async {
    var url = Uri.parse('https://app.empatbulan.com/api/get_onboarding.php');
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    totRec = prefs.getTotOnboard;

    Timer.periodic(const Duration(seconds: 10), (timer) {
      prevPage = currentPage;

      if (totRec != null) {
        if (currentPage < (totRec - 1)) {
          currentPage++;
        } else {
          currentPage = 0;
        }
      }

      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInSine,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 86.0.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(58),
                    bottomRight: Radius.circular(58),
                  ),
                ),
              ),
              FutureBuilder(
                future: getOnboarding(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data == null || snapshot.hasError) {
                    return SizedBox(
                          width: 100.0.w,
                          height: 86.0.h,
                          child: const Center(
                              child: SpinKitDoubleBounce(
                                color: Colors.white,
                              )
                          )
                      );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    dbOnboarding = snapshot.data as List;
                  }
                  return Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      SizedBox(
                        width: 100.0.w,
                        height: 86.0.h,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(58),
                            bottomLeft: Radius.circular(58),
                          ),
                          child: PageView.builder(
                            itemCount: dbOnboarding.length,
                            controller: pageController,
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return SlideItem(imageUrl: dbOnboarding[index]['image']);
                            },
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 18.0.h,),
                          SizedBox(
                            width: 20.0.w,
                            height: 37.5.w,
                            child: Image.asset(
                              'images/logo_magenta.png',
                              color: Theme.of(context).colorScheme.background,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 5.0.h,),
                          AnimatedCrossFade(
                            crossFadeState: CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300),
                            firstChild: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                              child: Html(
                                data: dbOnboarding[currentPage]['title'],
                                style: {
                                  'body': Style(
                                    color: Theme.of(context).colorScheme.background,
                                    fontSize: FontSize(24.0.sp),
                                    fontWeight: FontWeight.w600,
                                    padding: const EdgeInsets.all(0),
                                    textAlign: TextAlign.center,
                                    letterSpacing: 0.5,
                                  ),
                                },
                              ),
                            ),
                            secondChild: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                              child: Html(
                                data: dbOnboarding[currentPage]['title'],
                                style: {
                                  'body': Style(
                                    color: Theme.of(context).colorScheme.background,
                                    fontSize: FontSize(24.0.sp),
                                    fontWeight: FontWeight.w600,
                                    padding: const EdgeInsets.all(0),
                                    textAlign: TextAlign.center,
                                    letterSpacing: 0.5,
                                  ),
                                },
                              ),
                            ),
                            firstCurve: Curves.easeOutSine,
                            secondCurve: Curves.easeOutSine,
                          ),
                          SizedBox(height: 1.0.h,),
                          AnimatedCrossFade(
                            crossFadeState: CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300),
                            firstChild: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                              child: Html(
                                data: dbOnboarding[currentPage]['description'],
                                style: {
                                  'body': Style(
                                    color: Theme.of(context).colorScheme.background,
                                    fontSize: FontSize(10.0.sp),
                                    fontWeight: FontWeight.w400,
                                    padding: const EdgeInsets.all(0),
                                    textAlign: TextAlign.center,
                                    // letterSpacing: 1,
                                  ),
                                },
                              ),
                            ),
                            secondChild: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.0.w),
                              child: Html(
                                data: dbOnboarding[currentPage]['description'],
                                style: {
                                  'body': Style(
                                    color: Theme.of(context).colorScheme.background,
                                    fontSize: FontSize(10.0.sp),
                                    fontWeight: FontWeight.w400,
                                    padding: const EdgeInsets.all(0),
                                    textAlign: TextAlign.center,
                                    // letterSpacing: 1,
                                  ),
                                },
                              ),
                            ),
                            firstCurve: Curves.easeOutSine,
                            secondCurve: Curves.easeOutSine,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 77.0.h,
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: totRec.toInt(),
                          effect: WormEffect(
                            type: WormType.thin,
                            dotHeight: 1.5.w,
                            dotWidth: 1.5.w,
                            spacing: 3.0.w,
                            dotColor: Theme.of(context).primaryColor,
                            activeDotColor: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
            child: SizedBox(
              height: 14.0.h,
              child: Center(
                child: Text(
                  'Mulai',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0.sp,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SlideItem extends StatelessWidget {
  String imageUrl = '';

  SlideItem({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Positioned(
              bottom: 12.0.h,
              child: SpinKitDoubleBounce(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }
}
