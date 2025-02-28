import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:freelancer_app/client_side/service/clinet_services.dart';

class ClinetProjects extends StatefulWidget {
  const ClinetProjects({super.key});

  @override
  State<ClinetProjects> createState() => _ClinetProjectsState();
}

class _ClinetProjectsState extends State<ClinetProjects> {
  final ClinetServices clinetServices = ClinetServices();
  late Future<List<Map<String, dynamic>>> _futureClinetData;
  String tempClientId = "67b9769d58c8838fa0c63e4f";

  Future<List<Map<String, dynamic>>> getClientsData() async {
    try {
      Map<String, dynamic> data = await clinetServices.getAllClinetProjects(
        tempClientId,
      );
      return List<Map<String, dynamic>>.from(data["project"]);
    } catch (e) {
      print("Error fetching client projects: $e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _futureClinetData = getClientsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade900, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureClinetData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error fetching the data',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No projects available',
                style: TextStyle(color: Colors.black),
              ),
            );
          }

          List<Map<String, dynamic>> projects = snapshot.data!;

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              var project = projects[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (project['projectImage'] != null &&
                          project['projectImage'].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            project['projectImage'][0], // First Image
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 100),
                          ),
                        ),
                      const SizedBox(height: 10),

                      // Project Title
                      Text(
                        project['title'] ?? 'Untitled Project',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Description
                      Text(
                        project['description'] ?? 'No description available',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 10),

                      // Budget & Deadline
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "💰 Budget: \$${project['budget'] ?? 'N/A'}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            project['deadline'] != null
                                ? "📅 Deadline: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(project['deadline']))}"
                                : "📅 Deadline: N/A",
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Skills Required
                      if (project['skillsRequired'] != null &&
                          project['skillsRequired'].isNotEmpty)
                        Wrap(
                          spacing: 6,
                          children:
                              project['skillsRequired'].map<Widget>((skill) {
                                return Chip(
                                  label: Text(skill),
                                  backgroundColor: Colors.blue.shade100,
                                );
                              }).toList(),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
