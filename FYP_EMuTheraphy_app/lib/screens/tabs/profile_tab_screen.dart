import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/model/user.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  /// ✅ Ensure the user is logged in before accessing FirebaseAuth
  final User? userLoggedIn = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondBGColor,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontSize: 22, color: mainFontColor, fontWeight: FontWeight.bold)),
        backgroundColor: mainBGColor,
      ),
      body: userLoggedIn == null
          ? const Center(child: Text("No user is logged in.", style: TextStyle(color: Colors.red)))
          : FutureBuilder<UserData?>(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("User not found in Firestore.", style: TextStyle(color: Colors.red)));
          }

          final user = snapshot.data!;
          return buildUser(user);
        },
      ),
    );
  }

  /// ✅ Fetch user data from Firestore securely
  Future<UserData?> getUser() async {
    if (userLoggedIn == null) {
      debugPrint("No user logged in.");
      return null;
    }

    try {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(userLoggedIn!.uid);
      debugPrint("Fetching user data for UID: ${userLoggedIn!.uid}");

      final snapshot = await userDoc.get();
      if (snapshot.exists) {
        return UserData.fromJson(snapshot.data()!);
      } else {
        debugPrint("User document does not exist in Firestore.");
        return null;
      }
    } catch (e) {
      debugPrint("Firestore error: $e");
      return null;
    }
  }

  /// ✅ Build the user profile UI
  Widget buildUser(UserData user) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              // CircleAvatar(
              //   radius: 50,
              //   backgroundImage: user.profileImage.isNotEmpty
              //       ? NetworkImage(user.profileImage) as ImageProvider
              //       : const AssetImage("assets/images/default_user.png"),
              // ),
              const SizedBox(height: 10),
              Text(user.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: mainFontColor)),
              const SizedBox(height: 5),
              Text(user.id, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: mainFontColor)),
              const SizedBox(height: 12),

              /// User Details
              _buildInfoRow("Gender", user.gender),
              _buildInfoRow("Age", user.age),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => logoutUser(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBGColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: mainFontColor),
                    SizedBox(width: 10),
                    Text("Log Out", style: TextStyle(fontSize: 18, color: mainFontColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ Helper method to build user info rows
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: mainFontColor)),
        ],
      ),
    );
  }

  /// ✅ Log out user and navigate to login screen
  void logoutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    debugPrint("User logged out.");
    Navigator.of(context).pushReplacementNamed('/login'); // Adjust based on your route
  }
}
