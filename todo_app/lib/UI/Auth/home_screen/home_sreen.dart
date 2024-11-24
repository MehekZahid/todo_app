// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/UI/Auth/home_screen/profile_screen.dart';

import 'package:todo_app/UI/Auth/login_screen/login_screen.dart';
import 'package:todo_app/custom_widgets/drawer.dart';
import 'package:todo_app/utils/toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Database = FirebaseDatabase.instance.ref('todo');
  TextEditingController searchController = TextEditingController();
  final database = FirebaseDatabase.instance
      .ref('todo')
      .orderByChild('uid')
      .equalTo(FirebaseAuth.instance.currentUser!.uid);

  void showTaskDialog({String? id, String? title, String? description}) {
    TextEditingController titleController =
        TextEditingController(text: title ?? '');
    TextEditingController descriptionController =
        TextEditingController(text: description ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            id == null ? 'Add Task' : 'Update Task',
            style: TextStyle(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(fontSize: 16),
                  fillColor: const Color.fromARGB(179, 208, 202, 202),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                controller: descriptionController,
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(fontSize: 16),
                  fillColor: const Color.fromARGB(179, 208, 202, 202),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                String taskTitle = titleController.text.trim();
                String taskDescription = descriptionController.text.trim();
                String currentDate =
                    DateFormat('dd-MM-yyyy').format(DateTime.now());

                if (taskTitle.isNotEmpty && taskDescription.isNotEmpty) {
                  if (id == null) {
                    // Add new task
                    String newTaskId = Database.push().key!;
                    Database.child(newTaskId).set({
                      'id': newTaskId,
                      'title': taskTitle,
                      'description': taskDescription,
                      'date': currentDate,
                      'uid': FirebaseAuth.instance.currentUser!.uid,
                    }).then((_) {
                      fluttertoas()
                          .showpopup(Colors.green, 'Task added successfully');
                    });
                  } else {
                    // Update existing task
                    Database.child(id).update({
                      'title': taskTitle,
                      'description': taskDescription,
                    }).then((_) {
                      fluttertoas()
                          .showpopup(Colors.green, 'Task updated successfully');
                    });
                  }
                  Navigator.pop(context);
                } else {
                  fluttertoas()
                      .showpopup(Colors.red, 'Both fields are required');
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  void gotoProfil() {
    Navigator.pop(context);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  void signOut() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Logout Confirmation',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((v) {
                  fluttertoas().showpopup(Colors.green, 'Logout successfully');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                });
              },
              child: Text(
                'Logout',
                style: TextStyle(
                    color: const Color.fromARGB(255, 177, 27, 16),
                    fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  void onDelete() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.currentUser!.delete().then((v) {
                  fluttertoas()
                      .showpopup(Colors.green, 'Account Deleted successfully');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }).catchError((error) {
                  fluttertoas()
                      .showpopup(Colors.red, 'Failed to delete account');
                });
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 17, 10),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 118, 17, 10),
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Your Tasks',
          style: TextStyle(
              color: Colors.white, fontSize: 32, fontFamily: 'Ubuntu'),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        onprofiletap: gotoProfil,
        onsignout: signOut,
        ondelete: onDelete,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showTaskDialog();
        },
        child: Icon(
          Icons.add,
          color: const Color.fromARGB(255, 127, 17, 9),
          size: 40,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: TextField(
                controller: searchController,
                onChanged: (v) {
                  setState(() {});
                },
                style: TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search task',
                  hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                  fillColor: Colors.white.withOpacity(.89),
                  filled: true,
                  suffixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: FirebaseAnimatedList(
                  query: database,
                  itemBuilder: (context, snapshot, animation, index) {
                    if (snapshot
                        .child('title')
                        .value
                        .toString()
                        .contains(searchController.text.toString())) {
                      return GestureDetector(
                        onTap: () {
                          showTaskDialog(
                            id: snapshot.child('id').value.toString(),
                            title: snapshot.child('title').value.toString(),
                            description:
                                snapshot.child('description').value.toString(),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Card(
                            color: Colors.white.withOpacity(.82),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 200.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Text(
                                          '${snapshot.child('title').value}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 10, top: 10),
                                        child: Text(
                                          '${snapshot.child('description').value}',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Database.child(snapshot.key!)
                                            .remove()
                                            .then((v) {
                                          fluttertoas().showpopup(Colors.green,
                                              'Task deleted successfully');
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: const Color.fromARGB(
                                            255, 164, 36, 27),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 16, right: 5),
                                      child: Text(
                                        '${snapshot.child('date').value}',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (searchController.text.isEmpty) {
                      return Container();
                    }
                    return Container();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
