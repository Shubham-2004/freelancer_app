import 'package:flutter/material.dart';
import 'package:freelancer_app/chat_service/services/ai_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // For Pie Chart

const apiKey = "AIzaSyA8BMrypImr7UFL7NYrkqxAmggMWGom1vo";

class ClientProjectScreen extends StatefulWidget {
  final Map<String, dynamic> project;

  const ClientProjectScreen({super.key, required this.project});

  @override
  State<ClientProjectScreen> createState() => _ClientProjectScreenState();
}

class _ClientProjectScreenState extends State<ClientProjectScreen> {
  double profileMatchPercentage = 0; // To store the AI response
  bool isLoading = true; // To show loading state

  @override
  void initState() {
    super.initState();
    fetchProfileMatch();
  }

  Future<void> fetchProfileMatch() async {
    try {
      // Prepare the message for AI analysis
      String message =
          "Analyze the following project details and compare them with the freelancer's skills and experience. "
          "Project Title: ${widget.project['title']}, "
          "Project Description: ${widget.project['description']}, "
          "Skills Required: ${widget.project['skillsRequired'].join(', ')}. "
          "Provide a profile match percentage between 0 and 100.";

      // Call the AI service
      String response = await getAIResponse(
        message,
        "67c17d9973a6c0dcdeda8551",
      );

      // Extract the match percentage from the response
      double matchPercentage =
          double.tryParse(response.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

      setState(() {
        profileMatchPercentage = matchPercentage;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching profile match: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.project['title'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              widget.project['description'],
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 16),

            // Skills Required
            Text(
              'Skills Required:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[800],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  (widget.project['skillsRequired'] as List<dynamic>).map((
                    skill,
                  ) {
                    return Chip(
                      label: Text(skill),
                      backgroundColor: Colors.blue.shade100,
                      labelStyle: const TextStyle(color: Colors.blue),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 16),

            // Budget
            Text(
              'Budget: \$${widget.project['budget']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Status
            Text(
              'Status: ${widget.project['status']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Deadline
            Text(
              'Deadline: ${widget.project['deadline']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Profile Match Section
            Text(
              'Your Profile Match %',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[200],
              ),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              SfCircularChart(
                series: <CircularSeries>[
                  DoughnutSeries<ChartData, String>(
                    dataSource: [
                      ChartData('Match', profileMatchPercentage),
                      ChartData('Unmatch', 100 - profileMatchPercentage),
                    ],
                    pointColorMapper:
                        (ChartData data, _) =>
                            data.x == 'Match' ? Colors.green : Colors.red,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    radius: '80%',
                  ),
                ],
                legend: Legend(isVisible: true),
              ),
            Text(
              'Profile Match Percentage: $profileMatchPercentage%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Data model for the pie chart
class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
