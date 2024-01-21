import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../loader.dart';
import '../service/service.dart';
import 'sitenav.dart';
import 'package:sizer/sizer.dart';
import '../commonstyle.dart';
import '../logoutaction.dart';
import 'package:file_picker/file_picker.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// ignore: must_be_immutable
class Inspectionform extends StatefulWidget {
  dynamic getData;
  Inspectionform({Key? key, @required this.getData}) : super(key: key);

  @override
  State<Inspectionform> createState() => _InspectionformState();
}

class _InspectionformState extends State<Inspectionform> {
  DateTime? _currentBackPressTime;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  int _index = 0;
  @override
  void initState() {
    super.initState();
    getaxledata();
    getpreviousReading();
    getserialnodropdown(0);
  }

  getaxledata() {
    var rtr = widget.getData['rtrno'];
    var subtest = widget.getData['subtestnoid'];
    // Dialogs.showLoadingDialog(context, _keyLoader);
    ApiService().getApi('md-getaxiles?rtr=$rtr&subtest=$subtest').then((value) {
      // Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        axledata = jsonDecode(value['response']);
        getaxlestatus();
      });
    });
  }
  List axlestatusdetails = [];
  List axletyrestatusdetails = [];
  getaxlestatus() {
    List data = [];
    for (var value in axledata) {
      data.add({"axleid": value['autoid']});
    }
    Dialogs.showLoadingDialog(context);
    ApiService()
        .postApi(
            'md-axilcompleteddetails?rtrid=${widget.getData['rtrno']}&subtestid=${widget.getData['subtestnoid']}',
            data)
        .then((value) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        axlestatusdetails = jsonDecode(value['response']);
      });
    });
  }

  getaxletyrestatus() {
    Dialogs.showLoadingDialog(context);
    ApiService()
        .getApi(
            'md-axiltyrecompleteddetails?rtrid=${widget.getData['rtrno']}&subtestid=${widget.getData['subtestnoid']}&axilid=${axiles.rawValue['axiecategoryid']}')
        .then((value) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        axletyrestatusdetails = jsonDecode(value['response']);
      });
    });
  }

  getserialnodropdown(loaderstatus) {
    if (loaderstatus == 1) {
      Dialogs.showLoadingDialog(context);
    }
    ApiService()
        .getApi(
            'md-getserialno-byrtr?autoid=${widget.getData['autoid']}&inspectiontable=${widget.getData['inspectiontype']}&subtest=${widget.getData['subtestnoid']}&rtrno=${widget.getData['rtrno']}')
        .then((value) {
      if (loaderstatus == 1) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      setState(() {
        serialNoOfVehicle = jsonDecode(value['response']);
      });
    });
  }

  getpreviousReading() {
    setState(() {
      var data = widget.getData['odometerreading'];
      vehicledetails.control('previousreading').value = data.toDouble();
      vehicledetails.control('kmscovered').value = data.toDouble();
    });
  }

  doubletostring(value) {
    String convert = value.toString();
    return convert;
  }

  gettyreDetails(position) {
    var id = widget.getData['subtestnoid'];
    Dialogs.showLoadingDialog(context);
    ApiService()
        .postApi(
            'tyredetails?positionid=$position&subtestid=$id&axilID=${axiles.control('axiecategoryid').value}&inspectiontype=${widget.getData['inspectiontype']}',
            '')
        .then((value) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        var data = jsonDecode(value['response']);
        tireserialNumberdisplay = data['serialid'];
        axiles.control('serialno').value = data['serialid'];
      });
    });
  }

  List axledata = [];
  List tyreremovedDropdown = [
    {'code': 'YES', 'lable': 'Yes'},
    {'code': 'NO', 'lable': 'No'}
  ];
  List tyresPositions = [];
  List serialNoOfVehicle = [];
  List previousgoovereading = [];
  var tirePositionname = '';
  var tireserialNumberdisplay = '';
  var tirePositionNumber = 0;
  var displayAxilName = '';
  bool showTyrePosition = false;

  bool tireInspectionStatus = false;

  var showRemovetireDate = '';

  final vehicledetails = FormGroup({
    'previousreading':
        FormControl<double>(value: null, validators: [Validators.required]),
    'currenreading':
        FormControl<double>(value: null, validators: [Validators.required]),
    'kmscovered':
        FormControl<double>(value: null, validators: [Validators.required]),
    'addkms': FormControl<double>(value: null),
    'subkms': FormControl<double>(value: null),
    'totalkms':
        FormControl<double>(value: null, validators: [Validators.required]),
  });

  final axiles = FormGroup({
    'axiecategoryid': FormControl(value: '', validators: [Validators.required]),
    'tyreposition': FormControl<int>(value: null),
    'serialno': FormControl(value: '', validators: [Validators.required]),
  });

  final tyreheadnessAndGroowsForm = FormGroup({
    'tyreremoved': FormControl(value: '', validators: [Validators.required]),
    'tyreremarks': FormControl(value: ''),
    'groowsArray': FormArray([]),
  });

  final tireheadnessdetails = FormGroup({
    'tyrekmscovered':
        FormControl<double>(value: null, validators: [Validators.required]),
    'treadhardness':
        FormControl<double>(value: null, validators: [Validators.required]),
    'tyrepressure': FormControl<double>(value: null),
    'observation': FormControl(value: ''),
  });

  final imageuploadForm = FormGroup({
    'imageupload1': FormControl(value: null),
    'imageupload2': FormControl(value: null),
    'imageupload3': FormControl(value: null),
    'imageupload4': FormControl(value: null),
  });

  FormArray get groowsArrayList =>
      tyreheadnessAndGroowsForm.control('groowsArray') as FormArray;

  getGroows() {
    tyreheadnessAndGroowsForm.control('groowsArray').reset();
    groowsArrayList.clear();
    Dialogs.showLoadingDialog(context);
    ApiService()
        .getApi(
            'md-getgoovesbyserialno?serialno=${axiles.rawValue['serialno']}&inspectiontable=${widget.getData['inspectiontype']}&autoid=${widget.getData['autoid']}')
        .then((value) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        previousgoovereading = jsonDecode(value['response']);
        groowsArrayList.add(grooveBuildForm12());
        groowsArrayList.add(grooveBuildForm3());
        groowsArrayList.add(grooveBuildForm6());
        groowsArrayList.add(grooveBuildForm9());
        // for (var i = 0; i < previousgoovereading.length; i++) {
        //   groowsArrayList.add(
        //     FormGroup({
        //     'clock12': FormControl<double>(
        //         value: (showRemovetireDate == 'NO')
        //             ? null
        //             : previousgoovereading[i]['sno'],
        //         validators: [Validators.required]),
        //     'clock03': FormControl<double>(
        //         value: (showRemovetireDate == 'NO')
        //             ? null
        //             : previousgoovereading[i]['o3clock']),
        //     'clock06': FormControl<double>(
        //         value: (showRemovetireDate == 'NO')
        //             ? null
        //             : previousgoovereading[i]['o6clock']),
        //     'clock09': FormControl<double>(
        //         value: (showRemovetireDate == 'NO')
        //             ? null
        //             : previousgoovereading[i]['o9clock']),
        //   }));
        // }
      });
    });
  }

  grooveBuildForm12() {
    final groovefrombuild = FormGroup({});
    for (var i = 0; i < previousgoovereading.length; i++) {
      groovefrombuild.addAll({
        '12clock${i + 1}': FormControl<double>(
            value: (showRemovetireDate == 'NO')
                ? null
                : previousgoovereading[i]['sno'],
            validators: [Validators.required])
      });
    }
    return groovefrombuild;
  }

  grooveBuildForm3() {
    final groovefrombuild = FormGroup({});
    for (var i = 0; i < previousgoovereading.length; i++) {
      groovefrombuild.addAll({
        '03clock${i + 1}': FormControl<double>(
            value: (showRemovetireDate == 'NO')
                ? null
                : previousgoovereading[i]['o3clock'],validators: [Validators.required])
      });
    }
    return groovefrombuild;
  }

  grooveBuildForm6() {
    final groovefrombuild = FormGroup({});
    for (var i = 0; i < previousgoovereading.length; i++) {
      groovefrombuild.addAll({
        '06clock${i + 1}': FormControl<double>(
            value: (showRemovetireDate == 'NO')
                ? null
                : previousgoovereading[i]['o6clock'],validators: [Validators.required])
      });
    }
    return groovefrombuild;
  }

  grooveBuildForm9() {
    final groovefrombuild = FormGroup({});
    for (var i = 0; i < previousgoovereading.length; i++) {
      groovefrombuild.addAll({
        '09clock${i + 1}': FormControl<double>(
            value: (showRemovetireDate == 'NO')
                ? null
                : previousgoovereading[i]['o9clock'],validators: [Validators.required])
      });
    }
    return groovefrombuild;
  }

  cleartyreheadnessForm() {
    setState(() {
      showRemovetireDate = "";
    });
    imageuploadForm.control('imageupload1').reset();
    imageuploadForm.control('imageupload2').reset();
    imageuploadForm.control('imageupload3').reset();
    imageuploadForm.control('imageupload4').reset();
    tyreheadnessAndGroowsForm.reset();
    tyreheadnessAndGroowsForm.markAsUntouched();
    tireheadnessdetails.control('tyrekmscovered').value =
        vehicledetails.control('kmscovered').value;
  }

  double totalKMSCoverdDisplay = 0;
  totalkmsCalculation() {
    // var pre = vehicledetails.control('previousreading').value ?? 0.00;
    var cur = vehicledetails.control('currenreading').value ?? 0.00;
    var add = vehicledetails.control('addkms').value ?? 0.00;
    var sub = vehicledetails.control('subkms').value ?? 0.00;
    var fitodo = double.parse(widget.getData['fitodometer']);
    vehicledetails.control('kmscovered').value = (cur - fitodo).toDouble();
    tireheadnessdetails.control('tyrekmscovered').value =
        (cur - fitodo).toDouble();
    vehicledetails.control('totalkms').value =
        (cur - fitodo + add - sub).toDouble();
    setState(() {
      totalKMSCoverdDisplay = (cur - fitodo + add - sub).toDouble();
    });
  }

  FilePickerResult? result;
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
              content:
                  Text('Press back button again to exit inspection screen'),
            ),
          );
          return Future.value(false);
        } else {
          Navigator.pushNamed(context, '/inspection');
        }
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
            child: Theme(
          data: ThemeData(
            canvasColor: const Color.fromARGB(255, 201, 201, 201),
            colorScheme: const ColorScheme.light(primary: primarycolor),
          ),
          child: Stepper(
            physics: const BouncingScrollPhysics(),
            margin: const EdgeInsets.all(0),
            elevation: 0,
            type: StepperType.horizontal,
            currentStep: _index,
            onStepCancel: () {
              if (_index > 0) {
                setState(() {
                  _index -= 1;
                });
              }
            },
            onStepContinue: () {
              if (_index <= 0) {
                setState(() {
                  _index += 1;
                });
              }
            },
            onStepTapped: (int index) {
              // setState(() {
              //   _index = index;
              // });
            },
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row();
            },
            steps: <Step>[
              Step(
                // state: _index>=0?StepState.complete:StepState.indexed,

                isActive: _index >= 0,
                title: const Text(''),
                content: ReactiveForm(
                  formGroup: vehicledetails,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 236, 236),
                          borderRadius: BorderRadius.all(Radius.circular(5.sp)),
                        ),
                        padding: EdgeInsets.all(10.sp),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sub Test No   :',
                                  style: cardTitleText,
                                ),
                                Text(
                                  widget.getData['subtestnodisplay'],
                                  style: cardBodyText,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Veh Reg No   :',
                                  style: cardTitleText,
                                ),
                                Text(
                                  widget.getData['vehregno'],
                                  style: cardBodyText,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Date of Last Inspection   :',
                                  style: cardTitleText,
                                ),
                                Text(
                                  widget.getData['lastinspectiondate'],
                                  style: cardBodyText,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Next Inspection Date   :',
                                  style: cardTitleText,
                                ),
                                Text(
                                  widget.getData['nextinspection'],
                                  style: cardBodyText,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Inspection Due in Days/Status   :',
                                  style: cardTitleText,
                                ),
                                Text(
                                  widget.getData['duedays'].toString(),
                                  style: cardBodyText,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Fit Odometer Reading   :',
                                  style: cardTitleText,
                                ),
                                Text(
                                  widget.getData['fitodometer'].toString(),
                                  style: cardBodyText,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(result != null
                      //         ? result?.files[0].name as String
                      //         : 'No Files Will Selected'),
                      //     ElevatedButton(
                      //       onPressed: () async {
                      //         result = await FilePicker.platform
                      //             .pickFiles(allowMultiple: true);
                      //         if (result == null) {
                      //           // print("No file selected");
                      //         } else {
                      //           setState(() {});
                      //           result?.files.forEach((element) {
                      //             // print(element.name);
                      //             // print(result);
                      //           });
                      //         }
                      //       },
                      //       child: const Text("File Picker"),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: 2.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 40.w,
                              child: ReactiveTextField(
                                formControlName: 'previousreading',
                                validationMessages: {
                                  'required': (error) => "Previous ODO"
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: textboxOutlineprimary,
                                  enabledBorder: borderenable,
                                  labelText: 'Previous ODO',
                                  labelStyle: textboxOutlineprimaryText,
                                  focusedBorder: textboxOutlineprimaryfocus,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              width: 40.w,
                              child: ReactiveTextField(
                                formControlName: 'kmscovered',
                                validationMessages: {
                                  'required': (error) =>
                                      "Please Enter Kms Covered"
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: textboxOutlineprimary,
                                  enabledBorder: borderenable,
                                  labelText: 'Kms Covered',
                                  labelStyle: textboxOutlineprimaryText,
                                  focusedBorder: textboxOutlineprimaryfocus,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 2.h),
                      SizedBox(
                          width: double.infinity,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                  child: ReactiveTextField(
                                    formControlName: 'currenreading',
                                    onChanged: (value) {
                                      totalkmsCalculation();
                                    },
                                    validationMessages: {
                                      'required': (error) =>
                                          "Please Enter Current ODO"
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: textboxOutlineprimary,
                                      enabledBorder: borderenable,
                                      labelText: 'Current ODO',
                                      labelStyle: textboxOutlineprimaryText,
                                      focusedBorder: textboxOutlineprimaryfocus,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 40.w,
                                  child: ReactiveTextField(
                                    formControlName: 'addkms',
                                    onChanged: (value) {
                                      totalkmsCalculation();
                                    },
                                    validationMessages: {
                                      'required': (error) =>
                                          "Please Enter Sub Kms"
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: textboxOutlineprimary,
                                      enabledBorder: borderenable,
                                      labelText: "Add Kms",
                                      labelStyle: textboxOutlineprimaryText,
                                      focusedBorder: textboxOutlineprimaryfocus,
                                    ),
                                  ),
                                ),
                              ])),

                      SizedBox(height: 2.h),
                      SizedBox(
                          width: double.infinity,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                  child: ReactiveTextField(
                                    formControlName: 'subkms',
                                    onChanged: (value) {
                                      totalkmsCalculation();
                                    },
                                    validationMessages: {
                                      'required': (error) => "Please Enter Km's"
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: textboxOutlineprimary,
                                      enabledBorder: borderenable,
                                      labelText: "Sub Kms",
                                      labelStyle: textboxOutlineprimaryText,
                                      focusedBorder: textboxOutlineprimaryfocus,
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 40.w,
                                //   child: ReactiveTextField(
                                //     formControlName: 'totalkms',
                                //     validationMessages: {
                                //       'required': (error) =>
                                //           "Please Enter Sub Km's"
                                //     },
                                //     keyboardType: TextInputType.number,
                                //     readOnly: true,
                                //     decoration: InputDecoration(
                                //       border: textboxOutlineprimary,
                                //       enabledBorder: borderenable,
                                //       labelText: "Totol Km's",
                                //       labelStyle: textboxOutlineprimaryText,
                                //       focusedBorder: textboxOutlineprimaryfocus,
                                //     ),
                                //   ),
                                // ),
                              ])),

                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: Border(
                              left: BorderSide(color: primarycolor, width: 5)),
                          color: Color.fromARGB(255, 236, 236, 236),
                        ),
                        child: Text(
                          ' Total Kms : ${totalKMSCoverdDisplay.toString()}',
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: blackcolor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: ReactiveFormConsumer(
                                builder: (context, form, child) {
                              return ElevatedButton(
                                style: raisedButtonStyle,
                                onPressed: () async {
                                  vehicledetails.markAllAsTouched();
                                  if (vehicledetails.valid) {
                                    setState(() {
                                      _index += 1;
                                    });
                                  } else {
                                    Dialogs.showAlertDialog(
                                        context,
                                        _keyLoader,
                                        'warning',
                                        'Please fill all the required fields');
                                  }
                                },
                                child:
                                    const Text("Next", style: raisedButtonText),
                              );
                            }),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              ),
              Step(
                // state: _index>=1?StepState.complete:StepState.indexed,
                isActive: _index >= 1,
                title: const Text(''),
                content: ReactiveForm(
                  formGroup: axiles,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              for (int x = 0; x < axledata.length; x++) ...[
                                GestureDetector(
                                  onTap: () {
                                    showTyrePosition = false;
                                    setState(() {
                                      displayAxilName = axledata[x]['axle'];
                                    });
                                    axiles.control('axiecategoryid').value =
                                        axledata[x]['autoid'];
                                    var getid =
                                        axiles.rawValue['axiecategoryid'];
                                    Dialogs.showLoadingDialog(context);
                                    ApiService()
                                        .postApi(
                                            'fitmentpositionmaster-getid?id=$getid',
                                            '')
                                        .then((value) {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      setState(() {
                                        tyresPositions = jsonDecode(
                                            value['responsedetails']);
                                        getaxletyrestatus();
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: (axlestatusdetails.isNotEmpty)
                                            ? axlestatusdetails[x] == true
                                                ? greencolor
                                                : primarycolor
                                            : primarycolor),
                                    child: Text(
                                      axledata[x]['axle'].toString(),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                )
                              ],
                            ],
                          )),

                      // ReactiveDropdownField<dynamic>(
                      //   // autovalidate: true,
                      //   formControlName: 'axiecategoryid',
                      //   onChanged: (value) {
                      //     var getid = axiles.rawValue['axiecategoryid'];
                      //     ApiService()
                      //         .postApi(
                      //             'fitmentpositionmaster-getid?id=$getid', '')
                      //         .then((value) {
                      //       setState(() {
                      //         tyresPositions =
                      //             jsonDecode(value['responsedetails']);
                      //       });
                      //     });
                      //   },
                      //   decoration: InputDecoration(
                      //     border: textboxOutlineprimary,
                      //     enabledBorder: borderenable,
                      //     labelText: 'Select Axle Type',
                      //     labelStyle: textboxOutlineprimaryText,
                      //     focusedBorder: textboxOutlineprimaryfocus,
                      //     contentPadding: EdgeInsets.symmetric(
                      //         horizontal: 10.sp, vertical: 15.sp),
                      //     floatingLabelStyle:
                      //         const TextStyle(color: primarycolor),
                      //   ),
                      //   validationMessages: {
                      //     'required': (error) => "Please Axle Type"
                      //   },

                      //   items: axledata
                      //       .map((status) => DropdownMenuItem(
                      //             alignment: AlignmentDirectional.centerStart,
                      //             value: status['autoid'],
                      //             child: Text(status['axle'].toString()),
                      //           ))
                      //       .toList(),
                      // ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: greencolor,
                              ),
                              SizedBox(
                                width: 10.sp,
                              ),
                              Text(
                                'Completed',
                                style: TextStyle(fontSize: 11.sp),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                color: primarycolor,
                              ),
                              SizedBox(
                                width: 10.sp,
                              ),
                              Text(
                                'Not Completed',
                                style: TextStyle(fontSize: 11.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(result != null
                      //         ? result?.files[0].name as String
                      //         : 'No Photo/Image here'),
                      //     ElevatedButton(
                      //       onPressed: () async {
                      //         result = await FilePicker.platform
                      //             .pickFiles(allowMultiple: true);
                      //         if (result == null) {
                      //           // print("No file selected");
                      //         } else {
                      //           setState(() {});
                      //           result?.files.forEach((element) {
                      //             // print(element.name);
                      //             // print(result);
                      //           });
                      //         }
                      //       },
                      //       child: const Text("Image Upload"),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 3.h,
                      // ),

                      (tyresPositions.isNotEmpty)
                          ? Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: primarycolor, width: 5)),
                                    color: Color.fromARGB(255, 236, 236, 236),
                                  ),
                                  child: Text(
                                    ' Axle : $displayAxilName',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: blackcolor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (tyresPositions.isNotEmpty)
                                        ? GestureDetector(
                                            onTap: () {
                                              gettyreDetails(1);
                                              cleartyreheadnessForm();
                                              setState(() {
                                                tireInspectionStatus =
                                                    axletyrestatusdetails[0];
                                                tirePositionNumber = 1;
                                                tirePositionname =
                                                    tyresPositions[0]
                                                            ['positionnames']
                                                        .toString();

                                                axiles
                                                        .control('tyreposition')
                                                        .value =
                                                    tyresPositions[0]['autoid'];
                                                showTyrePosition = true;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 110,
                                                  child: (axletyrestatusdetails
                                                          .isNotEmpty)
                                                      ? axletyrestatusdetails[
                                                                  0] ==
                                                              true
                                                          ? Image.asset(
                                                              'assets/images/styre.png')
                                                          : Image.asset(
                                                              'assets/images/dstyre.png')
                                                      : const SizedBox(),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  height: 20,
                                                  child: Text(
                                                    tyresPositions[0]
                                                            ['positionnames']
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                    (tyresPositions.length >= 3)
                                        ? Container(
                                            width: 10,
                                            height: 10,
                                            color: blackcolor,
                                          )
                                        : const SizedBox(),
                                    (tyresPositions.length >= 3)
                                        ? GestureDetector(
                                            onTap: () {
                                              gettyreDetails(3);
                                              cleartyreheadnessForm();
                                              setState(() {
                                                tireInspectionStatus =
                                                    axletyrestatusdetails[2];
                                                tirePositionNumber = 3;
                                                tirePositionname =
                                                    tyresPositions[0]
                                                            ['positionnames']
                                                        .toString();

                                                axiles
                                                        .control('tyreposition')
                                                        .value =
                                                    tyresPositions[0]['autoid'];

                                                showTyrePosition = true;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 110,
                                                  child: (axletyrestatusdetails
                                                          .isNotEmpty)
                                                      ? axletyrestatusdetails[
                                                                  2] ==
                                                              true
                                                          ? Image.asset(
                                                              'assets/images/styre.png')
                                                          : Image.asset(
                                                              'assets/images/dstyre.png')
                                                      : const SizedBox(),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  height: 20,
                                                  child: Text(
                                                    tyresPositions[2]
                                                            ['positionnames']
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                    (tyresPositions.length >= 2)
                                        ? Container(
                                            width: (tyresPositions.length >= 3)
                                                ? 70
                                                : 150,
                                            height: 10,
                                            color: blackcolor,
                                          )
                                        : const SizedBox(),
                                    (tyresPositions.length >= 4)
                                        ? GestureDetector(
                                            onTap: () {
                                              gettyreDetails(4);
                                              cleartyreheadnessForm();
                                              setState(() {
                                                tireInspectionStatus =
                                                    axletyrestatusdetails[3];
                                                tirePositionNumber = 4;
                                                tirePositionname =
                                                    tyresPositions[0]
                                                            ['positionnames']
                                                        .toString();

                                                axiles
                                                        .control('tyreposition')
                                                        .value =
                                                    tyresPositions[0]['autoid'];
                                                showTyrePosition = true;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 110,
                                                  child: (axletyrestatusdetails
                                                          .isNotEmpty)
                                                      ? axletyrestatusdetails[
                                                                  3] ==
                                                              true
                                                          ? Image.asset(
                                                              'assets/images/styre.png')
                                                          : Image.asset(
                                                              'assets/images/dstyre.png')
                                                      : const SizedBox(),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  height: 20,
                                                  child: Text(
                                                    tyresPositions[3]
                                                            ['positionnames']
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                    (tyresPositions.length >= 4)
                                        ? Container(
                                            width: 15,
                                            height: 10,
                                            color: blackcolor,
                                          )
                                        : const SizedBox(),
                                    (tyresPositions.length >= 2)
                                        ? GestureDetector(
                                            onTap: () {
                                              gettyreDetails(2);
                                              cleartyreheadnessForm();
                                              setState(() {
                                                tireInspectionStatus =
                                                    axletyrestatusdetails[1];
                                                tirePositionNumber = 2;
                                                tirePositionname =
                                                    tyresPositions[1]
                                                            ['positionnames']
                                                        .toString();

                                                axiles
                                                        .control('tyreposition')
                                                        .value =
                                                    tyresPositions[1]['autoid'];
                                                showTyrePosition = true;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 110,
                                                  child: (axletyrestatusdetails
                                                          .isNotEmpty)
                                                      ? axletyrestatusdetails[
                                                                  1] ==
                                                              true
                                                          ? Image.asset(
                                                              'assets/images/styre.png')
                                                          : Image.asset(
                                                              'assets/images/dstyre.png')
                                                      : const SizedBox(),
                                                ),
                                                SizedBox(
                                                  width: 60,
                                                  height: 20,
                                                  child: Text(
                                                    tyresPositions[1]
                                                            ['positionnames']
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                                // Text(tyresPositions[1]
                                                //         ['positionnames']
                                                //     .toString())
                                              ],
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     (tyresPositions.isNotEmpty)
                                //         ? Text(tyresPositions[0]['positionnames']
                                //             .toString())
                                //         : const SizedBox(),
                                //     (tyresPositions.length >= 2)
                                //         ? Text(tyresPositions[1]['positionnames']
                                //             .toString())
                                //         : const SizedBox(),
                                //   ],
                                // ),
                              ],
                            )
                          : const Text('No Axies are Selected'),
                      SizedBox(
                        height: (showTyrePosition == true) ? 3.h : 0,
                      ),
                      (showTyrePosition == true)
                          ? Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 236, 236, 236),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.sp)),
                              ),
                              padding: EdgeInsets.all(10.sp),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tyre Position   :',
                                        style: cardTitleText,
                                      ),
                                      Text(
                                        tirePositionname,
                                        style: cardBodyText,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Serial No   :',
                                        style: cardTitleText,
                                      ),
                                      Text(
                                        tireserialNumberdisplay,
                                        style: cardBodyText,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  ReactiveDropdownField<dynamic>(
                                    // autovalidate: true,
                                    onChanged: (value) {},
                                    formControlName: 'serialno',
                                    decoration: InputDecoration(
                                      border: textboxOutlineprimary,
                                      enabledBorder: borderenable,
                                      labelText: 'Change Serial No',
                                      labelStyle: textboxOutlineprimaryText,
                                      focusedBorder: textboxOutlineprimaryfocus,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.sp, vertical: 15.sp),
                                      floatingLabelStyle:
                                          const TextStyle(color: blackcolor),
                                    ),
                                    validationMessages: {
                                      'required': (error) =>
                                          "Please Select Tyre Removed"
                                    },
                                    dropdownColor: Colors.white,
                                    items: serialNoOfVehicle
                                        .map((status) => DropdownMenuItem(
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                              value: status,
                                              child: Text(
                                                status.toString(),
                                                selectionColor: Colors.red,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (tireInspectionStatus) {
                                          Dialogs.showAlertDialog(
                                              context,
                                              _keyLoader,
                                              'warning',
                                              'Inspection already done!');
                                        } else {
                                          setState(() {
                                            _index += 1;
                                            showTyrePosition = false;
                                          });
                                        }
                                      },
                                      child: Text('Inspect',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp)),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(height: 3.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: ElevatedButton(
                              style: backraisedButtonStyle,
                              onPressed: () async {
                                setState(() {
                                  _index -= 1;
                                });
                              },
                              child:
                                  const Text("Back", style: raisedButtonText),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              ),
              Step(
                // state: _index>=2?StepState.complete:StepState.indexed,
                isActive: _index >= 2,
                title: const Text(''),
                content: Column(
                  children: [
                    ReactiveForm(
                      formGroup: tyreheadnessAndGroowsForm,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(result != null
                            //         ? result?.files[0].name as String
                            //         : 'No Image Selected'),
                            //     ElevatedButton(
                            //       onPressed: () async {
                            //         result = await FilePicker.platform
                            //             .pickFiles(allowMultiple: true);
                            //         if (result == null) {
                            //           // print("No file selected");
                            //         } else {
                            //           setState(() {});
                            //           result?.files.forEach((element) {
                            //             // print(element.name);
                            //             // print(result);
                            //           });
                            //         }
                            //       },
                            //       child: const Text("Tire Position Image"),
                            //     ),
                            //   ],
                            // ),
                            ReactiveDropdownField<dynamic>(
                              // autovalidate: true,
                              onChanged: (value) {
                                setState(() {
                                  showRemovetireDate = tyreheadnessAndGroowsForm
                                      .rawValue['tyreremoved']
                                      .toString();
                                  if (showRemovetireDate == 'YES') {
                                    tyreheadnessAndGroowsForm
                                        .control('tyreremarks')
                                        .setValidators([Validators.required]);
                                  } else {
                                    getGroows();
                                    tyreheadnessAndGroowsForm
                                        .control('tyreremarks')
                                        .clearValidators();
                                  }

                                  tyreheadnessAndGroowsForm
                                      .control('tyreremarks')
                                      .updateValueAndValidity();
                                });
                              },
                              formControlName: 'tyreremoved',
                              decoration: InputDecoration(
                                border: textboxOutlineprimary,
                                enabledBorder: borderenable,
                                labelText: 'Select Tyre Removed',
                                labelStyle: textboxOutlineprimaryText,
                                focusedBorder: textboxOutlineprimaryfocus,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.sp, vertical: 15.sp),
                                floatingLabelStyle:
                                    const TextStyle(color: blackcolor),
                              ),
                              validationMessages: {
                                'required': (error) =>
                                    "Please Select Tyre Removed"
                              },
                              dropdownColor: Colors.white,

                              items: tyreremovedDropdown
                                  .map((status) => DropdownMenuItem(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        value: status['code'],
                                        child: Text(status['lable'].toString()),
                                      ))
                                  .toList(),
                            ),
                            SizedBox(height: 3.h),
                            (showRemovetireDate == 'NO')
                                ? ReactiveFormArray(
                                    formArrayName: 'groowsArray',
                                    builder: (context, formArray, child) {
                                      final cities = groowsArrayList.controls
                                          .map(
                                              (control) => control as FormGroup)
                                          .map((currentform) {
                                        var index = groowsArrayList.controls
                                                .indexOf(currentform) +
                                            1;
                                        return ReactiveForm(
                                          formGroup: currentform,
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  (currentform
                                                          .rawValue.isNotEmpty)
                                                      ? Container(
                                                          width:
                                                              double.infinity,
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              218, 218, 218),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 5,
                                                                height: 30,
                                                                color:
                                                                    primarycolor,
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                              Text(
                                                                  "${index == 1 ? 12 : index == 2 ? 03 : index == 3 ? 06 : 09} o'clock"),
                                                            ],
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  SizedBox(height: 2.h),
                                                  for (int x = 0;
                                                      x <
                                                          currentform
                                                              .rawValue.length;
                                                      x++) ...[
                                                    (x.isEven)
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "G${x + 1}: ${doubletostring(previousgoovereading[x][index == 1 ? 'sno' : index == 2 ? 'o3clock' : index == 3 ? 'o6clock' : 'o9clock'])}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.sp),
                                                              ),
                                                              ((currentform.rawValue
                                                                              .length -
                                                                          1) >=
                                                                      x + 1)
                                                                  ? Text(
                                                                      "G${x + 2}: ${doubletostring(previousgoovereading[x + 1][index == 1 ? 'sno' : index == 2 ? 'o3clock' : index == 3 ? 'o6clock' : 'o9clock'])}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.sp),
                                                                    )
                                                                  : const SizedBox()
                                                            ],
                                                          )
                                                        : const SizedBox(),
                                                    SizedBox(height: 1.h),
                                                    (x.isEven)
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                                SizedBox(
                                                                  width: 40.w,
                                                                  child:
                                                                      ReactiveTextField(
                                                                    formControlName:
                                                                        '${index == 1 ? '12' : index == 2 ? '03' : index == 3 ? '06' : '09'}clock${x + 1}',
                                                                    onChanged:
                                                                        (value) {
                                                                      if (currentform
                                                                              .rawValue['${index == 1 ? '12' : index == 2 ? '03' : index == 3 ? '06' : '09'}clock${x + 1}'] !=
                                                                          null) {
                                                                        if (previousgoovereading[x][index == 1
                                                                                ? 'sno'
                                                                                : index == 2
                                                                                    ? 'o3clock'
                                                                                    : index == 3
                                                                                        ? 'o6clock'
                                                                                        : 'o9clock'] <
                                                                            currentform.rawValue['${index == 1 ? '12' : index == 2 ? '03' : index == 3 ? '06' : '09'}clock${x + 1}']) {
                                                                          Dialogs.showAlertDialog(
                                                                              context,
                                                                              _keyLoader,
                                                                              'warning',
                                                                              'Current Groove reading is \n greater then previous reading');
                                                                          currentform
                                                                              .control('${index == 1 ? '12' : index == 2 ? '03' : index == 3 ? '06' : '09'}clock${x + 1}')
                                                                              .value = null;
                                                                        }
                                                                      }
                                                                    },
                                                                    validationMessages: {
                                                                      'required':
                                                                          (error) =>
                                                                              "Please Enter G${x + 1}"
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border:
                                                                          textboxOutlineprimary,
                                                                      enabledBorder:
                                                                          borderenable,
                                                                      labelText:
                                                                          "Enter G${x + 1}",
                                                                      labelStyle:
                                                                          textboxOutlineprimaryText,
                                                                      focusedBorder:
                                                                          textboxOutlineprimaryfocus,
                                                                    ),
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                  ),
                                                                ),
                                                                ((currentform.rawValue.length -
                                                                            1) >=
                                                                        x + 1)
                                                                    ? SizedBox(
                                                                        width:
                                                                            40.w,
                                                                        child:
                                                                            ReactiveTextField(
                                                                          formControlName:
                                                                              '${index == 1 ? '12' : index == 2 ? '03' : index == 3 ? '06' : '09'}clock${x + 2}',
                                                                          onChanged:
                                                                              (value) {
                                                                            if (currentform.rawValue['${index == 1 ? '12' : index == 2 ? '03' : index == 3 ? '06' : '09'}clock${x + 2}'] !=
                                                                                null) {
                                                                              if (previousgoovereading[x + 1][index == 1
                                                                                      ? 'sno'
                                                                                      : index == 2
                                                                                          ? 'o3clock'
                                                                                          : index == 3
                                                                                              ? 'o6clock'
                                                                                              : 'o9clock'] <
                                                                                  currentform.rawValue['${index == 1 ? '12' : index == 2 ? '03' : index == 3 ? '06' : '09'}clock${x + 2}']) {
                                                                                Dialogs.showAlertDialog(context, _keyLoader, 'warning', 'Current Groove reading is \n greater then previous reading');
                                                                                currentform
                                                                                    .control('${index == 1 ? '12' : index == 2 ? '03' : index == 3 ? '06' : '09'}clock${x + 2}')
                                                                                    .value = null;
                                                                              }
                                                                            }
                                                                          },
                                                                          validationMessages: {
                                                                            'required': (error) =>
                                                                                "Please Enter G${x + 2}"
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            border:
                                                                                textboxOutlineprimary,
                                                                            enabledBorder:
                                                                                borderenable,
                                                                            labelText:
                                                                                "Enter G${x + 2}",
                                                                            labelStyle:
                                                                                textboxOutlineprimaryText,
                                                                            focusedBorder:
                                                                                textboxOutlineprimaryfocus,
                                                                          ),
                                                                          keyboardType:
                                                                              TextInputType.number,
                                                                        ),
                                                                      )
                                                                    : const SizedBox()
                                                              ])
                                                        : const SizedBox(),
                                                    SizedBox(height: 1.h),
                                                  ],

                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Text(
                                                  //       "12 o'Clock : ${doubletostring(previousgoovereading[index - 1]['sno'])}",
                                                  //       style: TextStyle(
                                                  //           fontSize: 12.sp),
                                                  //     ),
                                                  //     Text(
                                                  //       "3 o'Clock : ${doubletostring(previousgoovereading[index - 1]['o3clock'])}",
                                                  //       style: TextStyle(
                                                  //           fontSize: 12.sp),
                                                  //     )
                                                  //   ],
                                                  // ),
                                                  // SizedBox(height: 2.h),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                      return Wrap(
                                        runSpacing: 20,
                                        children: cities.toList(),
                                      );
                                    })
                                : const SizedBox(),
                            (showRemovetireDate == 'YES')
                                ? ReactiveTextField(
                                    formControlName: 'tyreremarks',
                                    validationMessages: {
                                      'required': (error) =>
                                          "Please Enter Remarks"
                                    },
                                    decoration: InputDecoration(
                                      border: textboxOutlineprimary,
                                      enabledBorder: borderenable,
                                      labelText: 'Enter Remarks',
                                      labelStyle: textboxOutlineprimaryText,
                                      focusedBorder: textboxOutlineprimaryfocus,
                                    ),
                                  )
                                : const SizedBox(),
                            SizedBox(
                                height:
                                    (showRemovetireDate == 'YES') ? 3.h : 0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                  child: ElevatedButton(
                                    style: backraisedButtonStyle,
                                    onPressed: () async {
                                      setState(() {
                                        _index -= 1;
                                      });
                                    },
                                    child: const Text("Back",
                                        style: raisedButtonText),
                                  ),
                                ),
                                (showRemovetireDate == 'YES')
                                    ? SizedBox(
                                        width: 40.w,
                                        child: ElevatedButton(
                                          style: raisedButtonStyle,
                                          onPressed: () async {
                                            tyreheadnessAndGroowsForm
                                                .markAllAsTouched();
                                            if (tyreheadnessAndGroowsForm
                                                .valid) {
                                              var data = {
                                                'groove':
                                                    tyreheadnessAndGroowsForm
                                                        .rawValue
                                              };

                                              var groovereading = [];
                                              var groove = {};

                                              for (var x = 0;
                                                  x <
                                                      previousgoovereading
                                                          .length;
                                                  x++) {
                                                groove['clock12'] =
                                                    groowsArrayList.rawValue[0]
                                                        [x]['12clock${x + 1}'];
                                                groove['clock03'] =
                                                    groowsArrayList.rawValue[1]
                                                        [x]['03clock${x + 1}'];
                                                groove['clock06'] =
                                                    groowsArrayList.rawValue[2]
                                                        [x]['06clock${x + 1}'];
                                                groove['clock09'] =
                                                    groowsArrayList.rawValue[3]
                                                        [x]['09clock${x + 1}'];
                                                if (groowsArrayList
                                                            .rawValue.length -
                                                        1 ==
                                                    x) {
                                                  groovereading.add(groove);
                                                  groove = {};
                                                }
                                              }
                                              data['groove']!['groowsArray'] =
                                                  groovereading;

                                              var serialnochangestaus = {
                                                "serialnoupdatestatus":
                                                    (tireserialNumberdisplay !=
                                                            axiles.rawValue[
                                                                'serialno'])
                                                        ? "MDID_0118_001"
                                                        : "",
                                                "preserialno":
                                                    tireserialNumberdisplay
                                              };
                                              var alldata = widget.getData
                                                ..addAll({
                                                  "tyrepositionnumber":
                                                      tirePositionNumber
                                                })
                                                ..addAll(axiles.rawValue)
                                                ..addAll(
                                                    vehicledetails.rawValue)
                                                ..addAll(tireheadnessdetails
                                                    .rawValue)
                                                ..addAll(data)
                                                ..addAll(serialnochangestaus);
                                              // print(alldata);
                                              Dialogs.showLoadingDialog(
                                                  context);
                                              ApiService()
                                                  .postApi(
                                                      'md-submitinspection',
                                                      alldata)
                                                  .then((value) {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                                if (value['StatusCode'] ==
                                                    '200') {
                                                  if (value['response'] ==
                                                      "C") {
                                                    Navigator.pushNamed(
                                                        context, '/inspection');
                                                    Dialogs.showAlertDialog(
                                                        context,
                                                        _keyLoader,
                                                        'success',
                                                        'Inspection Completed');
                                                  } else {
                                                    getaxlestatus();
                                                    getaxletyrestatus();
                                                    getserialnodropdown(1);
                                                    tireheadnessdetails.reset();
                                                    tireheadnessdetails
                                                        .markAsUntouched();
                                                    cleartyreheadnessForm();
                                                    defaultShowToast(
                                                        context, 'Data Saved');
                                                    setState(() {
                                                      _index -= 1;
                                                    });
                                                  }
                                                } else {
                                                  defaultShowToast(context,
                                                      'Data Not Saved');
                                                }
                                              }).catchError((err) {
                                                defaultShowToast(context,
                                                    'Please Contact Customer Care');
                                                throw err;
                                              });
                                            } else {
                                              Dialogs.showAlertDialog(
                                                  context,
                                                  _keyLoader,
                                                  'warning',
                                                  'Please fill all the required fields');
                                            }
                                          },
                                          child: const Text("Submit",
                                              style: raisedButtonText),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 40.w,
                                        child: ElevatedButton(
                                          style: raisedButtonStyle,
                                          onPressed: () async {
                                            tyreheadnessAndGroowsForm
                                                .markAllAsTouched();
                                            if (tyreheadnessAndGroowsForm
                                                .valid) {
                                              setState(() {
                                                _index += 1;
                                              });
                                            } else {
                                              Dialogs.showAlertDialog(
                                                  context,
                                                  _keyLoader,
                                                  'warning',
                                                  'Please fill all the required fields');
                                            }
                                          },
                                          child: const Text("Next",
                                              style: raisedButtonText),
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Step(
                // state: _index>=2?StepState.complete:StepState.indexed,
                isActive: _index >= 3,
                title: const Text(''),
                content: Column(
                  children: [
                    ReactiveForm(
                      formGroup: tireheadnessdetails,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 236, 236, 236),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.sp)),
                              ),
                              padding: EdgeInsets.all(10.sp),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tyre Description   :',
                                        style: cardTitleText,
                                      ),
                                      Text(
                                        tirePositionname,
                                        style: cardBodyText,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tyre Position   :',
                                        style: cardTitleText,
                                      ),
                                      Text(
                                        tirePositionname,
                                        style: cardBodyText,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Serial No   :',
                                        style: cardTitleText,
                                      ),
                                      Text(
                                        tireserialNumberdisplay,
                                        style: cardBodyText,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 3.h),
                            ReactiveTextField(
                              formControlName: 'tyrekmscovered',
                              decoration: InputDecoration(
                                border: textboxOutlineprimary,
                                enabledBorder: borderenable,
                                labelText: 'Enter Kms Covered',
                                labelStyle: textboxOutlineprimaryText,
                                focusedBorder: textboxOutlineprimaryfocus,
                              ),
                              keyboardType: TextInputType.number,
                              validationMessages: {
                                'required': (error) =>
                                    "Please Enter Kms Covered"
                              },
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            ReactiveTextField(
                              formControlName: 'treadhardness',
                              validationMessages: {
                                'required': (error) =>
                                    "Please Enter Tread Hardness"
                              },
                              decoration: InputDecoration(
                                border: textboxOutlineprimary,
                                enabledBorder: borderenable,
                                labelText: 'Enter Tread Hardness',
                                labelStyle: textboxOutlineprimaryText,
                                focusedBorder: textboxOutlineprimaryfocus,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 3.h),
                            ReactiveTextField(
                              formControlName: 'tyrepressure',
                              decoration: InputDecoration(
                                border: textboxOutlineprimary,
                                enabledBorder: borderenable,
                                labelText: 'Enter Tyre Pressure',
                                labelStyle: textboxOutlineprimaryText,
                                focusedBorder: textboxOutlineprimaryfocus,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 3.h),
                            ReactiveTextField(
                              formControlName: 'observation',
                              decoration: InputDecoration(
                                border: textboxOutlineprimary,
                                enabledBorder: borderenable,
                                labelText: 'Enter Observation',
                                labelStyle: textboxOutlineprimaryText,
                                focusedBorder: textboxOutlineprimaryfocus,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                  child: ElevatedButton(
                                    style: backraisedButtonStyle,
                                    onPressed: () async {
                                      setState(() {
                                        _index -= 1;
                                      });
                                    },
                                    child: const Text("Back",
                                        style: raisedButtonText),
                                  ),
                                ),
                                SizedBox(
                                  width: 40.w,
                                  child: ElevatedButton(
                                    style: raisedButtonStyle,
                                    onPressed: () {
                                      tireheadnessdetails.markAllAsTouched();
                                      if (tireheadnessdetails.valid) {
                                        setState(() {
                                          _index += 1;
                                        });
                                      } else {
                                        Dialogs.showAlertDialog(
                                            context,
                                            _keyLoader,
                                            'warning',
                                            'Please fill all the required fields');
                                      }
                                    },
                                    child: const Text("Next",
                                        style: raisedButtonText),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Step(
                // state: _index>=2?StepState.complete:StepState.indexed,
                isActive: _index >= 4,
                title: const Text(''),
                content: Column(
                  children: [
                    ReactiveForm(
                      formGroup: imageuploadForm,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (imageuploadForm.rawValue['imageupload1'] ==
                                        null)
                                    ? const Text('No Photo/Image here')
                                    : Image.memory(
                                        base64Decode(imageuploadForm
                                            .rawValue['imageupload1']
                                            .toString()),
                                        fit: BoxFit.cover,
                                        width: 100,
                                      ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await picker
                                        .pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 50)
                                        .then((value) {
                                      if (value != null) {
                                        _cropImage(
                                            File(value.path), 'imageupload1');
                                      }
                                    });
                                  },
                                  child: const Text("Image Upload"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (imageuploadForm.rawValue['imageupload2'] ==
                                        null)
                                    ? const Text('No Photo/Image here')
                                    : Image.memory(
                                        base64Decode(imageuploadForm
                                            .rawValue['imageupload2']
                                            .toString()),
                                        fit: BoxFit.cover,
                                        width: 100,
                                      ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await picker
                                        .pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 50)
                                        .then((value) {
                                      if (value != null) {
                                        _cropImage(
                                            File(value.path), 'imageupload2');
                                      }
                                    });
                                  },
                                  child: const Text("Image Upload"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (imageuploadForm.rawValue['imageupload3'] ==
                                        null)
                                    ? const Text('No Photo/Image here')
                                    : Image.memory(
                                        base64Decode(imageuploadForm
                                            .rawValue['imageupload3']
                                            .toString()),
                                        fit: BoxFit.cover,
                                        width: 100,
                                      ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await picker
                                        .pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 50)
                                        .then((value) {
                                      if (value != null) {
                                        _cropImage(
                                            File(value.path), 'imageupload3');
                                      }
                                    });
                                  },
                                  child: const Text("Image Upload"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (imageuploadForm.rawValue['imageupload4'] ==
                                        null)
                                    ? const Text('No Photo/Image here')
                                    : Image.memory(
                                        base64Decode(imageuploadForm
                                            .rawValue['imageupload4']
                                            .toString()),
                                        fit: BoxFit.cover,
                                        width: 100,
                                      ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await picker
                                        .pickImage(
                                            source: ImageSource.camera,
                                            imageQuality: 50)
                                        .then((value) {
                                      if (value != null) {
                                        _cropImage(
                                            File(value.path), 'imageupload4');
                                      }
                                    });
                                  },
                                  child: const Text("Image Upload"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 40.w,
                                  child: ElevatedButton(
                                    style: backraisedButtonStyle,
                                    onPressed: () async {
                                      setState(() {
                                        _index -= 1;
                                      });
                                    },
                                    child: const Text("Back",
                                        style: raisedButtonText),
                                  ),
                                ),
                                SizedBox(
                                  width: 40.w,
                                  child: ElevatedButton(
                                    style: raisedButtonStyle,
                                    onPressed: () {
                                      if (imageuploadForm
                                                  .rawValue['imageupload1'] ==
                                              null &&
                                          imageuploadForm
                                                  .rawValue['imageupload2'] ==
                                              null &&
                                          imageuploadForm
                                                  .rawValue['imageupload3'] ==
                                              null &&
                                          imageuploadForm
                                                  .rawValue['imageupload3'] ==
                                              null) {
                                        Dialogs.showAlertDialog(
                                            context,
                                            _keyLoader,
                                            'warning',
                                            'Please Capture Aleast\nOne Image');
                                      } else {
                                        var data = {
                                          'groove':
                                              tyreheadnessAndGroowsForm.rawValue
                                        };
                                        var groovereading = [];
                                        var groove = {};

                                        for (var x = 0;
                                            x < previousgoovereading.length;
                                            x++) {
                                          groove['clock12'] = groowsArrayList
                                              .rawValue[0]['12clock${x + 1}'];
                                          groove['clock03'] = groowsArrayList
                                              .rawValue[1]['03clock${x + 1}'];
                                          groove['clock06'] = groowsArrayList
                                              .rawValue[2]['06clock${x + 1}'];
                                          groove['clock09'] = groowsArrayList
                                              .rawValue[3]['09clock${x + 1}'];

                                          groovereading.add(groove);
                                          groove = {};
                                        }
                                        setState(() {
                                          data['groove']!['groowsArray'] =
                                              groovereading;
                                        });
                                        var serialnochangestaus = {
                                          "serialnoupdatestatus":
                                              (tireserialNumberdisplay !=
                                                      axiles
                                                          .rawValue['serialno'])
                                                  ? "MDID_0118_001"
                                                  : "",
                                          "preserialno": tireserialNumberdisplay
                                        };
                                        var alldata = widget.getData
                                          ..addAll({
                                            "tyrepositionnumber":
                                                tirePositionNumber
                                          })
                                          ..addAll(axiles.rawValue)
                                          ..addAll(vehicledetails.rawValue)
                                          ..addAll(imageuploadForm.rawValue)
                                          ..addAll(data)
                                          ..addAll(tireheadnessdetails.rawValue)
                                          ..addAll(serialnochangestaus);
                                        // print(alldata);
                                        Dialogs.showLoadingDialog(context);
                                        ApiService()
                                            .postApi(
                                                'md-submitinspection', alldata)
                                            .then((value) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          if (value['StatusCode'] == '200') {
                                            if (value['response'] == "C") {
                                              Navigator.pushNamed(
                                                  context, '/inspection');
                                              Dialogs.showAlertDialog(
                                                  context,
                                                  _keyLoader,
                                                  'success',
                                                  'Inspection Completed');
                                            } else {
                                              getaxlestatus();
                                              getaxletyrestatus();
                                              getserialnodropdown(1);
                                              tireheadnessdetails.reset();
                                              tireheadnessdetails
                                                  .markAsUntouched();
                                              cleartyreheadnessForm();
                                              defaultShowToast(
                                                  context, 'Data Saved');
                                              setState(() {
                                                _index = _index - 3;
                                              });
                                            }
                                          } else {
                                            defaultShowToast(
                                                context, 'Data Not Saved');
                                          }
                                        }).catchError((err) {
                                          defaultShowToast(context,
                                              'Please Contact Customer Care');
                                          throw err;
                                        });
                                        // groowsArrayList1.clear();
                                        // groowsArrayList1.reset();
                                        // groowsArrayList1.updateValueAndValidity();
                                      }
                                    },
                                    child: const Text("Submit",
                                        style: raisedButtonText),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
        drawer: const Sitemenuitem(),
      ),
    );
  }

  _cropImage(File imgFile, String fromcontrolname) async {
    imageCache.clear();
    imageFile = File(imgFile.path);
    var compressimage = await FlutterImageCompress.compressAndGetFile(
        imageFile!.absolute.path, '${imageFile!.path}.jpg',
        quality: 100);
    setState(() {
      imageFile = File(compressimage!.path);
      var bytes = File(compressimage.path).readAsBytesSync();
      stringimage = base64Encode(bytes);
      imageuploadForm.control(fromcontrolname).value = base64Encode(bytes);
    });
  }

  File? imageFile;
  dynamic stringimage = '';
  final picker = ImagePicker();
}
