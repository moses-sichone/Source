import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webinar/app/models/textbook_model.dart';
import 'package:webinar/app/services/textbook_service/textbook_auth_service.dart';

class TextbookService {
  static const String _baseUrl = 'https://vertxlearning.com';
  static const String _apiPrefix = '/api/development';

  static Future<List<TextbookModel>> getTextbooks({int? subjectId}) async {
    try {
      final headers = await TextbookAuthService.getHeaders();
      String url = '$_baseUrl$_apiPrefix/textbook/students';
      
      if (subjectId != null) {
        url += '?subject_id=$subjectId';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

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
      final headers = await TextbookAuthService.getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPrefix/textbook/chapters?textbook_id=$textbookId'),
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
      final headers = await TextbookAuthService.getHeaders();
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPrefix/textbook/subjects'),
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