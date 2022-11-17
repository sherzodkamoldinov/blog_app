import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vlog_app/cubits/blogs_cubit/blogs_cubit.dart';
import 'package:vlog_app/cubits/type_cubit/type_cubit.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:vlog_app/views/widgest/blog_item.dart';
import 'package:vlog_app/views/widgest/custom_appbar_with_drawer.dart';
import 'package:vlog_app/views/widgest/custom_drawer.dart';
import 'package:formz/formz.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int activeType = 0;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  _init() async {
    await BlocProvider.of<BlogsCubit>(context).getAllBlogPosts();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: const CustomAppBarWithDrawer(),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // TEXT FIELD AND FILTER BUTTON
            SizedBox(
              height: 70.h,
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      cursorColor: MyColors.grey,
                      onSubmitted: (value) {},
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Image.asset(MyIcons.search)),
                          fillColor: MyColors.white,
                          filled: true,
                          hintText: "Search",
                          hintStyle: MyTextStyle.sfProLight
                              .copyWith(fontSize: 22.sp, color: MyColors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: MyColors.white,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Image.asset(MyIcons.filter),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 35.h),

            // CATEGORIES
            BlocBuilder<TypeCubit, TypeState>(
              builder: (context, typeState) {
                return SizedBox(
                  height: 55.h,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(left: 5.w),
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (!typeState.status.isSubmissionSuccess)
                        ...List.generate(
                          5,
                          (index) => Padding(
                            padding: EdgeInsets.only(bottom: 15.h),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              enabled: true,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: Colors.white,
                                ),
                                width: 70.w,
                                margin: EdgeInsets.only(right: 20.w),
                              ),
                            ),
                          ),
                        )
                      else if (typeState.status.isSubmissionSuccess)
                        ...List.generate(
                          typeState.types.length + 1,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                activeType = index;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      index == 0
                                          ? tr('all')
                                          : typeState.types[index - 1].name,
                                      style: MyTextStyle.sfProLight.copyWith(
                                          fontSize: activeType == index
                                              ? 20.sp
                                              : 18.sp,
                                          fontWeight: activeType == index
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: activeType == index
                                              ? MyColors.richBlack
                                              : MyColors.grey
                                                  .withOpacity(0.8))),
                                  activeType == index
                                      ? SizedBox(
                                          width: 30.w,
                                          child: Divider(
                                            height: 22.h,
                                            thickness: 3.h,
                                            endIndent: 0,
                                            indent: 0,
                                            color: MyColors.richBlack,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),

            // BLOG ITEMS
            BlocBuilder<UsersCubit, UsersState>(
              builder: (context, userState) {
                return BlocBuilder<BlogsCubit, BlogsState>(
                  builder: (context, blogState) {
                    return Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: blogState.blogPosts.length,
                        itemBuilder: (BuildContext context, int index) {
                          var user = userState.users
                              .where((element) =>
                                  element.id ==
                                  blogState.blogPosts[index].userId)
                              .toList()[0];
                          var blog = blogState.blogPosts[index];
                          return InkWell(
                            onTap: () async {
                              Navigator.pushNamed(context, readMoreView,
                                  arguments: [
                                    blog,
                                    user,
                                  ]);
                            },
                            child: blogItem(
                              blog: blog,
                              user: user,
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  readMoreView,
                                  arguments: [
                                    blog,
                                    user,
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
