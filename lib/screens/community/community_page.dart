import 'package:anymex/controllers/community/community_controller.dart';
import 'package:anymex/models/community_post.dart';
import 'package:anymex/repositories/community_repository.dart';
import 'package:anymex/utils/theme_extensions.dart';
import 'package:anymex/widgets/common/glow.dart';
import 'package:anymex/widgets/custom_widgets/anymex_button.dart';
import 'package:anymex/widgets/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_post_page.dart';

class CommunityPage extends StatelessWidget {
  CommunityPage({super.key});

  final CommunityController controller = Get.put(
    CommunityController(repository: CommunityRepository()),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Glow(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const AnymexText(
            text: 'Community',
            variant: TextVariant.bold,
            size: 20,
          ),
          backgroundColor: colors.surfaceContainerHighest.opaque(0.6),
          surfaceTintColor: Colors.transparent,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Get.to(() => const CreatePostPage());
            controller.loadPosts();
          },
          icon: const Icon(Icons.edit_rounded),
          label: const Text('New Post'),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = controller.posts;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.forum_outlined, size: 48),
                  const SizedBox(height: 8),
                  const AnymexText(text: 'No posts yet'),
                  const SizedBox(height: 12),
                  AnymexButton(
                    onTap: () => Get.to(() => const CreatePostPage()),
                    text: 'Be the first to post',
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _PostCard(post: items[index], controller: controller),
          );
        }),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;
  final CommunityController controller;

  const _PostCard({required this.post, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: colors.surfaceContainerHighest.opaque(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text(post.author.isNotEmpty
                      ? post.author[0].toUpperCase()
                      : '?'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnymexText(
                        text: post.author,
                        variant: TextVariant.bold,
                        size: 14,
                      ),
                      Text(
                        timeLabel(post.createdAt),
                        style: TextStyle(
                          color: colors.onSurface.opaque(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (post.title.isNotEmpty)
              AnymexText(
                text: post.title,
                variant: TextVariant.semiBold,
                size: 16,
              ),
            if (post.title.isNotEmpty) const SizedBox(height: 6),
            Text(
              post.content,
              style: TextStyle(color: colors.onSurface),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: () => controller.toggleLike(post.id),
                  icon: Icon(
                    post.likedByMe
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: post.likedByMe ? colors.primary : colors.onSurface,
                  ),
                ),
                Text('${post.likes}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String timeLabel(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
