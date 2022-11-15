import 'package:formz/formz.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MyUtils {
  static showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: MyColors.ntGradient[0],
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 150,
            right: 25,
            left: 25,
          ),
          padding: const EdgeInsets.all(20),
          content: Row(children: [
            const Icon(
              Icons.error_outline,
              color: MyColors.white,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: MyTextStyle.sfProRegular
                  .copyWith(fontSize: 18, color: MyColors.white),
            ),
          ]),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
  }

  static getMyToast({required String message}) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.black,
        fontSize: 16.0,
      );

  static showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Container(
          height: 100,
          width: 100,
          color: MyColors.white.withOpacity(0.6),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  static void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static Future<bool> onUrlOpen(LinkableElement link) async =>
      await launchUrl(Uri.parse(link.url));

  static Future<bool?> getUrlOpenFailToast() {
    return Fluttertoast.showToast(
      msg: "Can't open Url",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  static InputDecoration getInputDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      labelStyle: MyTextStyle.sfProRegular.copyWith(
        color: MyColors.white,
        fontSize: 16,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(
          width: 1,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.white)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.white)),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.white)),
    );
  }
}
