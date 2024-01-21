import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'sitenav.dart';
import 'package:sizer/sizer.dart';
import '../commonstyle.dart';
import '../logoutaction.dart';

class Intransitacknowledge extends StatefulWidget {
  const Intransitacknowledge({Key? key}) : super(key: key);

  @override
  State<Intransitacknowledge> createState() => _IntransitacknowledgeState();
}

class _IntransitacknowledgeState extends State<Intransitacknowledge> {
  String projectcode = '';
  String productcode = '';
  String projectversion = '';
  bool showprojectdetails = false;
  dynamic tabledata = [
    {
      'rtrno': '7567 A',
      'tireno': '1',
      'tc': 'T',
      'productdescription': '10.00-20 SM99',
      'serialno': '65422',
      'fitmentposition': '1FL',
      'updateserialno': '',
    },
    {
      'rtrno': '7567 A',
      'tireno': '2',
      'tc': 'T',
      'productdescription': '10.00-20 SM99',
      'serialno': '45622',
      'fitmentposition': '1FL',
      'updateserialno': '',
    },
    {
      'rtrno': '7567 A',
      'tireno': '3',
      'tc': 'T',
      'productdescription': '10.00-20 SM99',
      'serialno': '67222',
      'fitmentposition': '2FL',
      'updateserialno': '',
    },
    {
      'rtrno': '7567 A',
      'tireno': '4',
      'tc': 'T',
      'productdescription': '10.00-20 SM99',
      'serialno': '76522',
      'fitmentposition': '2FL',
      'updateserialno': '',
    },
  ];

  display3letter(count,value){
    var data='';
    for(int i=0;i<value.length;i++){
      if(count>i){
          data+=value[i];
      }else{
        data+='*';
      }
    }
    return data;
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intransit Acknowledge'),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: tabledata.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          color: const Color.fromARGB(255, 218, 218, 218),
                          child: Row(
                            children: [
                              Container(
                                width: 5,
                                height: 30,
                                color: primarycolor,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("RTR No : ${tabledata[index]['rtrno']}"),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  const Text("|"),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                      "Tire No : ${tabledata[index]['tireno']}"),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                            "Product Description : ${tabledata[index]['productdescription']}"),
                        Text(
                            "Fitment Position : ${tabledata[index]['fitmentposition']}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 40.w,
                                child: Text(
                                    "Serial No : ${tabledata[index]['serialno']}")),
                            SizedBox(
                                width: 40.w,
                                child: Text("T/C : ${tabledata[index]['tc']}")),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 40.w,
                              child: FormBuilderTextField(
                                name: 'serialno$index',
                                enabled: true,
                                keyboardType: TextInputType.number,
                                inputFormatters: const[
                                  // FilteringTextInputFormatter.digitsOnly,
                                  // CardNumberFormatter(),
                                ],
                                onChanged: (value) {
                                  
                                },
                                decoration: InputDecoration(
                                  border: textboxOutlineprimary,
                                  enabledBorder: borderenable,
                                  labelText: 'Update Serial No',
                                  labelStyle: textboxOutlineprimaryText,
                                  focusedBorder: textboxOutlineprimaryfocus,
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                            ),
                            SizedBox(
                              width: 40.w,
                              child: ElevatedButton(
                                style: raisedButtonStyle,
                                onPressed: () async {},
                                child: const Text("Update",
                                    style: raisedButtonText),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                            height:
                                ((tabledata.length - 1) != index) ? 4.h : 0),
                      ],
                    );
                  }),
              SizedBox(height: 3.h),
              const Divider(
                height: 2,
                color: blackcolor,
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 90.w,
                    child: ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: () async {},
                      child: const Text("Acknowledge", style: raisedButtonText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
      drawer: const Sitemenuitem(),
    );
  }
}

// class CardNumberFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue previousValue,
//     TextEditingValue nextValue,
//   ) {
//     var inputText = nextValue.text;
//     print(inputText);
//     print(nextValue.selection.baseOffset);
//     print(nextValue);

//     if (nextValue.selection.baseOffset == 0) {
//       return nextValue;
//     }

//     var bufferString = StringBuffer();
//     for (int i = 0; i < inputText.length; i++) {
//       if (i <= 2) {
//         bufferString.write(inputText[i]);
//       } else {
//         bufferString.write('*');
//       }
//     }

//     var string = bufferString.toString();
//     return nextValue.copyWith(
//       text: string,
//       selection: TextSelection.collapsed(
//         offset: string.length,
//       ),
//     );
//   }
// }
