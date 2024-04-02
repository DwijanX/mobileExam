import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:exam1/posts/post_state.dart';
import 'package:exam1/types/post_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostLoading()) {
    fetchPosts();
  }

  Dio dio = Dio();

  fetchPosts() async {
    try {
      final response =
          await dio.get('https://jsonplaceholder.typicode.com/posts');
      if (response.statusCode == 200) {
        List<Post> posts = welcomeFromJson(json.encode(response.data));
        emit(PostNew(data: posts));
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }
}
