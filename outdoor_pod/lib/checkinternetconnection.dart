import 'package:internet_connection_checker/internet_connection_checker.dart';
class CheckInternetConnection{
  Future checkconnection()async{
    bool result = await InternetConnectionChecker().hasConnection;
    if(result != true){
      return 505;
    }
  }
}