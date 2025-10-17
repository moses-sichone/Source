import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webinar/app/models/textbook_model.dart';
import 'package:webinar/app/services/textbook_service/textbook_auth_service.dart';

import '../../../utils/util.dart';

class TextbookService {
  static const String _baseUrl = 'https://vertxlearning.com';
  static const String _apiPrefix = '/api/development';

  static Future<List<TextbookModel>> getTextbooks({int? subjectId}) async {
    try {
      print('getTextbooks');
      final headers = await TextbookAuthService.getHeaders();
      String url = '$_baseUrl$_apiPrefix/textbook/students';
      
      if (subjectId != null) {
        url += '?subject_id=$subjectId';
      }

      final response = await getRawJson(
        Uri.parse(url).toString(),
        headers: headers,
      );
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final textbooksJson = responseData['data']['textbooks'] as List;
          return textbooksJson.map((json) => TextbookModel.fromJson(json)).toList();
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching textbooks: $e');
      return [];
    }
  }

  static Future<TextbookDetailModel?> getTextbookChapters(int textbookId) async {
    try {
      print('getTextbookChapters');
      final headers = await TextbookAuthService.getHeaders();
      final response = await getRawJson(
        Uri.parse('$_baseUrl$_apiPrefix/textbook/students/chapters?textbook_id=$textbookId').toString(),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          return TextbookDetailModel.fromJson(responseData['data']);
        }
      }
      
      return null;
    } catch (e) {
      print('Error fetching textbook chapters: $e');
      return null;
    }
  }

  static Future<List<SubjectModel>> getSubjects() async {
    try {
      print('getSubjects');
      final headers = await TextbookAuthService.getHeaders();
      final response = await getRawJson(
        Uri.parse('$_baseUrl$_apiPrefix/textbook/students/subjects').toString(),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData['success'] == true && responseData['data'] != null) {
          final subjectsJson = responseData['data']['subjects'] as List;
          return subjectsJson.map((json) => SubjectModel.fromJson(json)).toList();
        }
      }
      
      return [];
    } catch (e) {
      print('Error fetching subjects: $e');
      return [];
    }
  }
}