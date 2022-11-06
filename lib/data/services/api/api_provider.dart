import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vlog_app/data/models/blog/blog_model.dart';
import 'package:vlog_app/data/models/user/user_model.dart';
import 'package:dio/dio.dart';
import 'package:vlog_app/data/services/api/api_client.dart';
import 'package:vlog_app/data/services/local/storage_service.dart';

class ApiProvider {
  final ApiClient apiClient;

  ApiProvider({
    required this.apiClient,
  });

  // =========================== Auth ===========================
  Future<void> registerUser({required UserModel user}) async {
    try {
      Response response = await apiClient.dio.post(
        "${apiClient.dio.options.baseUrl}/api/accounts/registr",
        data: {
          'first_name': user.firstName,
          'last_name': user.lastName,
          'user_name': user.userName,
          'email': user.email,
          'password': user.password
        },
      );

      debugPrint('=== DIO REGISTER ===\ndata: ${response.data}');
      debugPrint('${response.statusCode}');
    } on DioError catch (e) {
      debugPrint("*** DIO REGISTER ERROR ***\n ${e.response?.data}");
      if (e.response?.data is Map<String, dynamic>) {
        if ((e.response?.data as Map<String, dynamic>).containsKey('message')) {
          throw e.response?.data['message'];
        }
      }
      throw 'some error try again please';
    }
  }

  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    try {
      Response response = await apiClient.dio.post(
        "${apiClient.dio.options.baseUrl}/api/accounts/login",
        data: {'email': email, 'password': password},
      );

      debugPrint('=== DIO LOGIN ===');
      debugPrint('${response.statusCode}');

      return response.data;
    } on DioError catch (e) {
      debugPrint("*** DIO LOGIN ERROR ***\n ${e.response?.data}");
      if (e.response?.data is Map<String, dynamic>) {
        if ((e.response?.data as Map<String, dynamic>).containsKey('message')) {
          throw e.response?.data['message'];
        }
      }
      rethrow;
    }
  }

  Future<void> verifyEmail({required String email, required int code}) async {
    try {
      Response response = await apiClient.dio.post(
        "${apiClient.dio.options.baseUrl}/api/accounts/verify-email",
        data: {'email': email, 'code': code},
      );

      debugPrint('=== DIO VERIFY ===');
      debugPrint('${response.statusCode}');
      
    } on DioError catch (e) {
      debugPrint("*** DIO VERIFY ERROR ***\n ${e.response?.data}");
      if (e.response?.data is Map<String, dynamic>) {
        if ((e.response?.data as Map<String, dynamic>).containsKey('message')) {
          throw e.response?.data['message'];
        }
      }
      rethrow;
    }
  }

  Future<bool> sendCodeToEmail({required String email}) async {
    Response response = await apiClient.dio.post(
      "${apiClient.dio.options.baseUrl}/api/accounts/send-code-to-email",
      data: {
        'email': email,
      },
    );
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return true;
    } else {
      throw Exception();
    }
  }

  Future<bool> resetPassword(
      {required String email,
      required int code,
      required String password}) async {
    Response response = await apiClient.dio.post(
      "${apiClient.dio.options.baseUrl}/api/accounts/reset-password",
      data: {
        'email': email,
        'code': code,
        'password': password,
      },
    );
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return true;
    } else {
      throw Exception();
    }
  }

  //============================== Users ============================
  Future<List<UserModel>> getAllUsers() async {
    Response response = await apiClient.dio.get(
      "${apiClient.dio.options.baseUrl}/api/users",
      options: Options(
        headers: {
          "Authorization":
              'Bearer ${StorageService.instance.storage.read('token')}'
        },
      ),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List?)
              ?.map((user) => UserModel.fromJson(user))
              .toList() ??
          [];
    } else {
      throw Exception();
    }
  }

  Future<UserModel> getCurrentUser() async {
    Response response = await apiClient.dio.get(
      "${apiClient.dio.options.baseUrl}/api/users/user-info",
      options: Options(
        headers: {
          "Authorization":
              'Bearer ${StorageService.instance.storage.read('token')}'
        },
      ),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception();
    }
  }

  Future<UserModel> getUserById({required int id}) async {
    Response response = await apiClient.dio.get(
      "${apiClient.dio.options.baseUrl}/api/users/$id",
      options: Options(
        headers: {
          "Authorization":
              'Bearer ${StorageService.instance.storage.read('token')}'
        },
      ),
    );

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception();
    }
  }

  Future<bool> updateUserById({required UserModel user}) async {
    Response response = await apiClient.dio
        .put("${apiClient.dio.options.baseUrl}/api/users/${user.id}", data: {
      'first_name': user.firstName,
      'last_name': user.lastName,
      'user_name': user.userName,
      'email': user.email,
      'password': user.password
    });

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return true;
    } else {
      throw Exception();
    }
  }

  Future<void> deleteUser() async {
    Response response = await apiClient.dio.delete(
      "${apiClient.dio.options.baseUrl}/api/users}",
      options: Options(
        headers: {
          "Authorization":
              'Bearer ${StorageService.instance.storage.read('token')}'
        },
      ),
    );
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
    } else {
      throw Exception();
    }
  }

  // ========================== Blog ==========================

  Future<List<BlogModel>> getAllBlogs() async {
    Response response = await apiClient.dio
        .get("${apiClient.dio.options.baseUrl}/api/blogposts");

    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List?)
              ?.map((blog) => BlogModel.fromJson(blog))
              .toList() ??
          [];
    } else {
      throw Exception();
    }
  }

  Future<Map<String, dynamic>> addBlog(
      {required BlogModel blogModel, required XFile? file}) async {
    FormData? formData;
    if (file != null) {
      String fileName = file.path.split('/').last;
      formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: fileName),
        "title": 'QWERTYUISDFGHJXCVBNM',
        'description': 'DFGHJKCVBNMDFGHJGHHHJHJHJHJ',
        'postTypeId': 1
      });
    }
    try {
      Response response = await apiClient.dio.post(
        "${apiClient.dio.options.baseUrl}/api/blogposts",
        data: formData,
        options: Options(
          headers: {
            "Authorization":
                'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjUiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJVc2VyIiwiZXhwIjoxNjY3NzIzOTI2LCJpc3MiOiJIYXZlIGEgbmljZSBkYXksIHRvZGF5IiwiYXVkIjoiQmxvZ0FwcCJ9.lWZhIc0qR5ZHjTSvmiV6IhzzqF_wksDRHj6mGYmaX5E',
            // 'Bearer ${StorageService.instance.storage.read('token')}',
          },
        ),
      );
      print('RESPONSE ON DIO : $response');
      return response.data;
    } on DioError catch (error) {
      print('ERROR ON DIO : ${error.response}');
      print(
          'ERROR RESPONSE STATUSMESSAGE ON DIO : ${error.response?.statusMessage}');
    }

    throw '';
  }

  Future<List<BlogModel>> getBlogsByUserId({required int userId}) async {
    Response response = await apiClient.dio.get(
        "${apiClient.dio.options.baseUrl}/api/blogposts/$userId/blogposts");
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return (response.data as List?)
              ?.map((blog) => BlogModel.fromJson(blog))
              .toList() ??
          [];
    } else {
      throw Exception();
    }
  }

  Future<BlogModel> getBlogById({required int blogId}) async {
    Response response = await apiClient.dio
        .get("${apiClient.dio.options.baseUrl}/api/blogposts/$blogId");
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return BlogModel.fromJson(response.data);
    } else {
      throw Exception();
    }
  }

  Future<bool> deleteBlogById({required int blogId}) async {
    Response response = await apiClient.dio
        .delete("${apiClient.dio.options.baseUrl}/api/blogposts/$blogId");
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return true;
    } else {
      throw Exception();
    }
  }

  Future<bool> updateBlogById(
      {required BlogModel blogModel, required int userId}) async {
    Response response = await apiClient.dio.put(
        "${apiClient.dio.options.baseUrl}/api/blogposts/${blogModel.id}",
        data: {
          "title": blogModel.title,
          "description": blogModel.description,
          "type": blogModel.type,
          "subtitle": blogModel.subtitle,
          "image": blogModel.imageUrl,
          "user_id": userId
        });
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return true;
    } else {
      throw Exception();
    }
  }
}
