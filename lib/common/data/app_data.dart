import 'package:shared_preferences/shared_preferences.dart';
import 'package:webinar/common/data/api_public_data.dart';

class AppData {

  static Future saveAccessToken(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('access_token', data);
  }

  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('access_token') ?? '';
    return data;
  }


  static Future saveName(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('name', data);
  }

  static Future getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('name') ?? '';
    return data;
  }


  static Future saveCurrency(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('currency', data);
  }

  static Future getCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('currency') ?? (PublicData.apiConfigData?['currency']?['name'] ?? 'USD');

    if(data.isEmpty){
      data = (PublicData.apiConfigData?['currency']?['name'] ?? 'USD');
    }
    return data;
  }




  static Future saveIsFirst(bool data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool('is_first', data);
  }

  static Future getIsFirst() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_first') ?? true;
  }




  static Future saveTextbookToken(String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('textbook_token', data);
  }

  static Future<String> getTextbookToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('textbook_token') ?? '';
    return data;
  }

  // static String appName = 'Webinar';
  static bool canShowFinalizeSheet = true;
}
