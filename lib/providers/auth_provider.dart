import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth/model/user_model.dart';
import 'package:phoneauth/screens/otp_screen.dart';
import 'package:phoneauth/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isSignedIn = false;
  // bool get isSignedIn {
  //  return _isSignedIn;
  // }

  bool get iSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  //userid var
  String? _uid;
  String get uid => _uid!;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  AuthProvider() {
    checkSignIn();
  }

  void checkSignIn() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    _isSignedIn = sf.getBool("is_signedIn") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sf = await SharedPreferences.getInstance();
    sf.setBool("is_signedin", true);
    _isSignedIn = true;
    notifyListeners();
  }

// Sign In
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

// verify otp

  void verifyOtp(
      {required BuildContext context,
      required String verificatonId,
      required String userOtp,
      required Function onSuccess}) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificatonId, smsCode: userOtp);

      User user = (await _firebaseAuth.signInWithCredential(creds)).user!;

      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }

      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  //DATABASE OPERATIONS

  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("users").doc(_uid).get();
    if (snapshot.exists) {
      print("USER EXISTS");
      return true;
    } else {
      print("NEW USER");
      return false;
    }
  }

  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image tot firebase storage
      await storeFileToStorage("profilePic/$uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });

      _userModel = userModel;

      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

//get data from firestore

  Future getDataFromFirestore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot["name"],
        email: snapshot["email"],
        bio: snapshot["bio"],
        profilePic: snapshot["uid"],
        createdAt: snapshot["phoneNumber"],
        phoneNumber: snapshot["createdAt"],
        uid: snapshot["profilePic"],
      );
      _uid = userModel.uid;
    });
  }

// STORING DATA LOCALLY

  Future saveUserDataToSP() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    await sf.setString("userModel", jsonEncode(userModel.toMap()));
  }

// get data from sharedpreference

  Future getDataFromSP() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    String data = sf.getString("user_Model") ?? "";
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    sf.clear();
  }
}
