import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/my_utils.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/views/widgest/custom_botton.dart';

class UserInfoItem extends StatelessWidget {
  UserInfoItem({
    super.key,
    required this.text,
    required this.canEdit,
    required this.title,
  });

  final String title;
  final String text;
  final bool canEdit;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: MyTextStyle.sfProLight.copyWith(fontSize: 13.sp)),
        Divider(thickness: 2.h),
        context.read<UsersCubit>().state.formzStatus.isSubmissionInProgress
            ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.white,
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.only(left: 10.w, right: 5),
                height: 70.h,
                decoration: BoxDecoration(
                    color: MyColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.grey.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(1, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        style: MyTextStyle.sfProLight.copyWith(fontSize: 22.sp),
                      ),
                    ),
                    if (canEdit)
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          controller.text = text;
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r)),
                                title: const SizedBox(),
                                backgroundColor: MyColors.backgroundColor,
                                content: TextField(
                                  controller: controller,
                                  decoration:
                                      MyUtils.getInputDecoration(label: title),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: customBotton(
                                          onPressed: () {
                                            Navigator.pop(_);
                                          },
                                          title: 'Cancel',
                                          fillColor: false,
                                        ),
                                      ),
                                      SizedBox(width: 7.w),
                                      Expanded(
                                        child: customBotton(
                                          onPressed: () async {
                                            UserModel user = context
                                                .read<UsersCubit>()
                                                .state
                                                .user;
                                            Navigator.pop(_);
                                            await context
                                                .read<UsersCubit>()
                                                .updateCurrentUser(
                                                    updateUser: title == 'NAME'
                                                        ? user.copyWith(
                                                            firstName:
                                                                controller.text)
                                                        : user.copyWith(
                                                            lastName: controller
                                                                .text));
                                          },
                                          title: 'Save',
                                          fillColor: true,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.edit,
                          color: MyColors.richBlack,
                          size: 24.sp,
                        ),
                      ),
                  ],
                ),
              ),
      ],
    );
  }
}
