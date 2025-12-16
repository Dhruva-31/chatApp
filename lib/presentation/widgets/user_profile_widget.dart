// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth_1/data/model/user_model.dart';
import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/data/services/firestore_methods.dart';
import 'package:firebase_auth_1/presentation/widgets/edit_name_widget.dart';
import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final UserModel user;
  const UserProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final date = user.createdAt;
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    return Card(
      child: SizedBox(
        height: 380,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: user.profilePic,
                placeholder: (context, url) => CircleAvatar(
                  radius: 70,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.grey.shade700,
                  ),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    border: BoxBorder.all(color: Colors.white),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: imageProvider,
                  ),
                ),
              ),
              SizedBox(height: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'name : ${user.name}',
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      user.uid == FirebaseMethods().currentUser!.uid
                          ? GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => EditNameWidget(
                                    controller: nameController,
                                    onSave: () {
                                      FirestoreMethods().updateUserName(
                                        nameController.text.trim(),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  Divider(thickness: 0.1),
                  SizedBox(height: 20),
                  Text(
                    'email : ${user.email}',
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(thickness: 0.1),
                  SizedBox(height: 20),
                  Text(
                    'created at : $day/$month/$year',
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Divider(thickness: 0.1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
