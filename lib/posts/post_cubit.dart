import 'package:dio/dio.dart';
import 'package:exam1/posts/post_state.dart';
import 'package:exam1/types/post_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostLoading()) {
    fetchMovies();
  }
  Dio dio = Dio();
  fetchMovies() async {
    final response =
        await dio.get('https://jsonplaceholder.typicode.com/posts');
    print(response.data);
    List<Post> data = welcomeFromJson(response.data);
    emit(PostNew(data: data));
  }

  void addData(String json) {
    List<Post> data = welcomeFromJson(json);
    print(data);
    emit(PostNew(data: data));
  }
}
