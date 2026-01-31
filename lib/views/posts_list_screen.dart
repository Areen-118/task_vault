import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/post_controller.dart';
import '../modles/post_model.dart';
import 'post_details_screen.dart';
import 'create_post_screen.dart';
import 'edit_post_screen.dart';

class PostsListScreen extends StatefulWidget {
  @override
  _PostsListScreenState createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  String searchQuery = "";
  bool showEvenOnly = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<PostController>(context, listen: false).fetchPosts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TaskVault – Posts Manager"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreatePostScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<PostController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${controller.errorMessage}"),
                  ElevatedButton(
                    onPressed: () => controller.fetchPosts(),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // Apply search + filter
          List<PostModel> filteredPosts = controller.posts.where((post) {
            final matchesSearch = post.title.toLowerCase().contains(
              searchQuery.toLowerCase(),
            );
            final matchesFilter = !showEvenOnly || post.id % 2 == 0;
            return matchesSearch && matchesFilter;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Search by title",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              SwitchListTile(
                title: const Text("Show even IDs only"),
                value: showEvenOnly,
                onChanged: (val) {
                  setState(() {
                    showEvenOnly = val;
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredPosts.length + 1,
                  itemBuilder: (context, index) {
                    if (index == filteredPosts.length) {
                      return controller.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () =>
                                  controller.fetchPosts(loadMore: true),
                              child: const Text("Load More"),
                            );
                    }

                    final post = filteredPosts[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          post.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          post.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: CircleAvatar(child: Text(post.id.toString())),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PostDetailsScreen(post: post),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditPostScreen(post: post),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                final deletedPost = post;
                                controller.deletePost(post.id);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Post deleted"),
                                    action: SnackBarAction(
                                      label: "Undo",
                                      onPressed: () {
                                        controller.posts.insert(0, deletedPost);
                                        controller.notifyListeners();
                                      },
                                    ),
                                    duration: const Duration(seconds: 5),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
