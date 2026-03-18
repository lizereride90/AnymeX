import 'package:anymex/controllers/community/community_controller.dart';
import 'package:anymex/utils/theme_extensions.dart';
import 'package:anymex/widgets/common/glow.dart';
import 'package:anymex/widgets/custom_widgets/anymex_button.dart';
import 'package:anymex/widgets/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _authorCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();

  @override
  void dispose() {
    _authorCtrl.dispose();
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final controller = Get.find<CommunityController>();
    controller.addPost(
      _authorCtrl.text.trim().isEmpty ? 'Anonymous' : _authorCtrl.text.trim(),
      _titleCtrl.text.trim(),
      _contentCtrl.text.trim(),
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Glow(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const AnymexText(
            text: 'New Post',
            variant: TextVariant.bold,
            size: 20,
          ),
          backgroundColor: colors.surfaceContainerHighest.opaque(0.6),
          surfaceTintColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _authorCtrl,
                  decoration: const InputDecoration(labelText: 'Your name'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentCtrl,
                  maxLines: 6,
                  decoration: const InputDecoration(labelText: 'Share something...'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Content required' : null,
                ),
                const SizedBox(height: 20),
                AnymexButton(
                  onTap: _submit,
                  text: 'Post',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
