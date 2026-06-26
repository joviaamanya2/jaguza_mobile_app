import 'package:flutter/material.dart';

// ═══════════════════════════════════════
//  SHARED DATA MODELS (public)
// ═══════════════════════════════════════

class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String? count;

  const MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.count,
  });
}

class OverlayItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const OverlayItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class FeatureItem {
  final IconData icon;
  final String title;
  final Color color;
  final Color bgLight;
  final Widget screen;

  const FeatureItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.bgLight,
    required this.screen,
  });
}

class CategoryItem {
  final IconData icon;
  final String label;

  const CategoryItem({required this.icon, required this.label});
}

class FeedPost {
  final String author;
  final String location;
  final String dateTime;
  final String timeAgo;
  final String title;
  final String excerpt;
  final String category;
  final int likes;
  final int comments;
  final bool isVerified;
  final Color authorColor;
  final Color categoryColor;
  final Color imageGradientStart;
  final Color imageGradientEnd;
  final IconData categoryIcon;

  String get authorInitials => author
      .split(' ')
      .map((w) => w.isNotEmpty ? w[0] : '')
      .take(2)
      .join()
      .toUpperCase();

  const FeedPost({
    required this.author,
    required this.location,
    required this.dateTime,
    required this.timeAgo,
    required this.title,
    required this.excerpt,
    required this.category,
    required this.likes,
    required this.comments,
    this.isVerified = false,
    required this.authorColor,
    required this.categoryColor,
    required this.categoryIcon,
    required this.imageGradientStart,
    required this.imageGradientEnd,
  });
}

class ChatMessage {
  final String text;
  final String time;
  final bool isUser;

  const ChatMessage({
    required this.text,
    required this.time,
    required this.isUser,
  });
}