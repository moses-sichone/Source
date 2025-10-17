import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> postRawJson(
    String url,
    Map<String, dynamic> data, {
      Map<String, String>? headers,
    }) async {
  final req = http.Request('POST', Uri.parse(url));

  if (headers != null) req.headers.addAll(headers);
  req.bodyBytes = utf8.encode(jsonEncode(data));

  final streamedRes = await req.send();
  return http.Response.fromStream(streamedRes);
}

Future<http.Response> getRawJson(
    String url,
    {
      Map<String, String>? headers,
    }) async {
  final req = http.Request('GET', Uri.parse(url));

  if (headers != null) req.headers.addAll(headers);

  final streamedRes = await req.send();
  return http.Response.fromStream(streamedRes);
}

const apiKey = '1234';
