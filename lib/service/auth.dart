import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthHandler {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> signIn() async {
    // _auth.onAuthStateChanged.listen((s) => print('Authstate $s'));

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    if (googleAuth == null) return null;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // print("signed in " + user.displayName);
    return user;
  }

  Future<FirebaseUser> get currentUser async => _auth.currentUser();
}
