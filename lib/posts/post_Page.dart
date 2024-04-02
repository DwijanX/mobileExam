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

class MyListWidget extends StatefulWidget {
  final List<Post> items;

  MyListWidget({required this.items});

  @override
  _MyListWidgetState createState() => _MyListWidgetState();
}

class _MyListWidgetState extends State<MyListWidget> {
  List<int> ratings = List.filled(100, 0);
  int listLen = 100;

  void orderList() {
    setState(() {
      // Sort the items list based on ratings
      widget.items.sort(
          (a, b) => ratings[b.id % listLen].compareTo(ratings[a.id % listLen]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: orderList,
          child: Text('Order List'),
        ),
        Expanded(
          child: ListView(
            children: widget.items.map((item) {
              int index = widget.items.indexOf(item);
              return ListTile(
                title: Text(item.title),
                subtitle: Row(
                  children: [
                    RatingWidget(
                      itemId: item.id,
                      rating: ratings[item.id % listLen],
                      onRatingChanged: (int rating) {
                        setState(() {
                          ratings[item.id % listLen] = rating;
                        });
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Handle item tap here
                  print('Tapped on ${item.title}');
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class RatingWidget extends StatefulWidget {
  final int itemId;
  final int rating;
  final ValueChanged<int> onRatingChanged;

  RatingWidget({
    required this.itemId,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int rating = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Rating: ${widget.rating}'),
        for (int i = 1; i <= 5; i++)
          InkWell(
            onTap: () {
              widget.onRatingChanged(i);
            },
            child: Icon(
              i <= widget.rating ? Icons.star : Icons.star_border,
              color: Colors.yellow,
            ),
          ),
      ],
    );
  }
}
