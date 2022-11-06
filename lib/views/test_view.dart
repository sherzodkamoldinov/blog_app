import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:formz/formz.dart';
import 'package:vlog_app/data/models/blog/blog_model.dart';
import 'package:vlog_app/data/services/api/api_client.dart';
import 'package:vlog_app/data/services/api/api_provider.dart';
import 'package:vlog_app/main.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/my_utils.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String myImage = '';

  XFile? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _getFromGallery();
            },
            child: const Text('select image'),
          ),
          SizedBox(
            child: myImage.isNotEmpty
                ? Image.network(myImage)
                : Image.asset(MyIcons.imageSample),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        print(_image?.name);
        try {
          Map<String, dynamic> a =
              await ApiProvider(apiClient: ApiClient()).addBlog(
            blogModel: BlogModel(
              id: 1,
              title: 'title',
              description: 'description',
              type: '1',
              subtitle: 'subtitle',
              imageUrl: 'imageUrl',
              createdAt: 'createdAt',
              userId: 1,
            ),
            file: _image,
          );
          setState(() {
            myImage = 'https://blogappuz.herokuapp.com/' + a['image'];
          });
          _image = null;
        } catch (e) {
          print('ERROR ON PAGE: $e}');
        }
      }),
    );
  }

  _getFromGallery() async {
    XFile? pickedFile = await _picker.pickImage(
      maxWidth: 500,
      maxHeight: 500,
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }
}
