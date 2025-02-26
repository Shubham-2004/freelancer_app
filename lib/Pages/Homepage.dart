import 'package:flutter/material.dart';
import 'package:freelancer_app/Services/FreelancerData.dart';
import 'package:freelancer_app/Services/Urllauncher.dart';
import 'package:http/http.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Freelancerdata freelancer = Freelancerdata();
  Map<String, dynamic> freelancerFetchedData = {};
  String tempId = "67bef670c9c07382fdc7712a";
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
    color: Colors.black,
    fontSize: 22,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PORTFOLIO',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.teal[100],
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error getting the data'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
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
                      backgroundImage: NetworkImage(
                        "https://play-lh.googleusercontent.com/vco-LT_M58j9DIAxlS1Cv9uvzbRhB6cYIZJS7ocZksWRqoEPat_QXb6fVFi77lciJZQ=w526-h296-rw",
                        // snapshot.data["profilePicture"] -->use this for the actual data
                      ),
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
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  // location ns
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "📍 ${snapshot.data!["location"]["city"]}, ${snapshot.data!["location"]["country"]}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "\$${snapshot.data!["hourlyRate"]}/hr",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // 🔹 Bio
                  Text(
                    "About Me",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(snapshot.data!["bio"], style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),

                  // 🔹 Skills
                  Text(
                    "Skills",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Wrap(
                    spacing: 5,
                    children:
                        snapshot.data!["skills"].map<Widget>((skill) {
                          return Chip(
                            label: Text(skill),
                            avatar: Icon(Icons.computer),
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 20),
                  // 🔹 Portfolio
                  Text(
                    "Portfolio",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Column(
                    children:
                        snapshot.data!["portfolio"].map<Widget>((project) {
                          return Card(
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
                                      : Icon(Icons.image, size: 50),
                              title: Text(project["projectName"]),
                              subtitle: Text(project["description"]),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                // openUrl(snapshot.data!["link"]);
                                launchURL(
                                  "https://dribbble.com/search/ui-for-portfiliio-on-the-mobie", // not working work on it
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
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
                              ),
                            ),
                            subtitle: Text(
                              "${edu["institution"]} - ${edu["fieldOfStudy"]}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 20),

                  // 🔹 Experience
                  Text(
                    "Experience",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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
                              ),
                            ),
                            subtitle: Text(
                              "${exp["company"]} (${exp["startDate"]} - ${exp["endDate"] ?? "Present"})",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 20),
                  // 🔹 Ratings
                  Text(
                    "Ratings & Reviews",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
