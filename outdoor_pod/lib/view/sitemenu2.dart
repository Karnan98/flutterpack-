import 'package:flutter/material.dart';
import '../commonstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sizer/sizer.dart';
class SitemenuitemTwo extends StatefulWidget {
  const SitemenuitemTwo({Key? key}) : super(key: key);
  @override
  State<SitemenuitemTwo> createState() => _SitemenuitemTwoState();
}

class _SitemenuitemTwoState extends State<SitemenuitemTwo> {
  dynamic username;
  dynamic sidenavigationdata;
  dynamic sidemenudata;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      sidenavigationdata = prefs.getString("sidenavigationdata")!;
      sidemenudata = json.decode(sidenavigationdata);
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
                style: TextStyle(fontSize: 18.sp,color: primarycolor),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text((username != null) ? username : 'Null',style: TextStyle(fontSize: 15.sp,color: Colors.white),)
              ],
                 
          ),
        ),
          SizedBox(
            height: 80.h,
              child: SingleChildScrollView(
                child: ListView.builder(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                    itemCount: sidemenudata == null ? 0 : sidemenudata.length,
                    itemBuilder: (BuildContext context, i) {
                      return ExpansionTile(
                        
                        title: Text(sidemenudata[i]["name"],style: TextStyle(fontSize: 13.sp),),
                        leading: const Icon(Icons.person), //add icon
                        childrenPadding:
                            const EdgeInsets.only(left: 60), //children padding
                        children: [
                          ListView.builder(
                              
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: sidemenudata[i]['children'] == null
                                  ? 0
                                  : sidemenudata[i]['children'].length,
                              itemBuilder: (BuildContext context, j) {
                                return (sidemenudata[i]['children'][j]
                                                ['children']
                                            .length ==
                                        0)
                                    ? ListTile(
                                        title: Text(sidemenudata[i]['children']
                                            [j]['name'],style: TextStyle(fontSize: 13.sp),),
                                        onTap: () {
                                          Navigator.pushNamed(context, '/${sidemenudata[i]['children']
                                            [j]['path']}');
                                        },
                                      )
                                    : ExpansionTile(
                                            title: Text(sidemenudata[i]
                                                ['children'][j]['name'],style: TextStyle(fontSize: 13.sp),),
                                            //add icon
                                             //children padding
                                            children: [
                                             ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount:
                                           sidemenudata[i]['children']
                                            [j]['children'] == null
                                                ? 0
                                                : sidemenudata[i]['children']
                                            [j]['children']
                                                    .length,
                                        itemBuilder: (BuildContext context, k) {
                                          return  ListTile(
                                                title: Text(sidemenudata[i]['children']
                                            [j]['children'][k]['name'],style: TextStyle(fontSize: 13.sp),),
                                                onTap: () {
                                                  Navigator.pushNamed(context, '/${sidemenudata[i]['children']
                                            [j]['children'][k]['path']}');
                                                },
                                              );
                                        })
                                            ],
                                          );
                              })
                        ],
                      );
                    }),
              ))
        ],
      ),
    );
  }
}
