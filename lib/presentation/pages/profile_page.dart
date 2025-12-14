import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/delete_acc_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userDetails = FirestoreMethods().getUserDetail(
      FirebaseMethods().currentUser!.uid,
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 80),
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Profile',
              style: TextStyle(fontSize: 26, color: Colors.white),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: userDetails,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final user = snapshot.data;
          final date = user!.createdAt;
          String day = date.day.toString();
          String month = date.month.toString();
          String year = date.year.toString();
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  child: SizedBox(
                    height: 400,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: const Color.fromARGB(
                              79,
                              163,
                              204,
                              226,
                            ),
                            backgroundImage: user.profilePic.isNotEmpty
                                ? NetworkImage(user.profilePic)
                                : null,
                            child: (user.profilePic.isEmpty)
                                ? Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.grey.shade700,
                                  )
                                : null,
                          ),
                          SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: BoxBorder.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'name : ${user.name}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'email : ${user.email}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'created at : $day/$month/$year',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                LogOutButtonClickedEvent(),
                              );
                            },
                            child: Text(
                              'Log Out',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DeleteAccPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Delete Account',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
