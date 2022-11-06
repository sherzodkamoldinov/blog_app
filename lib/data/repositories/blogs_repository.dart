import 'package:vlog_app/data/models/blog/blog_model.dart';
import 'package:vlog_app/data/services/api/api_provider.dart';
import 'package:image_picker/image_picker.dart';

class BlogsRepository {
  BlogsRepository({required ApiProvider apiProvider})
      : _apiProvider = apiProvider;

  final ApiProvider _apiProvider;

  Future<List<BlogModel>> getAllBlogs() => _apiProvider.getAllBlogs();

  Future<Map<String, dynamic>> addBlog(
          {required BlogModel blogModel, required XFile? file}) =>
      _apiProvider.addBlog(blogModel: blogModel, file: file);

  Future<List<BlogModel>> getBlogsByUserId({required int userId}) =>
      _apiProvider.getBlogsByUserId(userId: userId);

  Future<BlogModel> getBlogById({required int blogId}) =>
      _apiProvider.getBlogById(blogId: blogId);

  Future<bool> deleteBlogById({required int blogId}) =>
      deleteBlogById(blogId: blogId);

  Future<bool> updateBlogById(
          {required BlogModel blogModel, required int userId}) =>
      _apiProvider.updateBlogById(blogModel: blogModel, userId: userId);
}
