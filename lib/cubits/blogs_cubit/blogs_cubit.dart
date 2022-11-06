import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:vlog_app/data/models/blog/blog_model.dart';
import 'package:vlog_app/data/repositories/blogs_repository.dart';

part 'blogs_state.dart';

class BlogsCubit extends Cubit<BlogsState> {
  BlogsCubit({required this.blogsRepository})
      : super(
          const BlogsState(
            errorText: '',
            formzStatus: FormzStatus.pure,
            blogPosts: [],
          ),
        );
  final BlogsRepository blogsRepository;

  Future<void> addBlog({required BlogModel model, required XFile? file}) async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      await blogsRepository.addBlog(
        file: file,
        blogModel: model,
      );
    } catch (e) {
      emit(state.copyWith(formzStatus: FormzStatus.submissionFailure));
      rethrow;
    }
  }

  Future getAllBlogPosts() async {
    emit(state.copyWith(formzStatus: FormzStatus.submissionInProgress));
    try {
      List<BlogModel> blogs = await blogsRepository.getAllBlogs();
      emit(state.copyWith(
          blogPosts: blogs, formzStatus: FormzStatus.submissionSuccess));
    } catch (e) {
      emit(state.copyWith(
          errorText: e.toString(), formzStatus: FormzStatus.submissionFailure));
      throw e;
    }
  }
}
