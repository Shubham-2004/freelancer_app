import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileProvider with ChangeNotifier {
  // Fields
  String _firstName = '';
  String _lastName = '';
  String _title = '';
  String _bio = '';
  List<String> _skills = [];
  double? _hourlyRate;
  String _availability = '';
  List<dynamic> _portfolio = [];
  List<dynamic> _education = [];
  List<dynamic> _experience = [];
  List<String> _languages = [];
  String _country = '';
  String _city = '';
  String _profilePicture = '';

  // Getters
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get title => _title;
  String get bio => _bio;
  List<String> get skills => _skills;
  double? get hourlyRate => _hourlyRate;
  String get availability => _availability;
  List<dynamic> get portfolio => _portfolio;
  List<dynamic> get education => _education;
  List<dynamic> get experience => _experience;
  List<String> get languages => _languages;
  String get country => _country;
  String get city => _city;
  String get profilePicture => _profilePicture;

  // Setters
  void setFirstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  void setLastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setBio(String value) {
    _bio = value;
    notifyListeners();
  }

  void setSkills(List<String> value) {
    _skills = value;
    notifyListeners();
  }

  void setHourlyRate(double? value) {
    _hourlyRate = value;
    notifyListeners();
  }

  void setAvailability(String value) {
    _availability = value;
    notifyListeners();
  }

  void setPortfolio(List<dynamic> value) {
    _portfolio = value;
    notifyListeners();
  }

  void setEducation(List<dynamic> value) {
    _education = value;
    notifyListeners();
  }

  void setExperience(List<dynamic> value) {
    _experience = value;
    notifyListeners();
  }

  void setLanguages(List<String> value) {
    _languages = value;
    notifyListeners();
  }

  void setCountry(String value) {
    _country = value;
    notifyListeners();
  }

  void setCity(String value) {
    _city = value;
    notifyListeners();
  }

  void setProfilePicture(String value) {
    _profilePicture = value;
    notifyListeners();
  }

  // Initialize fields from parsed data
  void initializeFromParsedData(Map<String, dynamic>? parsedData) {
    if (parsedData != null) {
      _firstName = parsedData['firstName']?.toString() ?? '';
      _lastName = parsedData['lastName']?.toString() ?? '';
      _title = parsedData['title']?.toString() ?? '';
      _bio = parsedData['bio']?.toString() ?? '';
      _skills = (parsedData['skills'] is List)
          ? List<String>.from(parsedData['skills'])
          : [];
      _hourlyRate = double.tryParse(parsedData['hourlyRate']?.toString() ?? '');
      _availability = parsedData['availability']?.toString() ?? '';
      _portfolio = parsedData['portfolio'] ?? [];
      _education = parsedData['education'] ?? [];
      _experience = parsedData['experience'] ?? [];
      _languages = (parsedData['languages'] is List)
          ? List<String>.from(parsedData['languages'])
          : [];
      _country = parsedData['location']?['country']?.toString() ?? '';
      _city = parsedData['location']?['city']?.toString() ?? '';
      _profilePicture = parsedData['profilePicture']?.toString() ?? '';
    }
    notifyListeners();
  }

  // Submit profile to backend
  Future<void> submitProfile(BuildContext context) async {
    final profile = {
      'firstName': _firstName,
      'lastName': _lastName,
      'title': _title,
      'bio': _bio,
      'skills': _skills,
      'hourlyRate': _hourlyRate,
      'availability': _availability,
      'portfolio': _portfolio,
      'education': _education,
      'experience': _experience,
      'languages': _languages,
      'location': {
        'country': _country,
        'city': _city,
      },
      'profilePicture': _profilePicture,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.77.236:8080/freelancers/createFreelancer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(profile),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}