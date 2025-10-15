import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/utils/constants.dart';
import 'package:webinar/common/utils/http_handler.dart';

class TextbookAuthService {
  static const String _baseUrl = 'http://127.0.0.1:8000';
  static const String _apiPrefix = '/api/development';
  static const String _apiKey = '1234';

  static Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_apiPrefix/auth/login'),
        headers: {
          'Accept': 'application/json',
          'x-api-key': _apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['status'] == 1 && responseData['data'] != null) {
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
      'x-api-key': _apiKey,
      'Content-Type': 'application/json',
    };
  }
}