import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:phoneauth/providers/auth_provider.dart';
import 'package:phoneauth/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("FlutterPhone Auth"),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>const WelcomeScreen()),
                    ),
                  );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              backgroundImage: NetworkImage(ap.userModel.profilePic),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(ap.userModel.name),
            Text(ap.userModel.phoneNumber),
            Text(ap.userModel.email),
            Text(ap.userModel.bio),
          ],
        ),
      ),
    );
  }
}
