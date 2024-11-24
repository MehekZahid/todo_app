// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/utils/toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String email = '';
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    try {
      final DatabaseReference ref =
          FirebaseDatabase.instance.ref('users/$userId');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        setState(() {
          username =
              snapshot.child('username').value?.toString() ?? "No username";
          email = snapshot.child('email').value?.toString() ?? "No email";
        });
      } else {
        fluttertoas().showpopup(Colors.red, 'User data does not exist.');
      }
    } catch (error) {
      fluttertoas().showpopup(Colors.red, 'Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 118, 17, 10),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: const Color.fromARGB(255, 118, 17, 10),
        title: Text(
          'Profile',
          style: TextStyle(
              fontSize: 28.sp,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80.r,
                backgroundColor: const Color.fromARGB(255, 118, 17, 10),
                child: CircleAvatar(
                  radius: 75.r,
                  backgroundImage: AssetImage('assets/images/girlA.jpg'),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            ProfileField(label: 'Username', value: username),
            SizedBox(height: 20.h),
            ProfileField(label: 'Email', value: email),
            SizedBox(height: 20.h),
            ProfileField(label: 'Password', value: AutofillHints.password),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileField({
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 50.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.85),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
