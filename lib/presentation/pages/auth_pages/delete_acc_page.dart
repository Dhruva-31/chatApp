import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:flutter/material.dart';

class DeleteAccPage extends StatefulWidget {
  const DeleteAccPage({super.key});

  @override
  State<DeleteAccPage> createState() => _DeleteAccPageState();
}

class _DeleteAccPageState extends State<DeleteAccPage> {
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final provider = FirebaseMethods().getLoginProvider();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Account',
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (provider == "password") ...[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: passwordController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(101, 217, 209, 217),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 169, 168, 169),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 169, 168, 169),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: const Color.fromARGB(255, 221, 219, 221),
                      width: 2,
                    ),
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: const Color.fromARGB(255, 221, 219, 221),
                  ),
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: const Color.fromARGB(255, 221, 219, 221),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color.fromARGB(255, 221, 219, 221),
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),
                ),
                obscureText: isObscure,
                cursorColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseMethods().deletePasswordUser(
                  passwordController.text,
                );
                if (mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Delete Account",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],

          if (provider == "google.com") ...[
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseMethods().deleteGoogleUser();
                  if (mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Delete Account (Google)",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],

          if (provider == "github.com") ...[
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseMethods().deleteGithubUser();
                  if (mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  "Delete Account (GitHub)",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
