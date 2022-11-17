import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/data/models/blog/blog_model.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/icon.dart';

import '../../utils/style.dart';

class ReadMoreView extends StatefulWidget {
  const ReadMoreView({super.key, required this.blogModel, required this.userModel});
  final BlogModel blogModel;
  final UserModel userModel;

  @override
  State<ReadMoreView> createState() => _ReadMoreViewState();
}

class _ReadMoreViewState extends State<ReadMoreView> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
          backgroundColor: MyColors.backgroundColor,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: MyColors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: MyColors.richBlack,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  isFavorite = !isFavorite;
                  setState(() {});
                },
                icon: Icon(
                  Icons.favorite,
                  color: isFavorite ? MyColors.red : MyColors.richBlack,
                ))
          ]),
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              SizedBox(
                width: double.infinity,
                child: Text(
                  widget.blogModel.title,
                  style: MyTextStyle.sfProSemibold.copyWith(fontSize: 34.sp),
                ),
              ),
              SizedBox(height: 5.h),
             
              // USER INFO
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                        color: MyColors.backgroundColor,
                        width: 40.h,
                        height: 40.h,
                        child: Image.asset(MyIcons.person)),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Text(
                      widget.userModel.userName,
                      style: MyTextStyle.sfProRegular
                          .copyWith(color: MyColors.grey, fontSize: 22.sp),
                    ),
                  ),
                  Text(
                    DateFormat.yMMMd().format(DateTime.now()),
                    style: MyTextStyle.sfProRegular.copyWith(
                        color: MyColors.grey,
                        fontStyle: FontStyle.italic,
                        fontSize: 22.sp),
                  )
                ],
              ),
              Divider(
                color: MyColors.grey,
                height: 30.h,
                thickness: 1.h,
                indent: 3.w,
                endIndent: 3.w,
              ),
             
              // TEXT
              SizedBox(
                width: double.infinity,
                child: Text(
                  widget.blogModel.description,
                  style: MyTextStyle.sfProLight
                      .copyWith(color: MyColors.richBlack, fontSize: 28.sp),
                ),
              ),
            ],
          )),
    );
  }
}
