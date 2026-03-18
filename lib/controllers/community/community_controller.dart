import 'package:anymex/models/community_post.dart';
import 'package:anymex/repositories/community_repository.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController {
  final CommunityRepository repository;
  CommunityController({required this.repository});

  final posts = <CommunityPost>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPosts();
  }

  void loadPosts() {
    isLoading.value = true;
    posts.assignAll(repository.fetchPosts());
    isLoading.value = false;
  }

  void addPost(String author, String title, String content) {
    repository.addPost(author: author, title: title, content: content);
    loadPosts();
  }

  void toggleLike(String id) {
    repository.toggleLike(id);
    loadPosts();
  }
}
