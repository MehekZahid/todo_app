// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:todo_app/custom_widgets/list.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onprofiletap;
  final void Function()? onsignout;
  final void Function()? ondelete;
  const MyDrawer(
      {super.key,
      required this.onprofiletap,
      required this.onsignout,
      required this.ondelete});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/girlA.jpg'),
                ),
              ),
              MyListTile(
                  icon: Icons.home_filled,
                  text: 'H 0 M E',
                  ontap: () => Navigator.pop(context)),
              MyListTile(
                  icon: Icons.person_2_outlined,
                  text: 'P R 0 F I L E',
                  ontap: onprofiletap),
              MyListTile(
                  icon: Icons.logout, text: 'L 0 G O U T', ontap: onsignout),
              SizedBox(
                height: 260.h,
              ),
              MyListTile(
                  icon: Icons.logout, text: 'DELETE ACCOUNT', ontap: ondelete),
            ],
          ),
        ],
      ),
    );
  }
}
