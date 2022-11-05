import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_demo_app/Provider/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    print('qwertyuio');
    final GoogleSignIn googleSignIn = GoogleSignIn();
    // googleSignIn.signOut();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn().catchError((onError) => print(onError));

    if (googleSignInAccount != null) {
      print('in if');
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        print('in try');
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;

        if (user != null) {

          // Checking if email and name is null
          assert(user.email != null);
          assert(user.displayName != null);
          assert(user.photoURL != null);

          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);

          final User? currentUser = auth.currentUser;
          assert(user.uid == currentUser!.uid);

          print('signInWithGoogle succeeded: $user');

          return user;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          print('account-exists-with-different-credential');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   Authentication.customSnackBar(
          //     content:
          //     'The account already exists with a different credential.',
          //   ),
          // );
        } else if (e.code == 'invalid-credential') {
          print('invalid-credential');
          // ScaffoldMessenger.of(context).showSnackBar(
          //   Authentication.customSnackBar(
          //     content:
          //     'Error occurred while accessing credentials. Try again.',
          //   ),
          // );
        }
      } catch (e) {
        print('catch error ${e.toString()}');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   Authentication.c ustomSnackBar(
        //     content: 'Error occurred using Google Sign-In. Try again.',
        //   ),
        // );
      }
    } else {
      return null;
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await googleSignIn.signOut();
      prefs.remove('GoogleEmail');

      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => const Dashboard()));
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   Authentication.customSnackBar(
      //     content: 'Error signing out. Try again.',
      //   ),
      // );
    }
  }
}