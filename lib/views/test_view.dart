import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:vlog_app/data/services/api/api_client.dart';
import 'package:vlog_app/data/services/api/api_provider.dart';
import 'package:vlog_app/data/services/local/storage_service.dart';
import 'package:vlog_app/utils/color.dart';
import 'package:vlog_app/utils/icon.dart';
import 'package:vlog_app/utils/my_utils.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final nameCon = TextEditingController();
  final surnameCon = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String myImage = '';
  String data = '';

  XFile? _image;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    var token = StorageService.instance.storage.read("token");
    if (token == null) {
      await StorageService.instance.storage.write('token',
          'eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVXNlciIsImV4cCI6MTY2ODUyOTg3OSwiaXNzIjoiSGF2ZSBhIG5pY2UgZGF5LCB0b2RheSIsImF1ZCI6IkJsb2dBcHAifQ.4aFDaYeR6KeYFdOXCBRKMf3ndm-e-QLMVI-rdyxP_WU');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: image picker to addblog //
    return Scaffold(
      backgroundColor: MyColors.richBlack,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
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
            TextField(
              controller: nameCon,
              decoration: MyUtils.getInputDecoration(label: 'name'),
            ),
            TextField(
              controller: surnameCon,
              decoration: MyUtils.getInputDecoration(label: 'surname'),
            ),
            const Center(
              child: Text("DATA:"),
            ),
            Text(data),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        try {
              await ApiProvider(apiClient: ApiClient()).deleteUser();
        } catch (e) {
          print('ERROR ON PAGE: $e}');
          MyUtils.showSnackBar(context, e.toString());
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
