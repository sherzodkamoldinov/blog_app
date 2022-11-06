import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:email_validator/email_validator.dart';
import 'package:vlog_app/utils/style.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    TextEditingController? confirm,
    required TextEditingController controller,
    required bool isPassword,
    required String text,
    required FocusNode focusNode,
    required FocusNode nextFocusNode,
    this.isEnd = false,
    required this.type,
  })  : _controller = controller,
        _isPassword = isPassword,
        _text = text, // text, password, email, confirm
        _focusNode = focusNode,
        _nextFocusNode = nextFocusNode,
        _confirm = confirm;

  final TextEditingController _controller;
  final TextEditingController? _confirm;
  final bool _isPassword;
  final String _text;
  final FocusNode _focusNode;
  final FocusNode _nextFocusNode; // dont use becouse its textFormField
  final bool isEnd;
  final String type;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isPressed = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.type == 'email'
          ? TextInputType.emailAddress
          : TextInputType.text,
      cursorColor: MyColors.richBlack,
      validator: (value) {
        switch (widget.type) {
          case 'email':
            if (value != null && !EmailValidator.validate(value)) {
              return "Enter a valid email";
            }
            return null;
          case 'password':
            if (value != null && value.length < 8) {
              return "Length should be large than 7";
            }
            return null;
          case 'confirm':
            if (value != null &&
                widget._controller.text != widget._confirm!.text) {
              return 'Both password must match';
            }
            return null;
          case 'text':
            if (value != null && value.isEmpty) {
              return "Enter Current text";
            }
            return null;
          default:
            return null;
        }
      },
      controller: widget._controller,
      focusNode: widget._focusNode,
      // onSubmitted: (value) {
      //   widget.isEnd
      //       ? widget._focusNode.unfocus()
      //       : MyUtils.fieldFocusChange(
      //           context, widget._focusNode, widget._nextFocusNode);
      // },
      obscureText: widget._isPassword ? isPressed : false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
        hintText: widget._text,
        hintStyle: MyTextStyle.sfProLight.copyWith(color: MyColors.grey),
        suffixIcon: widget._isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isPressed = !isPressed;
                  });
                },
                icon: Icon(
                  isPressed ? Icons.visibility_off : Icons.visibility,
                  color: MyColors.grey,
                ),
              )
            : const SizedBox(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MyColors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MyColors.richBlack),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MyColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MyColors.red),
        ),
      ),
    );
  }
}
