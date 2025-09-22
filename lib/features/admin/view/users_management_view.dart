import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flux_app/features/login/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UsersManagementView extends StatelessWidget {
  const UsersManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users Management"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No users found."));
            }

            final users = snapshot.data!.docs;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final uid = user.id;
                final name = user['name'] ?? "No name";
                final email = user['email'] ?? "No email";
                final role = user['role'] ?? "user";

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: ListTile(
                    title: Text(name),
                    subtitle: Text(email),
                    trailing: ElevatedButton(
                      onPressed: () {
                        final newRole = role == "admin" ? "user" : "admin";
                        Get.put(LoginController()).updateUserRole(uid, newRole);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: role == "admin"
                            ? Colors.red
                            : Colors.green,
                      ),
                      child: Text(
                        role == "admin" ? "Remove \n Admin" : "Make\nAdmin",
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
