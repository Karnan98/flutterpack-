import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:outdoor_pod/view/inspectionform.dart';
import 'package:sizer/sizer.dart';
import '../commonstyle.dart';
import '../loader.dart';
import '../logoutaction.dart';
import '../service/service.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';

// ignore: must_be_immutable
class Inspection extends StatefulWidget {
  dynamic getData = 0;
  Inspection({Key? key, @required this.getData}) : super(key: key);

  @override
  State<Inspection> createState() => _InspectionState();
}

class _InspectionState extends State<Inspection> {
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  String projectcode = '';
  String productcode = '';
  String projectversion = '';
  bool showprojectdetails = false;
  dynamic tabledata = [];
  dynamic getalldata = [];

  @override
  void initState() {
    super.initState();
    // _rtrTextboxfocus.addListener(getSubtestNoDropdown);
    getCustomerDropdown();
    reactivefrom.control('inspection').value = widget.getData;
  }

  getCustomerDropdown() {
    // Dialogs.showLoadingDialog(context, _keyLoader);
    ApiService().getApi('md-getcustomer-dropdown').then((value) {
      // Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        customer = jsonDecode(value['response']);
      });
    });
  }

  // getSubtestNoDropdown() {
  //   if (reactivefrom.rawValue['rtr'] != "") {
  //     ApiService()
  //         .getApi(
  //             'md-getsubtest-dropdown?rtrno=${reactivefrom.rawValue['rtr']}')
  //         .then((value) {
  //       setState(() {
  //         subtestno = [];
  //         reactivefrom.control('subtest').value = null;
  //         subtestno = jsonDecode(value['response']);
  //       });
  //     });
  //   }
  // }

  // int daysBetween(DateTime from, DateTime to) {
  //    from = DateTime(from.year, from.month, from.day);
  //    to = DateTime(to.year, to.month, to.day);
  //  return (to.difference(from).inHours / 24).round();
  // }

  // findpercentageofDuedaty(int dyedays,String modifieddate){
  //  int balancedays = daysBetween(DateTime.now(),DateFormat('yyyy-MM-dd').parse(modifieddate).add(Duration(days: dyedays)));
  //   balancedays=(balancedays.isNegative)?0:balancedays;
  //   return balancedays/dyedays*100;
  // }

  List deliveryStatus = [
    {'lable': 'Inspection', 'id': 1},
    {'lable': 'Inspection Incomplete', 'id': 2},
    {'lable': 'First Priority Inspection', 'id': 3},
  ];

  List customer = [];
  List subtestno = [];

  final reactivefrom = FormGroup({
    'inspection': FormControl<int>(value: 1, validators: [Validators.required]),
    'customername': FormControl<String>(value: null),
    'rtr': FormControl(value: null),
    'vehregno': FormControl<String>(value: null),
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
         Navigator.pushNamed(context, '/dashboard');
         return false;
       },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inspection'),
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
          child: ReactiveForm(
            formGroup: reactivefrom,
            child: SingleChildScrollView(
              child: Column(children: [
                ReactiveDropdownField<dynamic>(
                  // autovalidate: true,
                  formControlName: 'inspection',
                  decoration: InputDecoration(
                    border: textboxOutlineprimary,
                    enabledBorder: borderenable,
                    labelText: 'Select Inspection Type',
                    labelStyle: textboxOutlineprimaryText,
                    focusedBorder: textboxOutlineprimaryfocus,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                    floatingLabelStyle: const TextStyle(color: blackcolor),
                  ),
    
                  validationMessages: {
                    'required': (error) => "Please Enter  Inspection Type"
                  },
                  dropdownColor: Colors.white,
    
                  items: deliveryStatus
                      .map((status) => DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: status['id'],
                            child: Text(status['lable'].toString()),
                          ))
                      .toList(),
                ),
                SizedBox(height: 3.h),
                ReactiveDropdownSearch<dynamic, dynamic>(
                  formControlName: 'customername',
                  popupProps: const PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              hintText: 'Search Customer',
                              contentPadding: EdgeInsets.all(5)))),
                  clearButtonProps: ClearButtonProps(
                      icon: const Icon(Icons.clear),
                      alignment: AlignmentDirectional.centerEnd,
                      padding: const EdgeInsets.all(0),
                      iconSize: 15.sp,
                      isVisible: true,
                      color: Colors.grey),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: textboxOutlineprimary,
                      enabledBorder: borderenable,
                      labelText: 'Select Customer',
                      labelStyle: textboxOutlineprimaryText,
                      focusedBorder: textboxOutlineprimaryfocus,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.sp, vertical: 15.sp),
                      floatingLabelStyle: const TextStyle(color: blackcolor),
                    ),
                  ),
                  items: customer.map((status) => status['lable']).toList(),
                ),
                SizedBox(height: 3.h),
                ReactiveTextField(
                  formControlName: 'rtr',
                  // focusNode: _rtrTextboxfocus,
                  // onEditingComplete: (value) {
                  //   getSubtestNoDropdown();
                  // },
                  decoration: InputDecoration(
                    border: textboxOutlineprimary,
                    enabledBorder: borderenable,
                    labelText: 'Enter RTR No',
                    labelStyle: textboxOutlineprimaryText,
                    focusedBorder: textboxOutlineprimaryfocus,
                  ),
                  // validationMessages: {
                  //   'required': (error) => "Please Enter Rtr No"
                  // },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 3.h),
                ReactiveTextField(
                  formControlName: 'vehregno',
                  // focusNode: _rtrTextboxfocus,
                  // onEditingComplete: (value) {
                  //   getSubtestNoDropdown();
                  // },
                  decoration: InputDecoration(
                    border: textboxOutlineprimary,
                    enabledBorder: borderenable,
                    labelText: 'Enter Veh Reg No',
                    labelStyle: textboxOutlineprimaryText,
                    focusedBorder: textboxOutlineprimaryfocus,
                  ),
                  // validationMessages: {
                  //   'required': (error) => "Please Enter Rtr No"
                  // },
                ),
                // ReactiveDropdownSearch<dynamic, dynamic>(
                //   formControlName: 'subtest',
                //   popupProps: const PopupProps.menu(
                //       showSearchBox: true,
                //       searchFieldProps: TextFieldProps(
                //           decoration: InputDecoration(
                //               prefixIcon: Icon(Icons.search),
                //               hintText: 'Search Subtest',
                //               contentPadding: EdgeInsets.all(5)))),
                //   clearButtonProps: ClearButtonProps(
                //       icon: const Icon(Icons.clear),
                //       alignment: AlignmentDirectional.centerEnd,
                //       padding: const EdgeInsets.all(0),
                //       iconSize: 15.sp,
                //       isVisible: true,
                //       color: Colors.grey),
                //   dropdownDecoratorProps: DropDownDecoratorProps(
                //     dropdownSearchDecoration: InputDecoration(
                //       border: textboxOutlineprimary,
                //       enabledBorder: borderenable,
                //       labelText: 'Select Subtest',
                //       labelStyle: textboxOutlineprimaryText,
                //       focusedBorder: textboxOutlineprimaryfocus,
                //       contentPadding: EdgeInsets.symmetric(
                //           horizontal: 10.sp, vertical: 15.sp),
                //       floatingLabelStyle: const TextStyle(color: blackcolor),
                //     ),
                //   ),
                //   items: subtestno.map((status) => status['subtestno']).toList(),
                // ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 40.w,
                      child:
                          ReactiveFormConsumer(builder: (context, form, child) {
                        return ElevatedButton(
                          style: backraisedButtonStyle,
                          onPressed: () {
                            Navigator.pushNamed(context, '/dashboard');
                          },
                          child: const Text('Back', style: raisedButtonText),
                        );
                      }),
                    ),
                    SizedBox(
                      width: 40.w,
                      child:
                          ReactiveFormConsumer(builder: (context, form, child) {
                        return ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            reactivefrom.markAllAsTouched();
                            if (reactivefrom.rawValue['vehregno'] != null ||
                                reactivefrom.rawValue['rtr'] != null) {
                              if (reactivefrom.valid) {
                                var getcustomerid = customer
                                    .where((value) =>
                                        value['lable'] ==
                                        reactivefrom.rawValue['customername'])
                                    .toList();
                                // var getsubtestid = subtestno
                                //     .where((value) =>
                                //         value['subtestno'] ==
                                //         reactivefrom.rawValue['subtest'])
                                //     .toList();
    
                                Map<String, Object?> formdata =
                                    reactivefrom.rawValue;
                                formdata['customername'] =
                                    (getcustomerid.isNotEmpty)
                                        ? getcustomerid[0]['autoid']
                                        : 0;
                                // formdata['subtest'] = (getsubtestid.isNotEmpty)
                                //     ? getsubtestid[0]['autoid']
                                //     : 0;
                                Dialogs.showLoadingDialog(context);
                                ApiService()
                                    .postApi('getrtrdetail', formdata)
                                    .then((value) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  if (value['StatusCode'] == '200') {
                                    setState(() {
                                      tabledata = jsonDecode(value['response']);
                                      getalldata = jsonDecode(value['response']);
                                      if (reactivefrom.rawValue['inspection'] ==
                                          3) {
                                        tabledata = tabledata
                                            .where((value) =>
                                                value['statusinspection'] !=
                                                    "IC" &&
                                                value['duedays'] < 0)
                                            .toList();
                                        tabledata.sort((a,b)=>a['duedays'].compareTo(b['duedays']));
                                      } else if (reactivefrom
                                              .rawValue['inspection'] ==
                                          2) {
                                        tabledata = tabledata
                                            .where((value) =>
                                                value['statusinspection'] == "IC")
                                            .toList();
                                      } else {
                                        tabledata = tabledata
                                            .where((value) =>
                                                value['statusinspection'] != "IC")
                                            .toList();
                                      }
                                      if (tabledata.length == 0) {
                                        defaultShowToast(
                                            context, 'No data found');
                                      }
                                    });
                                  } else if (value['StatusCode'] == '201') {
                                    setState(() {
                                      tabledata = [];
                                    });
                                    Dialogs.showAlertDialog(context, _keyLoader,
                                        'warning', 'RTR No. Not Available');
                                  } else if (value['StatusCode'] == '202') {
                                    setState(() {
                                      tabledata = [];
                                    });
                                    Dialogs.showAlertDialog(context, _keyLoader,
                                        'warning', 'Data Not Available');
                                  }
                                }).catchError((err) {
                                  defaultShowToast(
                                      context, 'Please Contact Customer Care');
                                  throw err;
                                });
                              } else {
                                Dialogs.showAlertDialog(context, _keyLoader,
                                    'warning', 'Please Fill All Required Feilds');
                              }
                            } else {
                              Dialogs.showAlertDialog(context, _keyLoader,
                                  'warning', 'Please Fill RTR (or) VehReg No');
                            }
                          },
                          child: const Text('Get', style: raisedButtonText),
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.h,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   child: SingleChildScrollView(
                //     physics: const BouncingScrollPhysics(),
                //     scrollDirection: Axis.horizontal,
                //     child: DataTable(
                //       border: TableBorder(
                //         bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                //         top: BorderSide(width: 1, color: Colors.grey[200]!),
                //         left: BorderSide(width: 1, color: Colors.grey[200]!),
                //         right: BorderSide(width: 1, color: Colors.grey[200]!),
                //       ),
                //       headingTextStyle: TextStyle(
                //           color: Colors.white,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 12.sp),
                //       headingRowColor:
                //           MaterialStateColor.resolveWith((states) => primarycolor),
                //       columns: const [
                //         DataColumn(
                //           label: Text('Sub.\nTest No'),
                //         ),
                //         DataColumn(
                //           label: Text('Veh.\nReg .No'),
                //         ),
                //         DataColumn(
                //           label: Text('Date of\nLast Inspection'),
                //         ),
                //         DataColumn(
                //           label: Text('Next Inspection\n date'),
                //         ),
                //         DataColumn(
                //           label: Text('Inspeaction Due\nin Days/Status'),
                //         ),
                //         DataColumn(
                //           label: Text('Action'),
                //         ),
                //       ],
                //       rows: List.generate(
                //           tabledata.length,
                //           (index) => DataRow(
                //                 color: MaterialStateColor.resolveWith((states) =>
                //                     index % 2 == 1
                //                         ? Colors.grey[200]!
                //                         : Colors.transparent),
                //                 cells: <DataCell>[
                //                   DataCell(Text(tabledata[index]['subtestno'])),
                //                   DataCell(Text(tabledata[index]["vehno"])),
                //                   DataCell(Text(
                //                       tabledata[index]["dateoflastinspection"])),
                //                   DataCell(
                //                       Text(tabledata[index]["nextinspectiondate"])),
                //                   DataCell(Text(tabledata[index]["daysstatus"])),
                //                   DataCell(
                //                     ElevatedButton(
                //                       style: tableraisedButtonStyle,
                //                       onPressed: () {
                //                         Navigator.of(context).push(
                //                           MaterialPageRoute(
                //                             builder: (context) =>
                //                                 Inspectionform(wheettype:tabledata[index]["wheeltype"]),
                //                           ),
                //                         );
                //                       },
                //                       child:
                //                           Text('Inspect', style: tableButtontext),
                //                     ),
                //                   ),
                //                 ],
                //               )),
                //     ),
                //   ),
                // ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tabledata.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ExpansionTile(
                            collapsedTextColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            iconColor: Colors.white,
                            childrenPadding: EdgeInsets.all(5.sp),
                            textColor: Colors.white,
                            backgroundColor:
                                (tabledata[index]['inspectionstatus'] == 0)
                                    ? primarycolor
                                    : (tabledata[index]['inspectionstatus'] <= 25)
                                        ? const Color.fromARGB(255, 212, 103, 14)
                                        : const Color.fromARGB(255, 6, 133, 37),
                            collapsedBackgroundColor:
                                (tabledata[index]['inspectionstatus'] == 0)
                                    ? primarycolor
                                    : (tabledata[index]['inspectionstatus'] <= 25)
                                        ? const Color.fromARGB(255, 212, 103, 14)
                                        : const Color.fromARGB(255, 6, 133, 37),
                            title: Text(
                              'Sub Test No: ${tabledata[index]['subtestnodisplay'].toString()}',
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                'Veh Reg No: ${tabledata[index]['vehregno'].toString()}',
                                style: TextStyle(fontSize: 15.sp)),
                            children: [
                              const Divider(
                                color: Colors.white,
                                height: 1,
                              ),
                              Container(
                                color: (tabledata[index]['inspectionstatus'] == 0)
                                    ? primarycolor
                                    : (tabledata[index]['inspectionstatus'] <= 25)
                                        ? const Color.fromARGB(255, 212, 103, 14)
                                        : const Color.fromARGB(255, 6, 133, 37),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.sp, vertical: 5.sp),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   'Date of Last Inspection :   ${DateFormat.yMMMd().format(DateFormat('yyyy-MM-dd').parse(tabledata[index]['modifieddate'].toString()))}',
                                    //   style: const TextStyle(color: Colors.white),
                                    // ),
                                    // Text(
                                    //   'Next Inspection Date  :     ${DateFormat.yMMMd().format(DateFormat('yyyy-MM-dd').parse(tabledata[index]['modifieddate'].toString()).add(Duration(days: tabledata[index]['frequencydays'])))}',
                                    //   style: const TextStyle(color: Colors.white),
                                    // ),
                                    Text(
                                      'Date of Last Inspection :   ${tabledata[index]['lastinspectiondate'].toString()}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Next Inspection Date  :     ${tabledata[index]['nextinspection'].toString()}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'Inspection Due Days/Status :     ${tabledata[index]['duedays'].isNegative ? 'Over Due Days ${tabledata[index]['duedays']}' : tabledata[index]['duedays']}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          var data = getalldata
                                              .where((value) =>
                                                  value['rtrno'] ==
                                                      tabledata[index]['rtrno'] &&
                                                  value['subtestnoid'] ==
                                                      tabledata[index]
                                                          ['subtestnoid'] &&
                                                  value['statusinspection'] !=
                                                      "IC")
                                              .toList();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Inspectionform(
                                                      getData: data[0]),
                                            ),
                                          );
                                          // if (tabledata[index]
                                          //         ['inspectionstatus'] <=
                                          //     25) {
                                          //   Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           Inspectionform(
                                          //               getData:
                                          //                   tabledata[index]),
                                          //     ),
                                          //   );
                                          // } else {
                                          // Dialogs.showAlertDialog(
                                          //   context,
                                          //   _keyLoader,
                                          //   'warning',
                                          //   'Inspection Frequency Not Achieved');
                                          // }
                                        },
                                        child: Text('Inspect',
                                            style: TextStyle(
                                                color: (tabledata[index][
                                                            'inspectionstatus'] ==
                                                        0)
                                                    ? primarycolor
                                                    : (tabledata[index][
                                                                'inspectionstatus'] <=
                                                            25)
                                                        ? const Color.fromARGB(
                                                            255, 212, 103, 14)
                                                        : const Color.fromARGB(
                                                            255, 6, 133, 37),
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
            ),
          ),
        )),
      ),
    );
  }
}
