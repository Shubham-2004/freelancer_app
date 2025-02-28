import 'dart:convert';

import 'package:http/http.dart' as http;

class ClinetServices {
  Future<Map<String, dynamic>> getClient(String id) async {
    String Url = "http://192.168.77.236:8080/clients/clientId/";

    try {
      var response = await http.get(Uri.parse(Url + id));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print("Successfully fetched the clinent data");
        print(jsonResponse);
        return jsonResponse;
      } else {
        return {"mag": "no data found for the user with the given id"};
      }
    } catch (e) {
      print(e.toString());

      return {};
    }
  }

  // get all the projects by the id of an user
  Future<Map<String, dynamic>> getAllClinetProjects(String clientId) async {
    String Url = "http://192.168.77.236:8080/projects/getAllClientProject/";

    try {
      var response = await http.get(Uri.parse(Url + clientId));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print("Successfully fetched the clinent projects data data");
        print(jsonResponse);
        return jsonResponse;
      } else {
        return {"mag": "no data found for the user with the given id"};
      }
    } catch (e) {
      print(e.toString());

      return {};
    }
  }
}
