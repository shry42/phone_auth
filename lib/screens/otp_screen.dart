import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:phoneauth/providers/auth_provider.dart';
import 'package:phoneauth/screens/home_screens.dart';
import 'package:phoneauth/screens/registration_screen.dart';
import 'package:phoneauth/screens/user_information_screen.dart';
import 'package:phoneauth/utils/utils.dart';
import 'package:phoneauth/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
                  child: Column(children: [
                    //Adding back button

                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Colors.purple.shade50,
                      ),
                      child: Image.asset(
                        "assets/otp.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Verification",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      textAlign: TextAlign.center,
                      "Enter the OTP sent to your phone Number",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
//OTP Input Box
                    Pinput(
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.purple.shade200,
                          ),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onCompleted: ((value) {
                        setState(() {
                          otpCode = value;
                        });
                      }),
                    ),

                    const SizedBox(height: 25),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: CustomButton(
                          text: "Verify",
                          onPressed: () {
                            if (otpCode != null) {
                              verifyOtp(context, otpCode);
                            } else {
                              showSnackBar(context, "Enter 6 didgit code");
                            }
                          }),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Didn't receive any code?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black38),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Resend New Code",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple),
                    )
                  ]),
                ),
              ),
      ),
    );
  }

//verify otp

  void verifyOtp(BuildContext context, String? userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificatonId: widget.verificationId,
        userOtp: userOtp.toString(),
        onSuccess: () {
          //check whether the user exists in db

          ap.checkExistingUser().then((value) async {
            if (value == true) {
              //user exists in our app
              ap.getDataFromFirestore().then(
                    (value) => ap.saveUserDataToSP().then(
                          (value) => ap.setSignIn().then(
                                (value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  ((route) => false),
                                ),
                              ),
                        ),
                  );
            } else {
              // new user
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInformationScreen()),
                  (route) => false);
            }
          });
        });
  }
}
