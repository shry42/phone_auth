import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:phoneauth/providers/auth_provider.dart';
import 'package:phoneauth/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
// to show the entry of numbers in a right way i.e from left to right

    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length),
    );
//

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.purple.shade50,
                    ),
                    child: Image.asset("assets/authentication.png"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    textAlign: TextAlign.center,
                    "Add your phone number. We'll send you a \n  verification code",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    cursorColor: Colors.purple,
                    controller: phoneController,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    onChanged: (value) {
                      setState(() {
                        phoneController.text = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.grey[400],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),

                      // using focusbOrder the outline will not change at the input time

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),

                      // adding prefix icon before text field input

                      prefixIcon: Container(
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                  bottomSheetHeight: 550,
                                ),
                                onSelect: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                });
                          },
                          child: Text(
                            "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // adding prefix icon before text field input

                      suffixIcon: phoneController.text.length > 9
                          ? Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.all(10.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                              child: const Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  child: const CircularProgressIndicator()),
                            ),
                    ),
                    keyboardType: TextInputType.number,
                  ),

                  ////
                  const SizedBox(height: 20),

                  const SizedBox(height: 20),
                  SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CustomButton(
                          text: "Login",
                          onPressed: () {
                            sendPhoneNumber();
                          })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    // here variable ap is auth provider
    //+911234567890
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
