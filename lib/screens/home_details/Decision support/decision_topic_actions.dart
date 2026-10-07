import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Share a decision-support topic or save/remove it from local bookmarks.
class DecisionTopicActions extends StatefulWidget {
  final String category;
  final String title;
  final String description;
  final List<String> details;

  const DecisionTopicActions({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.details,
  });

  @override
  State<DecisionTopicActions> createState() => _DecisionTopicActionsState();
}

class _DecisionTopicActionsState extends State<DecisionTopicActions> {
  static const _savedKey = 'saved_decision_support_topics';
  bool _isSaved = false;

  String get _topicKey => '${widget.category}:${widget.title}';

  @override
  void initState() {
    super.initState();
    _loadSavedState();
  }

  Future<void> _loadSavedState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_savedKey) ?? const <String>[];
    if (mounted) setState(() => _isSaved = saved.any(_hasTopicKey));
  }

  bool _hasTopicKey(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map && decoded['key'] == _topicKey;
    } catch (_) {
      return raw == _topicKey;
    }
  }

  Future<void> _toggleSave() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_savedKey) ?? <String>[];
    saved.removeWhere(_hasTopicKey);
    final nowSaved = !_isSaved;
    if (nowSaved) {
      saved.add(jsonEncode({
        'key': _topicKey,
        'category': widget.category,
        'title': widget.title,
        'description': widget.description,
        'details': widget.details,
      }));
    }
    await prefs.setStringList(_savedKey, saved);
    if (!mounted) return;
    setState(() => _isSaved = nowSaved);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(nowSaved ? 'Saved to your decision support bookmarks' : 'Removed from saved topics'),
    ));
  }

  Future<void> _share() async {
    final text = StringBuffer()
      ..writeln('${widget.category} Decision Support: ${widget.title}')
      ..writeln()
      ..writeln(widget.description);
    if (widget.details.isNotEmpty) {
      text
        ..writeln()
        ..writeln('Details:');
      for (final detail in widget.details) {
        text.writeln('• $detail');
      }
    }
    await Share.share(text.toString(), subject: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(children: [
      Expanded(
        child: ElevatedButton.icon(
          onPressed: _share,
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.share, size: 20),
          label: const Text('Share', style: TextStyle(fontSize: 14)),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: OutlinedButton.icon(
          onPressed: _toggleSave,
          style: OutlinedButton.styleFrom(
            foregroundColor: scheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: scheme.primary),
          ),
          icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border, size: 20),
          label: Text(_isSaved ? 'Saved' : 'Save', style: const TextStyle(fontSize: 14)),
        ),
      ),
    ]);
  }
}
