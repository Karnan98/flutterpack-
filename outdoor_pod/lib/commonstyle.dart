
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

const Color primarycolor= Color.fromARGB(255, 235, 28, 36);
const Color blackcolor= Color.fromARGB(255, 30, 30, 30);
const Color greencolor= Color.fromARGB(255, 40, 153, 78);

const TextStyle raisedButtonText =  TextStyle(
  fontSize: 20,
);
 TextStyle tableButtontext =  TextStyle(
  fontSize: 10.sp,
);

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  
  foregroundColor: const Color.fromARGB(221, 255, 255, 255), backgroundColor:  primarycolor,
  minimumSize:  const Size.fromHeight(50),
  padding: const EdgeInsets.symmetric(horizontal: 40),
  shape:  const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    
  ),
);

final ButtonStyle tableraisedButtonStyle = ElevatedButton.styleFrom(
  
  foregroundColor: const Color.fromARGB(221, 255, 255, 255), backgroundColor:  Colors.green,
  minimumSize:  const Size.fromHeight(30),
  padding: const EdgeInsets.symmetric(horizontal: 15),
  shape:  const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    
  ),
);
final ButtonStyle loaderraisedButtonStyle = ElevatedButton.styleFrom(
  
  foregroundColor: const Color.fromARGB(221, 255, 255, 255), backgroundColor:  primarycolor,
  minimumSize:  const Size.fromHeight(30),
  padding: const EdgeInsets.symmetric(horizontal: 10),
  shape:  const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    
  ),
);

final ButtonStyle backraisedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: const Color.fromARGB(221, 255, 255, 255), backgroundColor:  blackcolor,
  minimumSize:  const Size.fromHeight(50),
  padding: const EdgeInsets.symmetric(horizontal: 40),
  shape:  const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    
  ),
);

final OutlineInputBorder textboxOutlineprimary= OutlineInputBorder(
            borderSide: const BorderSide(color: Color.fromARGB(255, 32, 32, 32), width: 1),
            borderRadius: BorderRadius.circular(5.0),
);

final OutlineInputBorder textboxOutlineprimaryfocus= OutlineInputBorder(
            borderSide: const BorderSide(color:  Color.fromARGB(255, 235, 28, 36), width: 1),
            borderRadius: BorderRadius.circular(5.0),
);
const OutlineInputBorder borderenable=  OutlineInputBorder(
                borderSide: BorderSide(color:  Color.fromARGB(255, 32, 32, 32), width: 1),
            );

const TextStyle textboxOutlineprimaryText= TextStyle(
  color: Color.fromARGB(255, 51, 51, 51)
);


void defaultShowToast(BuildContext context,msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void defaultShowToastSuccess(BuildContext context,msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(msg),
        action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }


 final TextStyle subtitle=TextStyle(
  fontSize: 13.sp,
  color: primarycolor,
  fontWeight: FontWeight.bold
);

 final TextStyle cardTitleText=TextStyle(
  fontSize: 12.sp,
  color: primarycolor,
);
 final TextStyle cardBodyText=TextStyle(
  fontSize: 12.sp,
  color: blackcolor,
);
 final TextStyle largetitle=TextStyle(
  fontSize: 20.sp,
  color: blackcolor,
);
 final TextStyle tableheader=TextStyle(
  fontSize: 13.sp,
  color: Colors.white,
);


 const BoxDecoration dropshadowBlack=  BoxDecoration(
  color: Colors.white,
      boxShadow: [
      BoxShadow(
        color: Color.fromARGB(31, 12, 12, 12),
        blurRadius: 25.0,
        spreadRadius: 0,
        offset: Offset(
          0,
          0,
        ),
      )
    ],
      );

      const TableBorder tableborder=TableBorder(
                top: BorderSide(color: Colors.grey, width: 0.5),
                left: BorderSide(color: Colors.grey, width: 0.5),
                right: BorderSide(color: Colors.grey, width: 0.5),
                bottom: BorderSide(color: Colors.grey, width: 0.5),        
                horizontalInside: BorderSide(color: Colors.grey, width: 0.5),
                );

