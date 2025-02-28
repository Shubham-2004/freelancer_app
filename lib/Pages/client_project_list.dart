import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'client_project_screen.dart';

class ClientProjectList extends StatefulWidget {
  final String clientId;

  const ClientProjectList({super.key, required this.clientId});

  @override
  State<ClientProjectList> createState() => _ClientProjectListState();
}

class _ClientProjectListState extends State<ClientProjectList> {
  Map? client; // To store the fetched client
  bool isLoading = true; // To track loading state

  Future<void> fetchClient(String clientId) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.158.229:8080/clients/clientId/$clientId'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          client = jsonResponse['user']; // Extract the 'user' object
          isLoading = false;
        });
      } else {
        print("Unable to fetch the data");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchClient(widget.clientId); // Fetch client data for the specified ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : client == null
              ? const Center(child: Text('No client available'))
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            client!['profilePicture'] ?? '',
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    ),

                    // Name
                    Center(
                      child: Text(
                        '${client!['firstName'] ?? ''} ${client!['lastName'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Company Name
                    Center(
                      child: Text(
                        client!['companyName'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    // Location
                    Center(
                      child: Text(
                        '${client!['location']['city'] ?? ''}, ${client!['location']['country'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Projects Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Projects Posted',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // List of Projects
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: client!['projectsPosted']?.length ?? 0,
                      itemBuilder: (context, index) {
                        final project = client!['projectsPosted'][index];
                        return Card(
                          margin: const EdgeInsets.all(16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ClientProjectScreen(project: project),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Project Image
                                  project['projectImage'] != null &&
                                          project['projectImage'].isNotEmpty
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          project['projectImage'][0],
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : Container(
                                        height: 150,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Text('No Image Available'),
                                        ),
                                      ),

                                  const SizedBox(height: 8),

                                  // Title
                                  Text(
                                    project['title'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  // Description
                                  Text(
                                    project['description'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Skills Required
                                  Wrap(
                                    spacing: 8,
                                    children:
                                        (project['skillsRequired'] as List).map(
                                          (skill) {
                                            return Chip(
                                              label: Text(skill),
                                              backgroundColor:
                                                  Colors.blue.shade100,
                                              labelStyle: const TextStyle(
                                                color: Colors.blue,
                                              ),
                                            );
                                          },
                                        ).toList(),
                                  ),

                                  const SizedBox(height: 8),

                                  // Budget and Status
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Budget: \$${project['budget'] ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Chip(
                                        label: Text(project['status'] ?? ''),
                                        backgroundColor:
                                            project['status'] == 'Inprogress'
                                                ? Colors.orange.shade100
                                                : Colors.green.shade100,
                                        labelStyle: TextStyle(
                                          color:
                                              project['status'] == 'Inprogress'
                                                  ? Colors.orange
                                                  : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
