import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlog_app/cubits/blogs_cubit/blogs_cubit.dart';
import 'package:vlog_app/data/models/blog/blog_model.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/my_utils.dart';
import 'package:vlog_app/utils/style.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/views/bottom_bar/my_blogs_view/desc_input_field.dart';
import 'package:vlog_app/views/widgest/custom_appbar.dart';
import 'package:vlog_app/views/widgest/custom_botton.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  TextEditingController titleC = TextEditingController();
  TextEditingController descC = TextEditingController();
  bool isSelected = false;
  XFile? file;
  final ImagePicker _imagePicker = ImagePicker();

  FocusNode titleF = FocusNode();
  FocusNode descF = FocusNode();

  @override
  void dispose() {
    super.dispose();
    titleC.dispose();
    descC.dispose();
    titleF.dispose();
    descF.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: const CustomAppBar(title: 'Add Blog'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocConsumer<BlogsCubit, BlogsState>(
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorText)));
          },
          builder: (context, state) {
            return Column(children: [
              // TITLE
              CommentInputComponent(
                height: 70,
                hintText: "Write title...",
                maxLength: 120,
                onSubmitted: (v) {
                  MyUtils.fieldFocusChange(context, titleF, descF);
                },
                onChanged: (text) {},
                commentFocusNode: titleF,
                textEditingController: titleC,
                textButton: IconButton(
                  onPressed: () {
                    titleC.clear();
                  },
                  icon: const Icon(Icons.clear, color: Color(0xFF356899)),
                ),
              ),
              const SizedBox(height: 10),
              // DESC
              CommentInputComponent(
                height: 120,
                hintText: "Write description...",
                maxLength: 400,
                onSubmitted: (v) {
                  descF.unfocus();
                },
                onChanged: (text) {},
                commentFocusNode: descF,
                textEditingController: descC,
                textButton: IconButton(
                  onPressed: () {
                    descC.clear();
                  },
                  icon: const Icon(Icons.clear, color: Color(0xFF356899)),
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                tileColor: Colors.white.withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Center(
                    child: Text(
                  file != null ? 'Selected' : 'Select Brand image',
                  style: MyTextStyle.sfProRegular.copyWith(fontSize: 16),
                )),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Visibility(
                      visible: file != null,
                      child: InkWell(
                          child: const Icon(Icons.clear),
                          onTap: () async {
                            file = null;
                          })),
                ),
                onTap: () async {
                  XFile? newImage = await _imagePicker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 500,
                      maxHeight: 500);
                  if (newImage != null) {
                    file = newImage;
                  }
                },
              ),
              customBotton(
                onPressed: () async {
                  await context.read<BlogsCubit>().addBlog(
                      file: file,
                      model: BlogModel(
                          id: -1,
                          title: titleC.text,
                          description: descC.text,
                          type: 'type',
                          subtitle: '',
                          imageUrl: '',
                          createdAt: DateTime.now().toString(),
                          userId: -1));
                },
                title: state.formzStatus.isSubmissionInProgress &&
                        !state.formzStatus.isSubmissionFailure
                    ? null
                    : 'Add Blog',
                fillColor: true,
              ),
            ]);
          },
        ),
      ),
    );
  }
}
