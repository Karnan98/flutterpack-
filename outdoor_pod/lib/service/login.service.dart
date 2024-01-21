import 'package:http/http.dart';
import '../model/login.model.dart';
import '../service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../environment.dart';

class LoginApi {
  saveLoginDetails(jsondata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("accesstoken", jsondata['accesstoken']);
    prefs.setInt("autoid", jsondata['autoid']);
    prefs.setString("username", jsondata['username']);
    prefs.setInt("employeeid", jsondata['autoid']);
    prefs.setString("display_name", jsondata['display_name']);
    prefs.setInt("roleid", jsondata['roleid']);
    getSiteNaviation(prefs.getInt('roleid'), prefs.getInt('employeeid'));
  }

  saveSideNavigationDetails(jsondata) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("sidenavigationdata", jsondata);
  }

  Future login(value) async {
    try {
      var uri = Uri.parse('${EnvironmentVariable().url}login');
      var headers = {"Content-type": "application/json"};
      var json = jsonEncode(value);
      final response = await post(uri, headers: headers, body: json);
      final statusCode = response.statusCode;
      if (statusCode == 200) {
        Login user = Login.fromJson(jsonDecode(response.body));
        var statusCode = user.statusCode;
        if (statusCode == '200') {
          final jsondata = jsonDecode(user.response);
          setWebTokken(jsondata['accesstoken']);
          saveLoginDetails(jsondata);
          return statusCode;
        } else {
          return statusCode;
        }
      }
    } catch (err) {
      return '300';
    }
  }

  Future getSiteNaviation(role, userid) async {
    try{
var uri = Uri.parse(
        '${EnvironmentVariable().url}getuserrolemenu-screen?id=$role&uid=$userid&Screen=M');
    var headers = {"Content-type": "application/json"};
    var json = '';

    final response = await post(uri, headers: headers, body: json);
    final statusCode = response.statusCode;
    if (statusCode == 200) {
      Sidenav body = Sidenav.fromJson(jsonDecode(response.body));
      final header = jsonDecode(body.header);
      saveSideNavigationDetails(jsonEncode(header));
    }
    }catch(err){
      rethrow;
    }
    
  }
}
