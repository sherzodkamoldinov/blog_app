part of 'blogs_cubit.dart';

@immutable
class BlogsState extends Equatable {
  final List<BlogModel> blogPosts;
  final FormzStatus formzStatus;
  final String errorText;

  const BlogsState({
    required this.blogPosts,
    required this.formzStatus,
    required this.errorText,
  });

  BlogsState copyWith({
    List<BlogModel>? blogPosts,
    FormzStatus? formzStatus,
    String? errorText,
  }) =>
      BlogsState(
        blogPosts: blogPosts ?? this.blogPosts,
        formzStatus: formzStatus ?? this.formzStatus,
        errorText: errorText ?? this.errorText,
      );

  @override
  List<Object?> get props => [
        blogPosts,
        formzStatus,
        errorText,
      ];
}
