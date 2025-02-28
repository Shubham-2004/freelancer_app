import 'dart:convert';

import 'package:http/http.dart' as http;

class Freelancerdata {

  String url = 'http://192.168.77.236:8080/freelancer/getfreelancer/';

  Future<Map<String, dynamic>> getFreelancerData(String id) async {
    try {
      var response = await http.get(Uri.parse(url + id));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print("Successfully fetched the data");
        print(jsonResponse);
        return jsonResponse;
      } else {
        print("Unable to fetch the data");
        return {};
      }
    } catch (e) {
      print(e.toString());
      return {};
    }
  }
}
