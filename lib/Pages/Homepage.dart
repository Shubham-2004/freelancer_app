import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_app/Services/FreelancerData.dart';
import 'package:freelancer_app/Services/Urllauncher.dart';
import 'package:freelancer_app/utils/widget/custom_appbar.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final User? firebaseUser = FirebaseAuth.instance.currentUser;
  final Freelancerdata freelancer = Freelancerdata();
  Map<String, dynamic> freelancerFetchedData = {};
  String tempId = "67c17cff73a6c0dcdeda8550";
  late Future<Map<String, dynamic>> _futureData;

  Future<Map<String, dynamic>> getData() async {
    Map<String, dynamic> data = await freelancer.getFreelancerData(tempId);
    freelancerFetchedData = data["user"];
    return freelancerFetchedData;
  }

  @override
  void initState() {
    super.initState();
    _futureData = getData();
  }

  TextStyle headingstyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 22,
  );

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
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(firebaseUser!.photoURL!),
                      radius: 60,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "${snapshot.data!["firstName"]} ${snapshot.data!["lastName"]}",
                      style: headingstyle,
                    ),
                  ),
                  Text(
                    snapshot.data!["title"],
                    style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                  ),
                  // location ns
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "📍 ${snapshot.data!["location"]["city"]}, ${snapshot.data!["location"]["country"]}",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "\$${snapshot.data!["hourlyRate"]}/hr",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 🔹 Availability
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color:
                            snapshot.data!["availability"] == "Available"
                                ? Colors.green
                                : Colors.red,
                        size: 14,
                      ),
                      SizedBox(width: 5),
                      Text(
                        snapshot.data!["availability"],
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // 🔹 Bio
                  Text(
                    "About Me",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    snapshot.data!["bio"],
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 20),

                  // 🔹 Skills
                  Text(
                    "Skills",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Wrap(
                    spacing: 5,
                    children:
                        snapshot.data!["skills"].map<Widget>((skill) {
                          return Chip(
                            label: Text(skill),
                            avatar: Icon(Icons.computer),
                            backgroundColor: Colors.green[900],
                            labelStyle: TextStyle(color: Colors.white),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 20),
                  // 🔹 Portfolio
                  Text(
                    "Portfolio",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Column(
                    children:
                        snapshot.data!["portfolio"].map<Widget>((project) {
                          return Card(
                            color: Colors.grey[850],
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading:
                                  project["images"].isNotEmpty
                                      ? Image.network(
                                        // project["images"][0],
                                        "https://www.ntaskmanager.com/wp-content/uploads/2020/02/What-is-a-Project-1-scaled.jpg",
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                      : Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                              title: Text(
                                project["projectName"],
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                project["description"],
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              onTap: () {
                                // launchURL(snapshot.data!["link"]);
                                launchURL(
                                  "https://www.amazon.in/", // not working work on it
                                );
                              },
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Education
                  Text(
                    "Education",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Column(
                    children:
                        snapshot.data!["education"].map<Widget>((edu) {
                          return ListTile(
                            title: Text(
                              edu["degree"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "${edu["institution"]} - ${edu["fieldOfStudy"]}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 20),

                  // 🔹 Experience
                  Text(
                    "Experience",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Column(
                    children:
                        snapshot.data!["experience"].map<Widget>((exp) {
                          return ListTile(
                            title: Text(
                              exp["position"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              "${exp["company"]} (${exp["startDate"]} - ${exp["endDate"] ?? "Present"})",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.white70,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 20),
                  // 🔹 Ratings
                  Text(
                    "Ratings & Reviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 22),
                      SizedBox(width: 5),
                      Text(
                        "${snapshot.data!["rating"]} ⭐ (${snapshot.data!["totalReviews"]} Reviews)",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
