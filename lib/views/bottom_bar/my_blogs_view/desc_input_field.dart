import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vlog_app/utils/style.dart';

class CommentInputComponent extends StatelessWidget {
  const CommentInputComponent({
    Key? key,
    required this.onChanged,
    required this.commentFocusNode,
    required this.hintText,
    this.textEditingController,
    this.textButton,
    this.height,
    this.maxLength,
    this.onSubmitted,
  }) : super(key: key);

  final ValueChanged<String> onChanged;
  final FocusNode commentFocusNode;
  final TextEditingController? textEditingController;
  final Widget? textButton;
  final String hintText;
  final double? height;
  final int? maxLength;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(children: [
        TextField(
          onSubmitted: onSubmitted,
          textAlignVertical: TextAlignVertical.top,
          controller: textEditingController,
          expands: true,
          dragStartBehavior: DragStartBehavior.down,
          minLines: null,
          maxLines: null,
          textInputAction: TextInputAction.done,
          focusNode: commentFocusNode,
          keyboardType: TextInputType.text,
          style: MyTextStyle.sfProMedium.copyWith(fontSize: 16),
          onChanged: onChanged,
          maxLength: maxLength,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2C557D), width: 2)),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
              color: Color(0xFF95969D),
            )),
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 15,
                color: Theme.of(context).textTheme.headline1!.color),
          ),
          cursorColor: const Color(0xFF2C557D),
        ),
        Positioned(
            bottom: 15, right: -5, child: textButton ?? const SizedBox()),
      ]),
    );
  }
}
