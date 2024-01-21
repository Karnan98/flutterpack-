import 'package:flutter/material.dart';
import 'intransit_acknowledge.dart';
import 'sitenav.dart';
import 'package:sizer/sizer.dart';
import '../commonstyle.dart';
import '../logoutaction.dart';

class Intransit extends StatefulWidget {
  const Intransit({Key? key}) : super(key: key);

  @override
  State<Intransit> createState() => _IntransitState();
}

class _IntransitState extends State<Intransit> {
  String projectcode = '';
  String productcode = '';
  String projectversion = '';
  bool showprojectdetails = false;
  dynamic tabledata = [
                              {
                                'subtestno': '7567 A',
                                'vehtype': 'OTR',
                                'productgroup': 'PG2',
                                'testcreateddate': '05-01-2022',
                                'fitmentpendingindays': '180',
                              },
                              {
                                'subtestno': '7689 C',
                                'vehtype': 'BUS',
                                'productgroup': 'PG4',
                                'testcreateddate': '10-02-2022',
                                'fitmentpendingindays': '160',
                              },
                              {
                                'subtestno': '7689 D',
                                'vehtype': 'LT',
                                'productgroup': 'PG7',
                                'testcreateddate': '04-05-2022',
                                'fitmentpendingindays': '66',
                              },
                              
                            ];

  var genderOptions = ['Version 1', 'Version 2', 'Version 3'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intransit'),
        actions: [
          IconButton(
              onPressed: () {
                logOutAlertDialog(context);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(15.sp),
        child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tabledata.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ExpansionTile(
                          collapsedTextColor: blackcolor,
                          collapsedIconColor: blackcolor,
                          iconColor: Colors.white,
                          childrenPadding: EdgeInsets.all(5.sp),
                          textColor: Colors.white,
                          backgroundColor: primarycolor,
                          collapsedBackgroundColor:
                              const Color.fromARGB(255, 212, 212, 212),
                          title: Text(
                            'Sub Test No: ${tabledata[index]['subtestno']}',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Veh Type: ${tabledata[index]['vehtype']}',style: TextStyle(fontSize: 15.sp),
                          ),
                          children: [
                            const Divider(
                              color: Colors.white,
                              height: 1,
                            ),
                            Container(
                              color: primarycolor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 5.sp),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product Group :     ${tabledata[index]['productgroup']}',
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Test Created Date  :     ${tabledata[index]['testcreateddate']}',
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    'Fitment Pending in Days :     ${tabledata[index]['fitmentpendingindays']}',
                                    style:
                                        const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: ElevatedButton(
                                      onPressed: () {
                                         Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Intransitacknowledge(),
                                        ),
                                      );
                                      },
                                      child: Text('View',
                                          style: TextStyle(
                                              color: primarycolor,
                                              fontSize: 12.sp)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                      ],
                    );
                  })
            ]),
      )),
      drawer: const Sitemenuitem(),
    );
  }
}
