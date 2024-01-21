import 'package:flutter/material.dart';
import '../commonstyle.dart';
import '../service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class Sitemenuitem extends StatefulWidget {
  const Sitemenuitem({Key? key}) : super(key: key);
  @override
  State<Sitemenuitem> createState() => _SitemenuitemState();
}

class _SitemenuitemState extends State<Sitemenuitem> {
  dynamic username;
  dynamic sidenavigationdata;
  dynamic sidemenudata=[{'autoid': 2182, 'path': 'transaction', 'name': 'Transaction(MD)', 'icon': 'fa fa-cogs', 'displayorder': 0, 'superparent': '#', 'childparent': '#','children': [
    {'autoid': 2183, 'path': 'inspection', 'name': 'Inspection', 'icon': 'gtregistrationprocess', 'displayorder': 0, 'superparent': 'Transaction(MD)', 'childparent': '#', 'children': [], 'screenorder': 'FA', 'screentype': 'M'},
    // {'autoid': 2184, 'path': 'inspection', 'name': 'Inspection Incomplete', 'icon': 'gtregistrationprocess', 'displayorder': 0, 'superparent': 'Transaction(MD)', 'childparent': '#', 'children': [], 'screenorder': 'FA', 'screentype': 'M'},
    // {'autoid': 2184, 'path': 'inspection', 'name': 'First Priority Inspection', 'icon': 'gtregistrationprocess', 'displayorder': 0, 'superparent': 'Transaction(MD)', 'childparent': '#', 'children': [], 'screenorder': 'FA', 'screentype': 'M'},
    {'autoid': 2184, 'path': 'dashboard', 'name': 'Fitment Pending', 'icon': 'gtregistrationprocess', 'displayorder': 0, 'superparent': 'Transaction(MD)', 'childparent': '#', 'children': [], 'screenorder': 'FA', 'screentype': 'M'},
    {'autoid': 2184, 'path': 'intransit', 'name': 'Intransit', 'icon': 'gtregistrationprocess', 'displayorder': 0, 'superparent': 'Transaction(MD)', 'childparent': '#', 'children': [], 'screenorder': 'FA', 'screentype': 'M'},
    // {'autoid': 2184, 'path': 'inspection', 'name': 'Complete List of Test', 'icon': 'gtregistrationprocess', 'displayorder': 0, 'superparent': 'Transaction(MD)', 'childparent': '#', 'children': [], 'screenorder': 'FA', 'screentype': 'M'},
    {'autoid': 2184, 'path': 'dashboard', 'name': 'Travel Plan', 'icon': 'gtregistrationprocess', 'displayorder': 0, 'superparent': 'Transaction(MD)', 'childparent': '#', 'children': [], 'screenorder': 'FA', 'screentype': 'M'},
    
    ] }];
  Map<String, IconData> iconMapping = {
    'gtregistrationprocess': Icons.edit_document,
    'gtweighment': Icons.graphic_eq,
    'curing': Icons.assignment_return,
    'loadingintoracksystem': Icons.filter_list,
    'issuetodispatch': Icons.live_help,
    'dispatch': Icons.merge_type,
    'handlingoftyresissuedforwheeltest': Icons.remove_from_queue,
    'acceptingtyreswithreturnablestatus': Icons.queue_play_next,
  };
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      // sidenavigationdata = prefs.getString("sidenavigationdata")!;
      // sidemenudata = json.decode(sidenavigationdata);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(5.w, 10.w, 5.w, 5.w),
            color: primarycolor,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 7.w,
                  backgroundColor: Colors.white,
                  child: Text(
                    (username != null) ? username[0] : 'N',
                    style: TextStyle(fontSize: 18.sp, color: primarycolor),
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  (username != null) ? username : 'Null',
                  style: TextStyle(fontSize: 15.sp, color: Colors.white),
                )
              ],
            ),
          ),
          SizedBox(
              height: 80.h,
              child: SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sidemenudata == null
                          ? 0
                          : sidemenudata[0]['children'].length,
                      itemBuilder: (BuildContext context, j) {
                        return (sidemenudata[0]['children'][j]['children']
                                    .length ==
                                0)
                            ? ListTile(
                                leading: Icon(iconMapping[sidemenudata[0]
                                    ['children'][j]['icon']]),
                                title: Text(
                                  sidemenudata[0]['children'][j]['name'],
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                onTap: () {
                                  ApiService().authResolver().then((value) {
                                    if (value['StatusCode'] == '401') {
                                      Navigator.pushNamed(context, '/');
                                    } else {
                                      Navigator.pushNamed(context,
                                          '/${sidemenudata[0]['children'][j]['path']}');
                                    }
                                  }).catchError((err) {
                                    Navigator.pushNamed(context, '/');
                                  });
                                },
                              )
                            : ExpansionTile(
                                title: Text(
                                  sidemenudata[0]['children'][j]['name'],
                                  style: TextStyle(fontSize: 13.sp),
                                ),
                                //add icon
                                //children padding
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: sidemenudata[0]['children'][j]
                                                  ['children'] ==
                                              null
                                          ? 0
                                          : sidemenudata[0]['children'][j]
                                                  ['children']
                                              .length,
                                      itemBuilder: (BuildContext context, k) {
                                        return ListTile(
                                          title: Text(
                                            sidemenudata[0]['children'][j]
                                                ['children'][k]['name'],
                                            style: TextStyle(fontSize: 13.sp),
                                          ),
                                          onTap: () {
                                            ApiService()
                                                .authResolver()
                                                .then((value) {
                                              if (value['StatusCode'] ==
                                                  '401') {
                                                Navigator.pushNamed(
                                                    context, '/');
                                              } else {
                                                Navigator.pushNamed(context,
                                                    '/${sidemenudata[0]['children'][j]['children'][k]['path']}');
                                              }
                                            }).catchError((onError) {
                                              Navigator.pushNamed(context, '/');
                                            });
                                          },
                                        );
                                      })
                                ],
                              );
                      })))
        ],
      ),
    );
  }
}
