import 'package:google_generative_ai/google_generative_ai.dart';

const apiKey = "AIzaSyA8BMrypImr7UFL7NYrkqxAmggMWGom1vo";
Future<String> getAIResponse(String message) async {
  try {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final prompt = message;
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    var ans = response.text;
    print(response.text);
    return ans!;
  } catch (e) {
    print(e.toString());
    return e.toString();
  }
}
