import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vlog_app/data/models/blog/blog_model.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/style.dart';

Widget blogItem({
  required BlogModel blog,
  required UserModel user,
  required VoidCallback onPressed,
}) =>
    Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BLOG IMAGE
            SizedBox(
              width: double.infinity,
              height: 200.h,
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: CachedNetworkImage(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl:
                        'https://blogappuz.herokuapp.com/${blog.imageUrl}',
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      MyIcons.imageSample,fit: BoxFit.cover,
                    ),
                  )),
            ),
            SizedBox(height: 10.h),
            // TITLE
            SizedBox(
              width: double.infinity,
              child: Text(
                blog.title,
                style: MyTextStyle.sfProSemibold.copyWith(fontSize: 24.sp),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                // softWrap: false,
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
                      width: 30.h,
                      height: 30.h,
                      child: Image.asset(MyIcons.person)),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    user.userName,
                    style: MyTextStyle.sfProRegular.copyWith(
                        color: MyColors.grey, overflow: TextOverflow.ellipsis),
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: MyTextStyle.sfProRegular.copyWith(
                      color: MyColors.grey,
                      overflow: TextOverflow.ellipsis,
                      fontStyle: FontStyle.italic),
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
                blog.description,
                maxLines: 5,
                style: MyTextStyle.sfProLight.copyWith(
                    color: MyColors.grey, overflow: TextOverflow.fade),
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            // BUTTON
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r)),
                        backgroundColor: MyColors.richBlack),
                    onPressed: onPressed,
                    child: Text(
                      "More",
                      style: MyTextStyle.sfProLight
                          .copyWith(color: MyColors.white),
                    )))
          ],
        ),
      ),
    );
