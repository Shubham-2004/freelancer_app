import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:freelancer_app/backend/resume_backend.dart';
import 'package:freelancer_app/utils/widget/resume_widget.dart';

class UploadResumeScreen extends StatefulWidget {
  const UploadResumeScreen({Key? key}) : super(key: key);

  @override
  _UploadResumeScreenState createState() => _UploadResumeScreenState();
}

class _UploadResumeScreenState extends State<UploadResumeScreen> {
  File? _resumeFile;
  Map? _parsedData;
  String? _uploadStatus;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _titleController = TextEditingController();
  final _bioController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _profilePictureController = TextEditingController();
  final _skillsController = TextEditingController();
  final _languageController = TextEditingController();

  // Dynamic lists for portfolio, education, experience
  List<Map<String, dynamic>> _portfolio = [];
  List<Map<String, dynamic>> _education = [];
  List<Map<String, dynamic>> _experience = [];
  List<String> _skills = [];
  List<String> _languages = [];

  String _selectedAvailability = "Available";
  double _rating = 0.0;
  int _totalReviews = 0;

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _clearFields();
    _loadParsedData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _titleController.dispose();
    _bioController.dispose();
    _hourlyRateController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _profilePictureController.dispose();
    _skillsController.dispose();
    _languageController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _titleController.clear();
    _bioController.clear();
    _hourlyRateController.clear();
    _countryController.clear();
    _cityController.clear();
    _profilePictureController.clear();
    _portfolio.clear();
    _education.clear();
    _experience.clear();
    _skills.clear();
    _languages.clear();
    _selectedAvailability = "Available";
    _rating = 0.0;
    _totalReviews = 0;
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          _resumeFile = File(result.files.single.path!);
          _uploadStatus = 'File selected: ${_resumeFile!.path.split('/').last}';
        });
        _clearFields();
        await ResumeBackend.clearSharedPreferences();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: ${e.toString()}')),
      );
    }
  }

  Future<void> _parseResume() async {
    if (_resumeFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a resume first')),
      );
      return;
    }

    try {
      final parsedData = await ResumeBackend.parseResume(_resumeFile!);
      setState(() {
        _parsedData = parsedData;
        _uploadStatus = 'Resume uploaded successfully!';
      });

      await ResumeBackend.saveParsedDataToSharedPreferences(_parsedData);
      _loadParsedDataIntoFields(_parsedData);
    } catch (e) {
      setState(() {
        _uploadStatus = 'Error uploading resume';
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  Future<void> _loadParsedData() async {
    try {
      final data = await ResumeBackend.loadParsedDataFromSharedPreferences();
      if (data != null) {
        setState(() {
          _parsedData = data;
          _loadParsedDataIntoFields(data);
        });
      }
    } catch (e) {
      print('Error loading parsed data: $e');
    }
  }

  void _loadParsedDataIntoFields(Map? data) {
    if (data != null) {
      _firstNameController.text = data['firstName']?.toString() ?? '';
      _lastNameController.text = data['lastName']?.toString() ?? '';
      _titleController.text = data['title']?.toString() ?? '';
      _bioController.text = data['bio']?.toString() ?? '';
      _hourlyRateController.text = data['hourlyRate']?.toString() ?? '';
      _countryController.text = data['location']?['country']?.toString() ?? '';
      _cityController.text = data['location']?['city']?.toString() ?? '';
      _profilePictureController.text = data['profilePicture']?.toString() ?? '';

      // Load skills and languages
      _skills = List<String>.from(data['skills'] ?? []);
      _languages = List<String>.from(data['languages'] ?? []);

      // Load portfolio
      _portfolio = List<Map<String, dynamic>>.from(data['portfolio'] ?? []);

      // Load education
      _education = List<Map<String, dynamic>>.from(data['education'] ?? []);

      // Load experience
      _experience = List<Map<String, dynamic>>.from(data['experience'] ?? []);

      // Load rating and total reviews
      _rating = data['rating']?.toDouble() ?? 0.0;
      _totalReviews = data['totalReviews']?.toInt() ?? 0;
    }
  }

  Future<void> _submitProfile() async {
    final profileData = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'title': _titleController.text,
      'bio': _bioController.text,
      'skills': _skills,
      'hourlyRate': double.tryParse(_hourlyRateController.text) ?? 0.0,
      'availability': _selectedAvailability,
      'portfolio': _portfolio,
      'education': _education,
      'experience': _experience,
      'languages': _languages,
      'location': {
        'country': _countryController.text,
        'city': _cityController.text,
      },
      'profilePicture': _profilePictureController.text,
      'rating': _rating,
      'totalReviews': _totalReviews,
    };

    try {
      await ResumeBackend.submitProfile(profileData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting profile: ${e.toString()}')),
      );
    }
  }

  Widget _buildPortfolioSection() {
    return Column(
      children: [
        const Text(
          'Portfolio',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ..._portfolio.map((item) => _buildPortfolioItem(item)).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _portfolio.add({
                'projectName': '',
                'description': '',
                'link': '',
                'images': [],
              });
            });
          },
          child: const Text('Add Portfolio Item'),
        ),
      ],
    );
  }

  Widget _buildPortfolioItem(Map<String, dynamic> item) {
    final index = _portfolio.indexOf(item);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Project Name'),
              onChanged: (value) => _portfolio[index]['projectName'] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => _portfolio[index]['description'] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Link'),
              onChanged: (value) => _portfolio[index]['link'] = value,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Images (comma-separated URLs)',
              ),
              onChanged:
                  (value) =>
                      _portfolio[index]['images'] =
                          value.split(',').map((e) => e.trim()).toList(),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _portfolio.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection() {
    return Column(
      children: [
        const Text(
          'Education',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ..._education.map((item) => _buildEducationItem(item)).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _education.add({
                'institution': '',
                'degree': '',
                'fieldOfStudy': '',
                'marks': '',
                'CGPA': '',
              });
            });
          },
          child: const Text('Add Education'),
        ),
      ],
    );
  }

  Widget _buildEducationItem(Map<String, dynamic> item) {
    final index = _education.indexOf(item);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Institution'),
              onChanged: (value) => _education[index]['institution'] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Degree'),
              onChanged: (value) => _education[index]['degree'] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Field of Study'),
              onChanged: (value) => _education[index]['fieldOfStudy'] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Marks'),
              onChanged: (value) => _education[index]['marks'] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'CGPA'),
              onChanged: (value) => _education[index]['CGPA'] = value,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _education.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      children: [
        const Text(
          'Experience',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ..._experience.map((item) => _buildExperienceItem(item)).toList(),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _experience.add({
                'company': '',
                'position': '',
                'description': '',
                'startDate': '',
                'endDate': '',
              });
            });
          },
          child: const Text('Add Experience'),
        ),
      ],
    );
  }

  Widget _buildExperienceItem(Map<String, dynamic> item) {
    final index = _experience.indexOf(item);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Company'),
              onChanged: (value) => _experience[index]['company'] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Position'),
              onChanged: (value) => _experience[index]['position'] = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) => _experience[index]['description'] = value,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _experience[index]['startDate'] = DateFormat(
                            'yyyy-MM-dd',
                          ).format(picked);
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                      ),
                      child: Text(
                        _experience[index]['startDate'] ?? 'Select Start Date',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _experience[index]['endDate'] = DateFormat(
                            'yyyy-MM-dd',
                          ).format(picked);
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'End Date'),
                      child: Text(
                        _experience[index]['endDate'] ?? 'Select End Date',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _experience.removeAt(index);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return Container(
          child: Column(
            children: [
              CustomButton(label: 'Select Resume', onPressed: _pickFile),
              const SizedBox(height: 2),
              if (_uploadStatus != null)
                Text(
                  _uploadStatus!,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 2),
              if (_resumeFile != null)
                CustomButton(
                  label: 'Upload and Parse Resume',
                  onPressed: _parseResume,
                ),
              const SizedBox(height: 2),
              CustomTextField(
                label: 'First Name',
                controller: _firstNameController,
              ),
              CustomTextField(
                label: 'Last Name',
                controller: _lastNameController,
              ),
              CustomTextField(label: 'Title', controller: _titleController),

              CustomTextField(
                label: 'Hourly Rate',
                controller: _hourlyRateController,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedAvailability,
                  items:
                      ["Available", "Busy", "On Vacation"]
                          .map(
                            (String value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedAvailability = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Availability',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        );
      case 1:
        return Column(
          children: [
            CustomTextField(label: 'Bio', controller: _bioController),
            CustomTextField(
              label: 'Skills (comma-separated)',
              controller:
                  TextEditingController()
                    ..text = _skills.join(',')
                    ..addListener(() {
                      _skills =
                          _skillsController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                    }),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Languages (comma-separated)',
              controller:
                  TextEditingController()
                    ..text = _languages.join(',')
                    ..addListener(() {
                      _languages =
                          _languageController.text
                              .split(',')
                              .map((e) => e.trim())
                              .toList();
                    }),
            ),
          ],
        );
      case 2:
        return _buildPortfolioSection();
      case 3:
        return Column(
          children: [
            _buildEducationSection(),
            const SizedBox(height: 16),
            _buildExperienceSection(),
          ],
        );
      case 4:
        return Column(
          children: [
            CustomTextField(label: 'Country', controller: _countryController),
            CustomTextField(label: 'City', controller: _cityController),
            CustomTextField(
              label: 'Profile Picture URL',
              controller: _profilePictureController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProfile,
              child: const Text('Submit Profile'),
            ),
          ],
        );
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Resume')),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: 5,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildPage(index),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_currentPage > 0)
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Previous'),
                ),
              if (_currentPage < 4)
                ElevatedButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Next'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
