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
    return _auth.signOut();
  }
}

class IngresoUsuarioEmail {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> loginConEmail({String email, String password}) async {
    FirebaseUser firebaseUser = (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return firebaseUser;
  }

  Future<void> logoutEmail() {
    return _firebaseAuth.signOut();
  }
}
