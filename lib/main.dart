import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/post_controller.dart';
import 'views/posts_list_screen.dart';

void main() {
  runApp(const TaskVaultApp());
}

class TaskVaultApp extends StatelessWidget {
  const TaskVaultApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostController>(
      create: (_) => PostController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TaskVault – Posts Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PostsListScreen(),
      ),
    );
  }
}
