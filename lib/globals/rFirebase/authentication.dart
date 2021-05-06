import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:redbacks/globals/constants.dart';
import 'package:redbacks/globals/router.dart';
import 'package:redbacks/models/login_response_message.dart';
import 'package:redbacks/providers/logged_in_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class Authentication {
  Future<UserCredential> signInWithGoogle(
      {BuildContext context, bool signUp = false}) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignInAccount googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        LoginResponseMessage result = await shouldLoginEmail(
            googleSignInAccount.email, "google.com", context, signUp);
        if (result.errCode == SUCCESS) {
          return await getGoogleCredentials(googleSignInAccount, auth);
          // If sign in method clicked and no user exists, bypass first sign up screen
        } else if (result.errCode == NO_USER_EXISTS) {
          LoggedInUser userProvider =
          Provider.of<LoggedInUser>(context, listen: false);
          userProvider.signingUp = true;
          UserCredential user =  await getGoogleCredentials(googleSignInAccount, auth);
          userProvider.setNameFromCredential(user);
          Navigator.pushReplacementNamed(context, Routes.NameSignup);
          return null;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: result.msg,
            ),
          );
          return null;
        }
      }
    } on FirebaseAuthException catch (e) {
      _errorHandling(e, context);
    } catch (e) {
      print("catch ${e}");
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred using Google Sign-In. Try again.',
        ),
      );
    }
    return null;
  }

  Future<UserCredential> getGoogleCredentials(GoogleSignInAccount googleSignInAccount, FirebaseAuth auth) async {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    return await auth.signInWithCredential(credential);
  }

  static void _errorHandling(FirebaseAuthException e, BuildContext context) {
    if (e.code == 'account-exists-with-different-credential') {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'The account already exists with a different credential.',
        ),
      );
    } else if (e.code == 'invalid-credential') {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred while accessing credentials. Try again.',
        ),
      );
    }
  }

  Future<UserCredential> signInWithFacebook(
      {BuildContext context, bool signUp = false}) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential credential =
            FacebookAuthProvider.credential(loginResult.accessToken.token);

        final userData = await FacebookAuth.instance.getUserData();
        LoginResponseMessage result = await shouldLoginEmail(
            userData["email"], "facebook.com", context, signUp);
        if (result.errCode == SUCCESS) {
          return await FirebaseAuth.instance.signInWithCredential(credential);
          // If sign in method clicked and no user exists, bypass first sign up screen
        } else if (result.errCode == NO_USER_EXISTS) {
          LoggedInUser userProvider =
          Provider.of<LoggedInUser>(context, listen: false);
          userProvider.signingUp = true;
          UserCredential user =  await FirebaseAuth.instance.signInWithCredential(credential);
          userProvider.setNameFromCredential(user);
          Navigator.pushReplacementNamed(context, Routes.NameSignup);
          return null;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: result.msg,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      _errorHandling(e, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred using Facebook Sign-In. Try again. ${e}',
        ),
      );
    }
    return null;
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();

    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple(
      {BuildContext context, bool signUp = false}) async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.joelsmithinc.redbacks.appleSignIn',
          redirectUri: Uri.parse(
            'https://magic-lyrical-gondola.glitch.me/callbacks/sign_in_with_apple',
          ),
        ),
      );
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      LoginResponseMessage result = await shouldLoginEmail(
          "insert apple email here", "apple.com", context, signUp);
      if (result.errCode == SUCCESS) {
        return await FirebaseAuth.instance
            .signInWithCredential(oauthCredential);
        // If sign in method clicked and no user exists, bypass first sign up screen
      } else if (result.errCode == NO_USER_EXISTS) {
        LoggedInUser userProvider =
        Provider.of<LoggedInUser>(context, listen: false);
        userProvider.signingUp = true;
        UserCredential user = await FirebaseAuth.instance.signInWithCredential(
            oauthCredential);
        userProvider.setNameFromCredential(user);
        Navigator.pushReplacementNamed(context, Routes.NameSignup);
        return null;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: result.msg,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Need pop to remove popup for apple
      _errorHandling(e, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error occurred using Apple Sign-In. Try again. ${e}',
        ),
      );
    }
  }

  Future<UserCredential> loginUsingEmail(String email, String pwd) async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pwd);
    return user;
  }

  Future<void> logoutFn(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.Root, (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  Future<void> logoutFnFromHome(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.Login, (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static SnackBar customSnackBar({String content = ""}) {
    return SnackBar(
      content: Text(
        content,
        style: TextStyle(letterSpacing: 0.5),
      ),
    );
  }

  Future<UserCredential> signUpUsingEmailAndPassword(String email, String pwd) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: pwd);
  }

  Future<LoginResponseMessage> shouldLoginEmail(
      String email, String company, BuildContext context, bool signUp) async {
    try {
      List<String> signInMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      print(signInMethods);
      if (signUp && signInMethods.length > 0)
        return LoginResponseMessage(
            errCode: EMAIL_ALREADY_REGISTERED,
            msg: "Email already registered with ${signInMethods[0]}");
      else if (!signUp && signInMethods.length == 0)
        return LoginResponseMessage(
            errCode: NO_USER_EXISTS,
            msg: "No user set up with email: ${email}. Click Sign Up");
      else if (!signUp && !signInMethods.contains(company))
        return LoginResponseMessage(
            errCode: USER_LINKED_OTHER_COMPANY,
            msg:
                "User ${email} is not linked to ${company} but is linked to ${signInMethods.join(', ')}");
      else if (!signUp && signInMethods.contains(company))
        return LoginResponseMessage(
            errCode: SUCCESS,
            msg: "User ${email} does have an account linked to ${company}");
    } catch (e) {
      return LoginResponseMessage(errCode: ERROR, msg: "${e}");
    }
  }

  void logoutAllNonAdmin() {}

  Future<void> sendForgotPwdEmail(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
