import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/cubits/blogs_cubit/blogs_cubit.dart';
import 'package:vlog_app/data/models/blog/blog_model.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/my_utils.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/views/widgest/blog_item.dart';
import 'package:vlog_app/views/widgest/custom_appbar_with_drawer.dart';
import 'package:vlog_app/views/widgest/custom_drawer.dart';

class MyBlogsView extends StatefulWidget {
  const MyBlogsView({super.key});

  @override
  State<MyBlogsView> createState() => _MyBlogsViewState();
}

class _MyBlogsViewState extends State<MyBlogsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: CustomAppBarWithDrawer(
        title: "My Blogs",
        actionIcon: Icons.add,
        onPressed: () {
          Navigator.pushNamed(context, addBlogView);
        },
      ),
      drawer: const CustomDrawer(),
      body: SizedBox(
        child: BlocBuilder<BlogsCubit, BlogsState>(
          builder: (context, state) {
            var currentUser = BlocProvider.of<AuthCubit>(context).state.user;
            List<BlogModel> myBlogs = state.blogPosts
                .where((element) => element.userId == currentUser.id)
                .toList();
            return myBlogs.isEmpty
                ? const Center(
                    child: Text('Empty please add'),
                  ) : state.formzStatus.isSubmissionInProgress ? MyUtils.showLoader(context)
                : state.formzStatus.isSubmissionInProgress
                    ? MyUtils.showLoader(context)
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        physics: const BouncingScrollPhysics(),
                        itemCount: myBlogs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, readMoreView,
                                  arguments: [
                                    myBlogs[index].description,
                                    myBlogs[index].title,
                                    MyIcons.person,
                                    "${currentUser.firstName} ${currentUser.lastName}"
                                  ]);
                            },
                            child: blogItem(
                                title: myBlogs[index].title,
                                imageUrl: MyIcons.person,
                                userName:
                                    "${currentUser.firstName} ${currentUser.lastName}",
                                text: myBlogs[index].description,
                                onPressed: () {
                                  Navigator.pushNamed(context, readMoreView,
                                      arguments: [
                                        myBlogs[index].description,
                                        myBlogs[index].title,
                                        MyIcons.person,
                                        "${currentUser.firstName} ${currentUser.lastName}",
                                      ]);
                                }),
                          );
                        },
                      );
          },
        ),
      ),
    );
  }
}
