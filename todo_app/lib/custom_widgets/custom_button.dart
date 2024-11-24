// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.isloading = false,
      required this.labelText,
      required this.btncolor,
      required this.ontap});

  final isloading;
  final labelText;
  final btncolor;
  final ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 50,
        width: 320,
        decoration: BoxDecoration(
            color: btncolor, borderRadius: BorderRadius.circular(20)),
        child: isloading
            ? Center(
                child: Container(
                    height: 35.h,
                    width: 40.w,
                    child: CircularProgressIndicator(
                      color: Colors.white70,
                    )))
            : Center(
                child: Text(
                  labelText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
      ),
    );
  }
}
