import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AIChatTab extends StatefulWidget {
  const AIChatTab({super.key});

  @override
  State<AIChatTab> createState() => _AIChatTabState();
}

class _AIChatTabState extends State<AIChatTab> {
  final TextEditingController _messageController = TextEditingController();
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
    _initSpeech();
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
    _messageController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Attachments bar
          if (_attachments.isNotEmpty) _buildAttachmentsBar(),
          Expanded(
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
          if (_messages.isNotEmpty) _buildQuickQuestions(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildAttachmentsBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
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
                      color: Colors.grey[700],
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
                    color: Colors.grey[400],
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
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
              color: const Color(0xFF1A1F36),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your intelligent farming assistant',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
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
                  color: Colors.grey[200],
                  thickness: 1,
                  indent: 40,
                  endIndent: 16,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.grey[400],
                size: 20,
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey[200],
                  thickness: 1,
                  indent: 16,
                  endIndent: 40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Start typing your question below',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
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
                    color: const Color(0xFFF57C00).withOpacity(0.15),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Attachment button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _attachments.isNotEmpty ? const Color(0xFFFFF3E0) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: _attachments.isNotEmpty 
                      ? Border.all(color: const Color(0xFFF57C00).withOpacity(0.3))
                      : null,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: _attachments.isNotEmpty ? const Color(0xFFF57C00) : Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: _pickFile,
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
                    style: const TextStyle(color: Color(0xFF1A1F36), fontSize: 14),
                    decoration: InputDecoration(
                      hintText: _isRecording ? 'Listening...' : 'Type your question...',
                      hintStyle: TextStyle(
                        fontSize: 14, 
                        color: _isRecording ? Colors.grey[700] : Colors.grey[500],
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                          color: _isRecording ? Colors.red : Colors.grey[500],
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
                  color: _messageController.text.isNotEmpty || _attachments.isNotEmpty
                      ? const Color(0xFFF57C00)
                      : Colors.grey[300],
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
                  onPressed: (_messageController.text.isNotEmpty || _attachments.isNotEmpty) && !_isLoading
                      ? _sendMessage
                      : null,
                ),
              ),
            ],
          ),
          if (_isRecording)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Recording... Tap the mic button again to stop',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade700,
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
                      fontSize: 14,
                      color: isUser ? Colors.white : const Color(0xFF1A1F36),
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
                            color: isUser ? Colors.white.withOpacity(0.2) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getFileIcon(attachment.extension),
                                color: isUser ? Colors.white : Colors.grey[700],
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                attachment.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isUser ? Colors.white : Colors.grey[700],
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
    if (text.isEmpty && _attachments.isEmpty) return;

    // Stop recording if active
    if (_isRecording) {
      _stopListening();
    }

    final attachments = List<FileAttachment>.from(_attachments);

    setState(() {
      _messages.add(ChatMessage(
        text: text.isEmpty ? '📎 Sent ${attachments.length} file(s)' : text,
        isUser: true,
        timestamp: DateTime.now(),
        attachments: attachments,
      ));
      _messageController.clear();
      _attachments.clear();
      _isLoading = true;
    });

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      
      String response = _getAIResponse(text);
      
      // If there are attachments, acknowledge them
      if (attachments.isNotEmpty) {
        response = 'I received your file(s). ${attachments.length > 1 ? 'They have been' : 'It has been'} uploaded successfully. $response';
      }
      
      setState(() {
        _messages.add(ChatMessage(
          text: response,
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
                _attachments.clear();
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
}