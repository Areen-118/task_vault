import 'package:flutter/material.dart';
import '../modles/post_model.dart';
import '../services/api_service.dart';

class PostController extends ChangeNotifier {
  final ApiService apiService = ApiService();
  List<PostModel> posts = [];
  bool isLoading = false;
  String errorMessage = "";

  int start = 0;
  final int limit = 20;

  Future<void> fetchPosts({bool loadMore = false}) async {
    try {
      isLoading = true;
      notifyListeners();

      if (!loadMore) {
        posts.clear();
        start = 0;
      }

      final data = await apiService.getPosts(start, limit);
      posts.addAll(data.map((json) => PostModel.fromJson(json)).toList());
      start += limit;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(PostModel post) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await apiService.createPost(post.toJson());
      posts.insert(0, PostModel.fromJson(data));
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePost(PostModel post) async {
    final data = await apiService.updatePost(post.id, post.toJson());
    final index = posts.indexWhere((p) => p.id == post.id);
    posts[index] = PostModel.fromJson(data);
    notifyListeners();
  }

  Future<void> deletePost(int id) async {
    await apiService.deletePost(id);
    posts.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
