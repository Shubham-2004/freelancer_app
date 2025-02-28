import 'package:freelancer_app/Services/FreelancerData.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = "AIzaSyA8BMrypImr7UFL7NYrkqxAmggMWGom1vo";

Future<String> getAIResponse(String message, String userId) async {
  try {
    final Freelancerdata freelancer = Freelancerdata();
    Map<String, dynamic> userData = await freelancer.getFreelancerData(userId);
    print(userData);
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
    final prompt =
        message +
        userData.toString() +
        " answer it in only precise way and give concise answers";
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    var ans = response.text?.replaceAll("*", "");
    print(response.text);
    return ans!;
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}
