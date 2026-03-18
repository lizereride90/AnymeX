import 'package:anymex/database/kv_helper.dart';
import 'package:anymex/models/community_post.dart';
import 'package:anymex/utils/logger.dart';
import 'package:uuid/uuid.dart';

class CommunityRepository {
  static const _storageKey = 'community_posts';
  final _uuid = const Uuid();

  List<CommunityPost> _load() {
    try {
      final raw = KvHelper.get<String>(_storageKey, defaultVal: '[]');
      return CommunityPost.decodeList(raw);
    } catch (e) {
      Logger.e('Failed to load community posts: $e');
      return [];
    }
  }

  void _save(List<CommunityPost> posts) {
    KvHelper.set(_storageKey, CommunityPost.encodeList(posts));
  }

  List<CommunityPost> fetchPosts() {
    final posts = _load();
    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return posts;
  }

  CommunityPost addPost({
    required String author,
    required String title,
    required String content,
  }) {
    final posts = _load();
    final post = CommunityPost(
      id: _uuid.v4(),
      author: author.isEmpty ? 'Anonymous' : author,
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );
    posts.add(post);
    _save(posts);
    return post;
  }

  CommunityPost toggleLike(String id) {
    final posts = _load();
    final idx = posts.indexWhere((p) => p.id == id);
    if (idx == -1) {
      throw Exception('Post not found');
    }
    final current = posts[idx];
    final liked = !current.likedByMe;
    final updated = current.copyWith(
      likedByMe: liked,
      likes: liked ? current.likes + 1 : (current.likes - 1).clamp(0, 1 << 31),
    );
    posts[idx] = updated;
    _save(posts);
    return updated;
  }
}
