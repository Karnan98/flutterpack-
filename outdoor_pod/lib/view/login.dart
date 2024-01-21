import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../service/login.service.dart';
import '../commonstyle.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter/services.dart';
import '../loader.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormBuilderState>();
  DateTime? _currentBackPressTime;
  var passwordShowHide=true;

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
        body: SafeArea(
            child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FormBuilder(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 140,
                        child: Image.asset('assets/images/MRF-logo.png'),
                      ),
                      const SizedBox(height: 40),
                      FormBuilderTextField(
                        name: 'username',
                        enabled: true,
                        decoration: InputDecoration(
                          border: textboxOutlineprimary,
                          enabledBorder: borderenable,
                          labelText: 'Enter your username',
                          labelStyle: textboxOutlineprimaryText,
                          focusedBorder: textboxOutlineprimaryfocus,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          (val) {
                            return val == null ? "Please Enter Username" : null;
                          },
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 30),
                      FormBuilderTextField(
                        name: 'password',
                        enabled: true,
                        decoration: InputDecoration(
                          border: textboxOutlineprimary,
                          enabledBorder: borderenable,
                          labelText: 'Enter your Password',
                          labelStyle: textboxOutlineprimaryText,
                          focusedBorder: textboxOutlineprimaryfocus,
                          suffixIcon: IconButton(
                            onPressed: ()=>{ setState(() => (passwordShowHide==true)?passwordShowHide=false:passwordShowHide=true)},
                            icon: Icon((passwordShowHide==true)?Icons.lock:Icons.lock_open),
                          ),
                        ),
                        obscureText: passwordShowHide,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          (val) {
                            return val == null ? "Please Enter Password" : null;
                          },
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: raisedButtonStyle,
                        onPressed: () {
                          final validationSucess =
                              _formKey.currentState!.validate();
                          if (validationSucess) {
                            Dialogs.showLoadingDialog(context);
                            _formKey.currentState?.save();
                            final fromData = _formKey.currentState?.value;
                            FocusScope.of(context).unfocus();
                            LoginApi().login(fromData).then((value) {
                              Navigator.of(context,rootNavigator: true).pop();
                              if (value == '200') {
                                Navigator.pushNamed(context, '/dashboard');
                                return false;
                              } else if (value == '201') {
                                defaultShowToast(context,'Please Check Your Username And Password');
                                return false;
                              } else if (value == '300') {
                                defaultShowToast(context,'Please Check Your Internet Connection');
                                return false;
                              }else {
                                defaultShowToast( context, 'Please Contact Customer Care');
                                return false;
                              }
                            }).catchError((err){
                              Navigator.of(context,rootNavigator: true).pop();
                              defaultShowToast(context,'Please Contact Customer Care'); 
                              throw err;
                            });
                          }
                        },
                        child: const Text('Login', style: raisedButtonText),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Version - 1.0'),
                        ],
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: const [
                      //     Text('@Copyrights '),
                      //     Text('MAPOL GROUP',
                      //         style: TextStyle(color: primarycolor)),
                      //   ],
                      // )
                    ]),
              ),
            ),
          ),
        )),
      ),
    );
  }
}
