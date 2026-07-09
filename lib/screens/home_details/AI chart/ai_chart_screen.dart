import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIChatTab extends StatefulWidget {
  const AIChatTab({super.key});

  @override
  State<AIChatTab> createState() => _AIChatTabState();
}

class _AIChatTabState extends State<AIChatTab> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _selectedLanguage = 'English';
  final String _userName = 'Shammah';

  final List<String> _languages = [
    'English',
    'Swahili',
    'Luganda',
    'French',
    'Spanish'
  ];
  final List<String> _quickQuestions = [
    'Treat cattle diseases',
    'Best feeding practices',
    'Breeding tips',
    'Market prices today',
    'Vaccination schedule',
  ];

  @override
  void initState() {
    super.initState();
    // No welcome message added - chat starts empty
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // No header section
          Expanded(
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      physics: const BouncingScrollPhysics(),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
            ),
          ),
          _buildQuickQuestions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFFF57C00),
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome to Jaguza AI',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1F36),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me about Livestock, Aquaculture or Crops',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _quickQuestions.map((question) {
              return GestureDetector(
                onTap: () {
                  _messageController.text = question;
                  _sendMessage();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF57C00).withOpacity(0.3)),
                  ),
                  child: Text(
                    question,
                    style: TextStyle(
                      color: const Color(0xFFF57C00),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF57C00),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ask Jaguza AI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36),
                ),
              ),
              Text(
                'Powered by AI',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Language selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded,
                  color: Color(0xFFF57C00), size: 16),
              const SizedBox(width: 4),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                      color: Color(0xFF1A1F36),
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                  icon: const Icon(Icons.arrow_drop_down_rounded,
                      color: Colors.grey, size: 18),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedLanguage = newValue);
                    }
                  },
                  items: _languages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Clear chat button
        TextButton.icon(
          onPressed: _messages.isEmpty ? null : _clearChat,
          icon: Icon(Icons.delete_outline_rounded,
              color: _messages.isEmpty ? Colors.grey[400] : Colors.red.shade600, 
              size: 16),
          label: Text(
            'Clear',
            style: TextStyle(
              color: _messages.isEmpty ? Colors.grey[400] : Colors.red.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildQuickQuestions() {
    if (_messages.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SizedBox(
        height: 32,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _quickQuestions.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _messageController.text = _quickQuestions[index];
                _sendMessage();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  _quickQuestions[index],
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.attach_file_rounded,
                  color: Colors.grey[600], size: 20),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _messageController,
                style:
                    const TextStyle(color: Color(0xFF1A1F36), fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Type your question...',
                  hintStyle:
                      TextStyle(fontSize: 13, color: Colors.grey[500]),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.mic_rounded,
                        color: Colors.grey[500], size: 20),
                    onPressed: () {},
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF57C00),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 22),
              onPressed: _isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFF57C00),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFFF57C00) : Colors.grey[100],
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft:
                      isUser ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight:
                      isUser ? const Radius.circular(4) : const Radius.circular(18),
                ),
                border: isUser ? null : Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: isUser ? Colors.white : const Color(0xFF1A1F36),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 9,
                      color: isUser ? Colors.white70 : Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 10),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                shape: BoxShape.circle,
                border: Border.all(
                    color: const Color(0xFFF57C00).withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  _userName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFF57C00),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: _getAIResponse(text),
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    });
  }

  String _getAIResponse(String message) {
    final lowerMsg = message.toLowerCase();

    if (lowerMsg.contains('vaccine') || lowerMsg.contains('vaccination')) {
      return 'Vaccination Schedule:\n\n• FMD — Every 6 months\n• LSD — Annually\n• De-worming — Every 3 months\n• Anthrax — Annually\n\nConsult your vet for local guidelines.';
    }
    if (lowerMsg.contains('feed') ||
        lowerMsg.contains('feeding') ||
        lowerMsg.contains('nutrition')) {
      return 'Feeding Tips:\n\n• Provide quality hay/silage daily\n• Supplement with concentrates\n• Offer mineral blocks\n• Clean water available 24/7';
    }
    if (lowerMsg.contains('breed') || lowerMsg.contains('breeding')) {
      return 'Breeding Tips:\n\n• Select animals with superior traits\n• Monitor for heat detection\n• Keep detailed breeding records\n• Consider AI services';
    }
    if (lowerMsg.contains('health') ||
        lowerMsg.contains('disease') ||
        lowerMsg.contains('treat')) {
      return 'Health Tips:\n\n• Observe animals daily\n• Isolate sick ones immediately\n• Keep housing clean\n• Maintain treatment logs\n\nConsult a vet for unusual symptoms.';
    }
    if (lowerMsg.contains('market') ||
        lowerMsg.contains('price') ||
        lowerMsg.contains('sell')) {
      return 'Market Tips:\n\n• Check prices regularly\n• Sell in bulk for better rates\n• Join cooperatives for bargaining power\n• Build buyer relationships';
    }

    return 'I can help with:\n\n• Livestock health & feeding\n• Breeding practices\n• Vaccination schedules\n• Market prices\n• Crop management\n\nWhat would you like to know more about?';
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text(
          'Clear Chat',
          style: TextStyle(color: Color(0xFF1A1F36), fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to delete all messages? This cannot be undone.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
                // No welcome message added - chat stays empty
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}