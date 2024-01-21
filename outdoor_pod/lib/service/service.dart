import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../environment.dart';

dynamic logintokken = '';
setWebTokken(tokken) {
  logintokken = tokken;
}

var headers = {
  "Content-type": "application/json",
  "Authorization": "Bearer  $logintokken",
};

class ApiService {
  Future authResolver() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var autoid = prefs.getInt('autoid');
      var uri = Uri.parse(
          '${EnvironmentVariable().url}validateToken?token=$logintokken&username=$autoid');
      var response = await post(uri, headers: headers, body: '');
      var result = jsonDecode(response.body);
      return result;
    } catch (err) {
      rethrow;
    }
  }

  Future getApi(url) async {
    try {
      var uri = Uri.parse('${EnvironmentVariable().url}$url');
      var response = await get(uri, headers: headers);
      return jsonDecode(response.body);
    } catch (err) {
      rethrow;
    }
  }

  Future postApi(url, value) async {
    try {
      var uri = Uri.parse('${EnvironmentVariable().url}$url');
      var json = jsonEncode(value);
      var response = await post(uri, headers: headers, body: json);
      return jsonDecode(response.body);
    } catch (err) {
      rethrow;
    }
  }

  Future putApi(url, value) async {
    try {
      var uri = Uri.parse('${EnvironmentVariable().url}$url');
      var json = jsonEncode(value);
      var response = await post(uri, headers: headers, body: json);
      return response;
    } catch (err) {
      rethrow;
    }
  }

  Future deleteApi(url) async {
    try {
      var uri = Uri.parse('${EnvironmentVariable().url}$url');
      var response = await delete(uri, headers: headers);
      return response;
    } catch (err) {
      rethrow;
    }
  }
}
