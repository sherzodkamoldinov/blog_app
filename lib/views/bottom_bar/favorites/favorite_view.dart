import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/data/models/blog/blog_model.dart';
import 'package:vlog_app/data/models/helper/action_model.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/views/widgest/blog_item.dart';
import 'package:vlog_app/views/widgest/custom_drawer.dart';

import '../../widgest/custom_appbar_with_drawer.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: CustomAppBarWithDrawer(
        title: "My Favorite List",
        actions: [
          ActionModel(
            icon: Icons.delete,
            onPressed: () {},
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SizedBox(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          physics: const BouncingScrollPhysics(),
          itemCount: 12,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, readMoreView, arguments: [
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum., Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                  "Please Start Writing Better Git",
                  MyIcons.person,
                  "Sherzod Kamoldinov"
                ]);
              },
              child: blogItem(
                 blog: BlogModel(id: 0, title: 'title', description: 'description', type: '', subtitle: 'subtitle', imageUrl: 'imageUrl', createdAt: 'createdAt', userId: 1),
                 user: UserModel(id: 1, firstName: 'firstName', lastName: 'lastName', userName: 'userName', email: 'email', imageUrl: 'imageUrl', password: ''),
                  onPressed: () {
                    Navigator.pushNamed(context, readMoreView, arguments: [
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                      "Please Start Writing Better Git",
                      MyIcons.person,
                      "Sherzod Kamoldinov"
                    ]);
                  }),
            );
          },
        ),
      ),
    );
  }
}
