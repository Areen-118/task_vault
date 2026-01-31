import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/post_controller.dart';
import '../modles/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<PostController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (value) => value != null && value.length >= 5
                    ? null
                    : "Title must be at least 5 characters",
              ),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: "Body"),
                validator: (value) => value != null && value.length >= 20
                    ? null
                    : "Body must be at least 20 characters",
              ),
              TextFormField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: "User ID (1–10)"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final id = int.tryParse(value ?? "");
                  if (id == null || id < 1 || id > 10) {
                    return "User ID must be between 1 and 10";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => isLoading = true);
                          final newPost = PostModel(
                            id: 0,
                            userId: int.parse(_userIdController.text),
                            title: _titleController.text,
                            body: _bodyController.text,
                          );
                          await controller.createPost(newPost);
                          setState(() => isLoading = false);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Create"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
