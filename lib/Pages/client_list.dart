import 'package:flutter/material.dart';
import 'package:freelancer_app/utils/widget/custom_appbar.dart';
import 'client_project_list.dart';

class ClientListScreen extends StatelessWidget {
  ClientListScreen({super.key});

  // Hardcoded list of clients
  final List<Map<String, dynamic>> clients = [
    {
      '_id': '67b8c6041d37de8c9a6fcd3e',
      'firstName': 'John',
      'lastName': 'Doe',
      'companyName': 'Tech Solutions',
      'location': {'city': 'New York', 'country': 'USA'},
      'profilePicture': 'https://via.placeholder.com/150',
    },
    {
      '_id': '67b9769d58c8838fa0c63e4f',
      'firstName': 'Jane',
      'lastName': 'Smith',
      'companyName': 'Innovate Inc.',
      'location': {'city': 'San Francisco', 'country': 'USA'},
      'profilePicture': 'https://via.placeholder.com/150',
    },
    {
      '_id': '67b97f7845bc27d1cbff55cb',
      'firstName': 'Alice',
      'lastName': 'Johnson',
      'companyName': 'Creative Minds',
      'location': {'city': 'Chicago', 'country': 'USA'},
      'profilePicture': 'https://via.placeholder.com/150',
    },
    {
      '_id': '67c17d51772f86f712638714',
      'firstName': 'Bob',
      'lastName': 'Brown',
      'companyName': 'Future Tech',
      'location': {'city': 'Austin', 'country': 'USA'},
      'profilePicture': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (context, index) {
          final client = clients[index];
          return Card(
            margin: const EdgeInsets.all(8),
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
                        (context) => ClientProjectList(clientId: client['_id']),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    Center(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          client['profilePicture'] ?? '',
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Name
                    Center(
                      child: Text(
                        '${client['firstName']} ${client['lastName']}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Company Name
                    Center(
                      child: Text(
                        client['companyName'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Location
                    Center(
                      child: Text(
                        '${client['location']['city']}, ${client['location']['country']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
