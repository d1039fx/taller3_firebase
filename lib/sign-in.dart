import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class IngresoUsuario {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //login
  Future<FirebaseUser> ingresoUsuariofuncion() async {
    final GoogleSignInAccount _googleSignAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleSignAuth =
        await _googleSignAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleSignAuth.idToken,
        accessToken: _googleSignAuth.accessToken);

    final FirebaseUser _usuario =
        (await _auth.signInWithCredential(credential)).user;

    return _usuario;
  }

  //logout
  Future<void> logout() {
    return _googleSignIn.signOut();
  }
}
