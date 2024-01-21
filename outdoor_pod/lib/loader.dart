import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'commonstyle.dart';
class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context) async {
         final GlobalKey<State> keyLoader = GlobalKey<State>();
        
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
            child: WillPopScope(
                onWillPop: () async => false,
                child: SimpleDialog(
                  elevation: 0,
                  surfaceTintColor: Colors.red,
                    key: keyLoader,
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    children: <Widget>[
                      Center(
                        child: Column(children: [
                          SizedBox(
                            height: 25.h,
                          child:Image.asset('assets/images/loader.gif')

                          )
                        ]),
                      )
                    ])),
          );
        });
  }
  static Future<void> showAlertDialog(BuildContext context, GlobalKey key,megtype,message) async {
        
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5,sigmaY: 5),
            child: WillPopScope(
                onWillPop: () async => false,
                child: SimpleDialog(
                  elevation: 0,
                  surfaceTintColor: Colors.red,
                    key: key,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    children: <Widget>[
                      Center(
                        child: Column(children: [
                      (megtype =='success')
                      ? SizedBox(
                            height: 10.h,
                          child:Image.asset('assets/images/success.gif')

                          ): SizedBox(
                            height: 10.h,
                          child:Image.asset('assets/images/warning.gif')

                          ),
                          SizedBox(height: 3.h,),
                          Text('Testen',textAlign: TextAlign.center,style:TextStyle(color: primarycolor,fontSize: 18.sp,fontWeight: FontWeight.bold),),
                          SizedBox(height: 1.h,),
                          Text(message,textAlign: TextAlign.center,style:TextStyle(color: blackcolor,fontSize: 13.sp),),
                          SizedBox(height: 2.h,),
                          Align(
                            alignment: Alignment.center,
                            child:SizedBox(
                            width: 40.sp,
                            child: ElevatedButton(
                    style: loaderraisedButtonStyle,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('OK', style: TextStyle(color: Colors.white,fontSize: 13.sp)),
                  ),
                          )
                          )
                          
                           
                        ]),
                      )
                    ])),
          );
        });
  }
}