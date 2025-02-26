import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservice {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> googleSignIn() async {
    try {
      final GoogleSignInAccount? guser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gauth = await guser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gauth.accessToken,
        idToken: gauth.idToken,
      );

      UserCredential userCredential = await auth.signInWithCredential(
        credential,
      );

      String? token = await userCredential.user?.getIdToken(true);
      print(token);
      return token!;
    } catch (e) {
      print("No token Genearted");
      return e.toString();
    }
  }

  Future<String> googleSignOut() async {
    try {
      await GoogleSignIn().signOut();
      await auth.signOut();

      return 'Success';
    } catch (e) {
      return e.toString();
    }
  }
}
