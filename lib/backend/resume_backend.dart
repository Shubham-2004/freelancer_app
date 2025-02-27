import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResumeBackend {
  static Future<Map?> parseResume(File file) async {
    try {
      var url = "http://192.168.158.229:8080/extractResumeDetails/";

      var request = http.MultipartRequest("POST", Uri.parse(url));

      var multipartFile = await http.MultipartFile.fromPath('file', file.path);

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseData);
        print(jsonData);
        print(responseData);
        print("PDF Upload Successful: $responseData");
      } else {
        print("PDF Upload Failed! Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  static Future<void> saveParsedDataToSharedPreferences(Map? parsedData) async {
    if (parsedData != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('parsedData', jsonEncode(parsedData));
    }
  }

  static Future<Map?> loadParsedDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('parsedData');
    return savedData != null ? jsonDecode(savedData) : null;
  }

  static Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('parsedData');
  }

  static Future<void> submitProfile(Map profileData) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.158.229:8080/freelancer/createfreelancer/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profileData),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to submit profile: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error submitting profile: ${e.toString()}');
    }
  }
}
