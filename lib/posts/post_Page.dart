import 'package:exam1/types/post_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:exam1/posts/post_cubit.dart';
import 'package:exam1/posts/post_state.dart';

class PostBloc extends StatefulWidget {
  const PostBloc({super.key});

  @override
  State<PostBloc> createState() => _PostBlocState();
}

class _PostBlocState extends State<PostBloc> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => PostCubit(), child: PostPage());
  }
}

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final dio = Dio();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: 50),
      alignment: Alignment.center,
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          print("reloaded");
          if (state is PostLoading) {
            return Text("Loading.......");
          } else if (state is PostNew) {
            return MyListWidget(
              items: state.data,
            );
          } else {
            return SizedBox();
          }
        },
      ),
    ));
  }
}

class MyListWidget extends StatelessWidget {
  final List<Post> items;

  MyListWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: items
          .map((item) => ListTile(
                title: Text(item.title),
                onTap: () {
                  // Handle item tap here
                  print('Tapped on ${item.title}');
                },
              ))
          .toList(),
    );
  }
}
