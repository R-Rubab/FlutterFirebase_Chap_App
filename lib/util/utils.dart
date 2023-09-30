import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  toastmsg(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.purple,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));
  }
}
