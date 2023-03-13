import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:phoneauth/providers/auth_provider.dart';
import 'package:phoneauth/screens/home_screens.dart';
import 'package:phoneauth/screens/registration_screen.dart';
import 'package:phoneauth/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    //here var ap is authProvider
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/loginscreen.png",
                  height: 400,
                  width: 400,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Lets' get started",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Never a better time than now to start.",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38),
                ),

                //Button inside sizedbox

                const SizedBox(height: 20),
                SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: CustomButton(
                        text: "Get Started",
                        onPressed: () async {
                          if (ap.iSignedIn == true) {
                            await ap.getDataFromSP().whenComplete(
                                  () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const HomeScreen()),
                              
                                    ),
                                  ),
                                );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => const RegisterScreen()),
                              ),
                            );
                          }
                        })),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
