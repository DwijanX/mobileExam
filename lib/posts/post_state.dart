import 'package:exam1/types/post_type.dart';

class PostState {
  PostState();

  get data => null;
}

class PostLoading extends PostState {
  PostLoading();
}

class PostNew extends PostState {
  List<Post> data;
  PostNew({required this.data});
  @override
  List<Object> get props => [data];
}
