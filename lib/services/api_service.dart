import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl;

  // Default base URL set to JSONPlaceholder
  ApiService({this.baseUrl = "https://jsonplaceholder.typicode.com"});

  /// GET /posts with pagination
  Future<List<dynamic>> getPosts(int start, int limit) async {
    final response = await http.get(
      Uri.parse("$baseUrl/posts?_start=$start&_limit=$limit"),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load posts");
    }
  }

  /// GET /posts/{id}
  Future<Map<String, dynamic>> getPost(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/posts/$id"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load post");
    }
  }

  /// GET /posts/{id}/comments
  Future<List<dynamic>> getComments(int postId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/posts/$postId/comments"),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load comments");
    }
  }

  /// POST /posts
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/posts"),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
      body: json.encode(data), // <-- encode to JSON string
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to create post");
    }
  }

  /// PUT /posts/{id}
  Future<Map<String, dynamic>> updatePost(
    int id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse("$baseUrl/posts/$id"),
      body: data,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to update post");
    }
  }

  /// DELETE /posts/{id}
  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/posts/$id"));
    if (response.statusCode != 200) {
      throw Exception("Failed to delete post");
    }
  }
}
