import 'dart:async';

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

  Future<void> sendCodeToEmail({required String email}) async {
    try {
      Response response = await apiClient.dio.post(
        "${apiClient.dio.options.baseUrl}/api/accounts/send-code-to-email",
        data: {
          'email': email,
        },
      );

      debugPrint('=== DIO SEND CODE TO EMAIL ===');
      debugPrint('${response.statusCode}');
    } on DioError catch (e) {
      debugPrint("*** DIO SEND CODE TO EMAIL ERROR ***\n ${e.response?.data}");
      if (e.response != null) {
        if (e.response!.statusCode! >= 500) {
          throw ('Server Error');
        }
      }
    }
  }

  Future<void> resetPassword(
      {required String email,
      required int code,
      required String password}) async {
    try {
      Response response = await apiClient.dio.post(
        "${apiClient.dio.options.baseUrl}/api/accounts/reset-password",
        data: {
          'email': email,
          'code': code,
          'password': password,
        },
      );

      debugPrint('=== DIO RESET PASSWORD ===');
      debugPrint('${response.statusCode}');
    } on DioError catch (e) {
      debugPrint("*** DIO RESET PASSWORD ERROR ***\n ${e.response?.data}");
      if (e.response != null) {
        if (e.response!.statusCode! >= 500) {
          throw ('Server Error');
        }
      }
    }
  }

  //============================== Users ============================
  Future<List<UserModel>> getAllUsers() async {
    try {
      Response response =
          await apiClient.dio.get("${apiClient.dio.options.baseUrl}/api/users");

      debugPrint('=== DIO GET ALL USERS ===');
      debugPrint('${response.statusCode}');

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return (response.data as List?)
                ?.map((user) => UserModel.fromJson(user))
                .toList() ??
            [];
      } else {
        debugPrint(
            "*** DIO GET ALL USERS ERROR ***\ncode: ${response.statusCode}\ndata: ${response.data}");
        throw Exception();
      }
    } on DioError catch (e) {
      debugPrint(
          "*** DIO GET ALL USERS ERROR ***\ncode: ${e.response?.statusCode}\ndata: ${e.response?.data}");
      if (e.response != null) {
        if (e.response!.statusCode! >= 500) {
          throw 'Server Error';
        }
      }
      rethrow;
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      Response response = await apiClient.dio.get(
        "${apiClient.dio.options.baseUrl}/api/users/user-info",
        options: Options(
          headers: {
            "Authorization":
                'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjUiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJVc2VyIiwiZXhwIjoxNjY4NTI2NjY4LCJpc3MiOiJIYXZlIGEgbmljZSBkYXksIHRvZGF5IiwiYXVkIjoiQmxvZ0FwcCJ9.TfHUkbAIGswtzwNss5qWLXWCG-HeIwvYAsd8QW0a6Ik'
            // 'Bearer ${StorageService.instance.storage.read('token')}'
          },
        ),
      );

      debugPrint('=== DIO GET CURRENT USER ===');
      debugPrint('${response.statusCode}');
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return UserModel.fromJson(response.data);
      } else {
        debugPrint(
            "*** DIO GET CURRENT USER ERROR ***\ncode: ${response.statusCode}\ndata: ${response.data}");
        throw Exception();
      }
    } on DioError catch (e) {
      debugPrint("*** DIO GET CURRENT USER ERROR ***\n ${e.response?.data}");
      if (e.response != null) {
        if (e.response!.statusCode! >= 500) {
          throw ('Server Error');
        }
      }
      rethrow;
    }
  }

  Future<UserModel> getUserById({required int id}) async {
    try {
      Response response = await apiClient.dio.get(
        "${apiClient.dio.options.baseUrl}/api/users/$id",
        options: Options(
          headers: {
            "Authorization":
                'Bearer ${StorageService.instance.storage.read('token')}'
          },
        ),
      );
      debugPrint('=== DIO GET USER BY ID ===');
      debugPrint('${response.statusCode}');
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        return UserModel.fromJson(response.data);
      } else {
        debugPrint(
            "*** DIO GET USER BY ID ERROR ***\ncode: ${response.statusCode}\ndata: ${response.data}");
        throw Exception();
      }
    } on DioError catch (e) {
      debugPrint("*** DIO GET USER BY ID ERROR ***\n ${e.response?.data}");
      if (e.response?.data is Map<String, dynamic>) {
        if ((e.response?.data as Map<String, dynamic>).containsKey('message')) {
          throw e.response?.data['message'];
        }
      }
      rethrow;
    }
  }

  Future<UserModel> updateCurrentUser(
      {required UserModel user, XFile? file}) async {
    FormData? formData;
    String fileName = "";
    if (file != null) fileName = file.path.split('/').last;
    formData = FormData.fromMap(
      {
        "image": file != null
            ? await MultipartFile.fromFile(file.path, filename: fileName)
            : '',
        "firstName": user.firstName,
        "lastName": user.lastName
        // TODO: qo'shmadim ustida o'ylab ko'rish kerak
        // "userName":'',
        // "email":'',
        // "password": ''
      },
    );

    try {
      Response response = await apiClient.dio.patch(
        "${apiClient.dio.options.baseUrl}/api/users",
        data: formData,
        options: Options(
          headers: {
            "Authorization":
                'Bearer ${StorageService.instance.storage.read('token')}'
          },
        ),
      );

      debugPrint('=== DIO UPDATE CURRENT USER ===');
      debugPrint('${response.statusCode}');

      return UserModel.fromJson(response.data);
    } on DioError catch (e) {
      debugPrint("*** DIO UPDATE CURRENT USER ERROR ***\n ${e.response?.data}");
      if (e.response != null) {
        if (e.response!.statusCode! >= 500) {
          throw ('Server Error');
        }
      }
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      Response response = await apiClient.dio.delete(
        "${apiClient.dio.options.baseUrl}/api/users}",
        options: Options(
          headers: {
            "Authorization":
                // 'Bearer ${StorageService.instance.storage.read('token')}'
                'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjQwIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVXNlciIsImV4cCI6MTY2ODUyOTg3OSwiaXNzIjoiSGF2ZSBhIG5pY2UgZGF5LCB0b2RheSIsImF1ZCI6IkJsb2dBcHAifQ.4aFDaYeR6KeYFdOXCBRKMf3ndm-e-QLMVI-rdyxP_WU'
          },
        ),
      );
      debugPrint('=== DIO DELETE CURRENT USER ===');
      debugPrint('${response.statusCode}');
    } on DioError catch (e) {
      debugPrint(
          "*** DIO DELETE CURRENT USER ERROR***\nmessage: ${e.response?.statusMessage}\ndata: ${e.response?.data}");
      if (e.response != null) {
        if (e.response!.statusCode! >= 500) {
          throw ('Server Error');
        }
      }
      rethrow;
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
