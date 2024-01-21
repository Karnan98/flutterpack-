import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'commonstyle.dart';

logOutAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel",style: TextStyle(color: primarycolor,fontSize: 13.sp),),
    onPressed:  () {Navigator.pop(context);},
  );
  Widget continueButton = TextButton(
    child: Text("Ok",style: TextStyle(color: blackcolor,fontSize: 13.sp)),
    onPressed:  () {
      Navigator.pushNamed(context, '/');
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    surfaceTintColor: Colors.white,
    title: Text("Log Out !",style: TextStyle(fontSize: 18.sp),),
    content: Text("Are you sure you want to logout?",style: TextStyle(fontSize: 13.sp),),
    actions: [
      continueButton,
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}