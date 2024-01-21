
import 'package:outdoor_pod/view/dashboard.dart';
import 'package:outdoor_pod/view/intransit.dart';
import 'package:outdoor_pod/view/login.dart';
import 'view/inspection.dart';
class RouterMenu{
  var routes={
          '/': (context) =>const Loginpage(),
          '/dashboard': (context) => const Dashboard(),
          '/inspection': (context) => Inspection(getData:1),
          '/inspectionform': (context) => Inspection(getData: 1),
          '/intransit': (context) => const Intransit(),
        };
 }

