import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:jaguza_app/services/api_service.dart';

class AIChatTab extends StatefulWidget {
  const AIChatTab({super.key});

  @override
  State<AIChatTab> createState() => _AIChatTabState();
}

class _AIChatTabState extends State<AIChatTab> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<FileAttachment> _attachments = [];
  bool _isLoading = false;
  bool _isRecording = false;
  String _selectedLanguage = 'English';
  final String _userName = 'Shammah';
  
  late stt.SpeechToText _speech;
  String _lastWords = '';

  final List<String> _languages = [
    'English',
    'Swahili',
    'Luganda',
    'French',
    'Spanish',
    'Arabic',
    'German',
    'Portuguese',
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
    _speech = stt.SpeechToText();
    _messageController.addListener(_onMessageChanged);
    _initSpeech();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    try {
      final history = await ApiService().getChatHistory();
      final messages = history.whereType<Map>().map((raw) {
        final message = Map<String, dynamic>.from(raw);
        final timestamp = DateTime.tryParse(
              '${message['created_at'] ?? message['timestamp'] ?? ''}',
            ) ??
            DateTime.now();
        final sender = '${message['sender'] ?? ''}'.toLowerCase();
        return ChatMessage(
          text: '${message['message'] ?? message['text'] ?? ''}',
          isUser: message['isUser'] == true || sender == 'user',
          timestamp: timestamp,
        );
      }).where((message) => message.text.trim().isNotEmpty).toList();

      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(messages);
      });
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    }
  }

  Future<void> _initSpeech() async {
    try {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        await _speech.initialize(
          onStatus: (status) {
            if (status == 'notListening' && _isRecording) {
              setState(() {
                _isRecording = false;
                if (_lastWords.isNotEmpty) {
                  _messageController.text = _lastWords;
                }
              });
            }
          },
          onError: (error) {
            setState(() {
              _isRecording = false;
            });
            _showSnackBar('Speech recognition error: ${error.errorMsg}');
          },
        );
      } else {
        _showSnackBar('Microphone permission is required for voice input');
      }
    } catch (e) {
      _showSnackBar('Failed to initialize speech recognition');
    }
  }

  Future<void> _startListening() async {
    try {
      var status = await Permission.microphone.request();
      if (!status.isGranted) {
        _showSnackBar('Microphone permission is required');
        return;
      }

      if (!_speech.isAvailable) {
        _showSnackBar('Speech recognition is not available');
        return;
      }

      setState(() {
        _isRecording = true;
      });

      await _speech.listen(
        onResult: (result) {
          setState(() {
            _lastWords = result.recognizedWords;
            _messageController.text = _lastWords;
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
        localeId: _getSpeechLocale(),
        onSoundLevelChange: (level) {
          // You can use this to show voice level animation
        },
        listenOptions: stt.SpeechListenOptions(partialResults: true),
      );
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showSnackBar('Error starting voice recognition');
    }
  }

  void _stopListening() {
    if (_isRecording) {
      _speech.stop();
      setState(() {
        _isRecording = false;
      });
    }
  }

  String _getSpeechLocale() {
    switch (_selectedLanguage) {
      case 'English':
        return 'en_US';
      case 'Swahili':
        return 'sw';
      case 'French':
        return 'fr_FR';
      case 'Spanish':
        return 'es_ES';
      case 'German':
        return 'de_DE';
      case 'Portuguese':
        return 'pt_PT';
      case 'Arabic':
        return 'ar';
      default:
        return 'en_US';
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          _attachments.add(FileAttachment(
            name: file.name,
            size: file.size,
            bytes: file.bytes,
            extension: file.extension ?? '',
          ));
        });
        _showSnackBar('File "${file.name}" attached successfully');
      }
    } catch (e) {
      _showSnackBar('Error picking file');
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    _chatScrollController.dispose();
    _speech.stop();
    super.dispose();
  }

  void _onMessageChanged() {
    // Rebuild the send button as soon as the user starts or clears a message.
    if (mounted) setState(() {});
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_chatScrollController.hasClients) return;
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Attachments bar
          if (_attachments.isNotEmpty) _buildAttachmentsBar(),
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _chatScrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length) {
                        return _buildTypingIndicator();
                      }
                      return _buildMessageBubble(_messages[index]);
                    },
                  ),
          ),
          if (_messages.isNotEmpty) _buildQuickQuestions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildAttachmentsBar() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _attachments.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final attachment = _attachments[index];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getFileIcon(attachment.extension),
                  color: const Color(0xFFF57C00),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    attachment.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _removeAttachment(index),
                  child: Icon(
                    Icons.close_rounded,
                    color: scheme.onSurfaceVariant,
                    size: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image_rounded;
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'doc':
      case 'docx':
        return Icons.description_rounded;
      case 'txt':
        return Icons.text_snippet_rounded;
      default:
        return Icons.attach_file_rounded;
    }
  }

  Widget _buildEmptyState() {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 48),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF3E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Color(0xFFF57C00),
              size: 60,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to Jaguza AI',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your intelligent farming assistant',
            style: TextStyle(
              fontSize: 16,
              color: scheme.onSurfaceVariant,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Livestock • Aquaculture • Crops',
              style: TextStyle(
                fontSize: 12,
                color: const Color(0xFFF57C00),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: scheme.outlineVariant,
                  thickness: 1,
                  indent: 40,
                  endIndent: 16,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: scheme.onSurfaceVariant,
                size: 20,
              ),
              Expanded(
                child: Divider(
                  color: scheme.outlineVariant,
                  thickness: 1,
                  indent: 16,
                  endIndent: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Ask a question below to get started',
            style: TextStyle(
              fontSize: 13,
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
          ],
        ),
      ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      elevation: 0,
      title: Row(
        mainAxisSize: MainAxisSize.min,
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
          Flexible(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ask Jaguza AI',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: scheme.onPrimary,
                ),
              ),
              Text(
                'Powered by AI',
                style: TextStyle(
                  fontSize: 10,
                  color: scheme.onPrimary.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          tooltip: 'Change language',
          icon: Icon(Icons.language_rounded, color: scheme.onPrimary),
          onSelected: (language) => setState(() => _selectedLanguage = language),
          itemBuilder: (context) => _languages.map((language) => PopupMenuItem(
            value: language,
            child: Text(language),
          )).toList(),
        ),
        IconButton(
          tooltip: 'Clear chat',
          onPressed: _messages.isEmpty ? null : _clearChat,
          icon: Icon(Icons.delete_outline_rounded,
              color: _messages.isEmpty ? scheme.onPrimary.withValues(alpha: 0.4) : scheme.error,
              size: 16),
        ),
      ],
    );
  }

  Widget _buildQuickQuestions() {
    if (_messages.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: Border(
          top: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: SizedBox(
        height: 36,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFF57C00).withValues(alpha: 0.15),
                  ),
                ),
                child: Text(
                  _quickQuestions[index],
                  style: const TextStyle(
                    color: Color(0xFFF57C00),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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
    final scheme = Theme.of(context).colorScheme;
    final canSend = _messageController.text.trim().isNotEmpty ||
        _attachments.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Attachment button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _attachments.isNotEmpty ? const Color(0xFFFFF3E0) : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: _attachments.isNotEmpty
                      ? Border.all(color: const Color(0xFFF57C00).withValues(alpha: 0.3))
                      : null,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: _attachments.isNotEmpty ? const Color(0xFFF57C00) : scheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onPressed: _pickFile,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.newline,
                    style: TextStyle(color: scheme.onSurface, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: _isRecording ? 'Listening...' : 'Type your question...',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: scheme.onSurfaceVariant,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                          color: _isRecording ? scheme.error : scheme.onSurfaceVariant,
                          size: 20,
                        ),
                        onPressed: _isRecording ? _stopListening : _startListening,
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
                  color: canSend && !_isLoading
                      ? const Color(0xFFF57C00)
                      : scheme.surfaceContainerHighest,
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
                  // Keep the hit target active; _sendMessage validates empty
                  // input itself. This avoids the button becoming stuck when
                  // the controller changes while the keyboard is open.
                  onPressed: _isLoading ? null : _sendMessage,
                ),
              ),
            ],
          ),
          if (_isRecording)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: scheme.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.error.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Recording... Tap the mic button again to stop',
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final scheme = Theme.of(context).colorScheme;
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
                color: isUser ? const Color(0xFFF57C00) : scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: isUser ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(18),
                ),
                border: isUser ? null : Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? Colors.white : scheme.onSurface,
                      height: 1.6,
                    ),
                  ),
                  if (message.attachments != null && message.attachments!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: message.attachments!.map((attachment) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.white.withValues(alpha: 0.2) : scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getFileIcon(attachment.extension),
                                color: isUser ? Colors.white : scheme.onSurfaceVariant,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                attachment.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isUser ? Colors.white : scheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 9,
                      color: isUser ? Colors.white70 : scheme.onSurfaceVariant,
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
                    color: const Color(0xFFF57C00).withValues(alpha: 0.3)),
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

  Widget _buildTypingIndicator() {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 44, bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text('Jaguza AI is thinking…', style: TextStyle(
          color: scheme.onSurfaceVariant, fontSize: 13,
        )),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    // Stop recording if active
    if (_isRecording) {
      _stopListening();
    }

    final attachments = List<FileAttachment>.from(_attachments);
    final userMessage = ChatMessage(
      text: text.isEmpty ? '📎 Sent ${attachments.length} file(s)' : text,
      isUser: true,
      timestamp: DateTime.now(),
      attachments: attachments,
    );

    setState(() {
      _messages.add(userMessage);
      _messageController.clear();
      _attachments.clear();
      _isLoading = true;
    });
    _scrollToLatest();

    try {
      final result = await ApiService().sendChatMessage(
        text.isEmpty ? 'Please help me with the attached farm file.' : text,
        language: _selectedLanguage,
      );
      final rawReply = result['ai_response'] ?? result['response'] ?? result['message'];
      final reply = rawReply is Map ? rawReply['message'] : rawReply;
      final response = '${reply ?? ''}'.trim();
      if (response.isEmpty) throw Exception('The AI returned an empty response.');
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false, timestamp: DateTime.now()));
        _isLoading = false;
      });
      _scrollToLatest();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          text: 'I could not reach Jaguza AI right now. Please try again.\n\n$e',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
      _scrollToLatest();
    }
  }

  void _clearChat() {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          'Clear Chat',
          style: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete all messages? This cannot be undone.',
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ApiService().clearChatHistory();
                if (!mounted) return;
                setState(() {
                  _messages.clear();
                  _attachments.clear();
                });
              } catch (e) {
                if (mounted) _showSnackBar('Could not clear chat: $e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
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
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<FileAttachment>? attachments;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.attachments,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments?.map((a) => a.toJson()).toList(),
    };
  }
}

class FileAttachment {
  final String name;
  final int size;
  final Uint8List? bytes;
  final String extension;

  FileAttachment({
    required this.name,
    required this.size,
    this.bytes,
    required this.extension,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'size': size,
      'extension': extension,
    };
  }
}
