import 'dart:convert';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/utils/utils.dart';

import '../../../utils/util.dart';

class TextbookAuthService {
  static const String _baseUrl = 'https://vertxlearning.com';
  static const String _apiPrefix = '/api/development';


  static Future<bool> login(String email, String password) async {
    try {
      final response = await postRawJson(
        '$_baseUrl$_apiPrefix/login',
        headers: {
          'Accept': 'application/json',
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        {
          'username': email,
          'password': password,
        },
      );

      print(response.request?.headers);
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final token = responseData['data']['token'];
          
          // Save the token for future requests
          await AppData.saveTextbookToken(token);
          
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('Textbook login error: $e');
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    try {
      final token = await AppData.getTextbookToken();
      return token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<String> getToken() async {
    return await AppData.getTextbookToken();
  }

  static Future<void> logout() async {
    await AppData.saveTextbookToken('');
  }

  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'x-api-key': apiKey,
      'Content-Type': 'application/json',
    };
  }
}