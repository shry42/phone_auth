import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phoneauth/model/user_model.dart';
import 'package:phoneauth/providers/auth_provider.dart';
import 'package:phoneauth/screens/home_screens.dart';
import 'package:phoneauth/utils/utils.dart';
import 'package:phoneauth/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  dynamic image;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  //for selecting image

  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => selectImage(),
                      child: image != null
                          ? const CircleAvatar(
                              backgroundColor: Colors.purple,
                              radius: 50,
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 45,
                              ),
                            )
                          : const CircleAvatar(
                              // backgroundImage: FileImage(image),
                              radius: 50,
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 45,
                              ),
                              backgroundColor: Colors.purple,
                            ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          //namefield
                          textField(
                              hintText: "Enter your Name",
                              icon: Icons.account_circle,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: nameController),
                          // email
                          textField(
                              hintText: "Enter your Email",
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              maxLines: 1,
                              controller: emailController),

                          //bio
                          textField(
                              hintText: "Enter you bio here",
                              icon: Icons.edit,
                              inputType: TextInputType.name,
                              maxLines: 2,
                              controller: bioController),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: CustomButton(
                        text: "Continue",
                        onPressed: (() {
                          storeData();
                        }),
                      ),
                    ),
                  ],
                ),
              ),
      )),
    );
  }

  Widget textField({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.purple),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true,
        ),
      ),
    );
  }

//Store userData to database

  void storeData() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        bio: bioController.text.trim(),
        profilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "");

    if (image != null) {
      ap.saveUserDataToFirebase(
          context: context,
          userModel: userModel,
          profilePic: image!,
          onSuccess: () {
            // once data is saved we need to store it locally also
            ap.saveUserDataToSP().then(
                  (value) => ap.setSignIn().then(
                        (value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (route) => false),
                      ),
                );
          });
    } else {
      showSnackBar(context, "Please upload your profile photo");
    }
  }
}
