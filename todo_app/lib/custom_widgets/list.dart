// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyListTile extends StatelessWidget {
  MyListTile(
      {super.key, required this.icon, required this.text, required this.ontap});
  final IconData icon;
  final String text;
  void Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
          size: 25.h,
        ),
        onTap: ontap,
        title: Text(
          text,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16.h),
        ),
      ),
    );
  }
}
