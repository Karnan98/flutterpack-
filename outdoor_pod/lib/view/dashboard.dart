import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../service/service.dart';
import 'inspection.dart';
import 'sitenav.dart';
import 'package:sizer/sizer.dart';
import '../commonstyle.dart';

import '../logoutaction.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime? _currentBackPressTime;
  late String username;
  late String sidenavigationdata;
  late List sidemenudata;
  List totalinspection = [];
  List totalincompleteinspection = [];
  List totalfirstinspection = [];
  @override
  void initState() {
    super.initState();
    getallrtrDetails();
  }

  getallrtrDetails() {
    // Dialogs.showLoadingDialog(context);
    ApiService().getApi('md-getallrtrdetail').then((value) {
      // Navigator.of(context, rootNavigator: true).pop();
      if (value['StatusCode'] == '200') {
        setState(() {
          var getalldata = jsonDecode(value['response']);
          totalfirstinspection = getalldata
              .where((value) =>
                  value['statusinspection'] != "IC" && value['duedays'] < 0)
              .toList();
          // totalfirstinspection.sort((a,b)=>a['duedays'].compareTo(b['duedays']));

          totalincompleteinspection = getalldata
              .where((value) => value['statusinspection'] == "IC")
              .toList();

          totalinspection = getalldata
              .where((value) => value['statusinspection'] != "IC")
              .toList();
        });
      }
    }).catchError((err) {
      defaultShowToast(context, 'Please Contact Customer Care');
      throw err;
    });
  }

  var tableheaders = ['S.No', 'Project Name', 'Code'];
  var tabledatas = [
    {'sno': 1, 'projectname': 'Test', 'code': '123'},
    {'sno': 2, 'projectname': 'MRF', 'code': 'M123'},
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();

        if (_currentBackPressTime == null ||
            now.difference(_currentBackPressTime!) >
                const Duration(seconds: 2)) {
          _currentBackPressTime = now;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Color.fromARGB(255, 83, 83, 83),
              content: Text('Press back button again to exit'),
            ),
          );
          return Future.value(false);
        } else {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MRF OutDoor Dashboard'),
          actions: [
            IconButton(
                onPressed: () {
                  logOutAlertDialog(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Inspection(getData: 1),
                          ),
                        );
                        // Navigator.pushNamed(context,'/inspectionform');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(47, 32, 32, 32),
                                blurRadius: 10.0,
                              ),
                            ]),
                        padding: EdgeInsets.all(10.sp),
                        width: 45.w,
                        child: Column(
                          children: [
                            Text(
                              totalinspection.length.toString(),
                              style: TextStyle(
                                  fontSize: 40.sp,
                                  color: primarycolor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            const Text(
                              'Total Inspection',
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Inspection(getData: 2),
                          ),
                        );
                        //  Navigator.pushNamed(context,'/inspectionform');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(47, 32, 32, 32),
                                blurRadius: 10.0,
                              ),
                            ]),
                        padding: EdgeInsets.all(10.sp),
                        width: 45.w,
                        child: Column(
                          children: [
                            Text(
                              totalincompleteinspection.length.toString(),
                              style: TextStyle(
                                  fontSize: 40.sp,
                                  color: primarycolor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            const Text(
                              'Inspection Incomplete',
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Inspection(getData: 3),
                          ),
                        );
                        //  Navigator.pushNamed(context,'/inspectionform');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(47, 32, 32, 32),
                                blurRadius: 10.0,
                              ),
                            ]),
                        padding: EdgeInsets.all(10.sp),
                        width: 45.w,
                        child: Column(
                          children: [
                            Text(
                              totalfirstinspection.length.toString(),
                              style: TextStyle(
                                  fontSize: 40.sp,
                                  color: primarycolor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5.sp,
                            ),
                            const Text(
                              'First Priority Inspection',
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //      Navigator.pushNamed(context,'/inspectionform');
                    //   },
                    //   child: Container(
                    //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,
                    //     boxShadow: const [
                    //       BoxShadow(color: Color.fromARGB(47, 32, 32, 32), blurRadius: 10.0,),
                    //     ]),
                    //     padding: EdgeInsets.all(10.sp),
                    //     width: 45.w,
                    //     child: Column(
                    //       children:  [
                    //         Text( '10',style: TextStyle(fontSize: 40.sp,color: primarycolor,fontWeight: FontWeight.bold),),
                    //         SizedBox(height: 5.sp,),
                    //         const Text('')
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
        drawer: const Sitemenuitem(),
      ),
    );
  }
}
