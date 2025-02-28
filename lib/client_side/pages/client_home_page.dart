import 'package:flutter/material.dart';
import 'package:freelancer_app/client_side/service/clinet_services.dart';
import 'package:freelancer_app/utils/widget/custom_appbar.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  String tempClientId = "67b9769d58c8838fa0c63e4f";

  final ClinetServices clinetServices = ClinetServices();
  Map<String, dynamic> clientFetchdata = {};
  late Future<Map<String, dynamic>> _futureData;

  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> data = await clinetServices.getClient(tempClientId);
    clientFetchdata = data["user"];
    return clientFetchdata;
  }

  @override
  void initState() {
    super.initState();
    _futureData = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error getting the data',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            snapshot.data!["profilePicture"]!,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${snapshot.data!["firstName"]} ${snapshot.data!["lastName"]}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "📍 ${snapshot.data!["location"]["city"]}, ${snapshot.data!["location"]["country"]}",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          snapshot.data!["companyName"]!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          snapshot.data!["bio"]!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            Text(
                              " ${snapshot.data!["rating"]} (${snapshot.data!["totalReviews"]} Reviews)",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Projects Section
                Text(
                  "Projects Posted",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Column(
                  children:
                      snapshot.data!["projectsPosted"]!.map<Widget>((project) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    // project["projectImage"][0]! ?? "https://miro.medium.com/v2/resize:fit:1400/1*u4EBes6Muu2fy7iM8igMug.jpeg",
                                    "https://miro.medium.com/v2/resize:fit:1400/1*u4EBes6Muu2fy7iM8igMug.jpeg",
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  project["title"]!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  project["description"]!,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  children:
                                      project["skillsRequired"]!
                                          .map<Widget>(
                                            (skill) => Chip(label: Text(skill)),
                                          )
                                          .toList(),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Budget: \$${project["budget"]}",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Status: ${project["status"]}",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Deadline: ${project["deadline"]}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
