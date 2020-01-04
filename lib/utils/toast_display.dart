import 'package:blogitup/models/comments_model.dart';
import 'package:blogitup/shared_preferences/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';

class ToastMessage {
  void showToast(String message, int duration, BuildContext context) {
    Toast.show(
      message,
      context,
      backgroundRadius: 14,
      gravity: MediaQuery.of(context).viewInsets.bottom > 0
          ? Toast.CENTER
          : Toast.BOTTOM,
      duration: duration,
      backgroundColor: const Color(0xFF0084E9),
      textColor: Colors.white,
    );
  }
}
