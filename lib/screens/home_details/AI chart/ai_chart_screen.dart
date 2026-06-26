import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/app_models.dart';


class AIChatTab extends StatefulWidget {
  const AIChatTab({super.key});

  @override
  State<AIChatTab> createState() => _AIChatTabState();
}

class _AIChatTabState extends State<AIChatTab>
    with TickerProviderStateMixin {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late AnimationController _typingController;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _typingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _addBotMessage(
        'Hello! I\'m Jaguza AI 🤖\n\nI can help you with:\n• Disease diagnosis & treatment\n• Farm management tips\n• Vaccination schedules\n• Market prices & trends\n\nWhat would you like to know?');
  }

  @override
  void dispose() {
    _msgController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() => _messages
        .add(ChatMessage(text: text, isUser: false, time: _now())));
    Future.delayed(
        const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    _msgController.clear();
    setState(() => _messages
        .add(ChatMessage(text: text, isUser: true, time: _now())));
    _scrollToBottom();
    setState(() => _isTyping = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() => _isTyping = false);
      _addBotMessage(_generateResponse(text));
    });
  }

  String _generateResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('poultry') || q.contains('chicken')) {
      return '📋 **Poultry Farming Tips:**\n\n• Ensure proper ventilation in coops\n• Vaccinate against Newcastle disease\n• Provide clean water at all times\n• Use balanced feed with 18-20% protein for layers\n• Isolate sick birds immediately\n\nWould you like detailed info on a specific disease?';
    } else if (q.contains('cattle') || q.contains('cow')) {
      return '🐄 **Cattle Care Guide:**\n\n• Deworm every 3 months\n• Provide mineral licks freely\n• Ensure 40-60 liters of water/day\n• Vaccinate against FMD, anthrax & CBPP\n• Monitor body condition score monthly\n\nNeed help with a specific health issue?';
    } else if (q.contains('pig') || q.contains('swine')) {
      return '🐷 **Swine Management:**\n\n• Biosecurity is critical\n• Vaccinate against ASF\n• Balanced ration with 16% protein\n• Maintain proper drainage in pens\n• Wean piglets at 6-8 weeks\n\nAsk me about any pig disease symptoms!';
    } else if (q.contains('disease') || q.contains('sick')) {
      return '🔬 **Disease Diagnosis Help:**\n\nPlease describe the symptoms:\n1. Which animal type?\n2. What symptoms are visible?\n3. How many animals affected?\n4. When did it start?\n5. Any recent changes in feed?\n\nThe more details, the better!';
    } else if (q.contains('market') || q.contains('price') || q.contains('sell')) {
      return '💰 **Current Market Insights:**\n\n• Broiler chicken: UGX 25,000-30,000\n• Layer (point of lay): UGX 20,000-25,000\n• Friesian heifer: UGX 2M-3.5M\n• Local goat: UGX 150,000-250,000\n\nPrices vary by region!';
    } else if (q.contains('vaccin')) {
      return '💉 **Vaccination Calendar:**\n\n**Poultry:** Newcastle (day 7, 21), Gumboro (day 14, 28)\n**Cattle:** FMD (every 6 months), Anthrax (annual)\n**Pigs:** CSF (8-12 weeks)\n**Goats:** PPR (3 months), CCPP (6 months)\n\nConsult your vet for a custom schedule.';
    }
    return 'Thanks for your question! 🌿\n\nI can help with:\n• Animal diseases & treatment\n• Farm management\n• Vaccination schedules\n• Feed & nutrition\n• Market prices\n\nCould you be more specific?';
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _now() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildChatHeader(),
        Expanded(child: _buildMessageList()),
        if (_isTyping) _buildTypingIndicator(),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildChatHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Color(0xFF1B5E20),
              blurRadius: 16,
              offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: Row(
        children: [
          Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xFFFF8F00),
                    Color(0xFFF57C00)
                  ]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color:
                            const Color(0xFFF57C00).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ]),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Jaguza AI Assistant',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Row(children: [
                  Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Text('Online • Ready to help',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12)),
                ]),
              ],
            ),
          ),
          Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(13)),
              child: const Icon(Icons.history_rounded,
                  color: Colors.white, size: 21)),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      physics: const BouncingScrollPhysics(),
      itemCount: _messages.length,
      itemBuilder: (context, index) =>
          _ChatBubble(message: _messages[index]),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [
                    Color(0xFFFF8F00),
                    Color(0xFFF57C00)
                  ]),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 16)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return _TypingDot(
                    index: i, controller: _typingController);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.attach_file_rounded,
                    color: Color(0xFF2E7D32), size: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: TextField(
                  controller: _msgController,
                  onSubmitted: (_) => _sendMessage(),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                    hintText: 'Ask Jaguza AI anything...',
                    hintStyle: TextStyle(
                        color: Color(0xFFBDBDBD), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color(0xFF2E7D32),
                        Color(0xFF43A047)
                      ]),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF2E7D32)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3))
                      ]),
                  child: const Icon(Icons.send_rounded,
                      color: Colors.white, size: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  CHAT BUBBLE WIDGET
// ═══════════════════════════════════════════════════════════════
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 8, top: 4),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFFFF8F00),
                      Color(0xFFF57C00)
                    ]),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.auto_awesome_rounded,
                    color: Colors.white, size: 16)),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  constraints: BoxConstraints(
                      maxWidth:
                          MediaQuery.of(context).size.width * 0.78),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFF2E7D32)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black
                              .withOpacity(isUser ? 0.1 : 0.04),
                          blurRadius: isUser ? 10 : 6,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Text(message.text,
                      style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : const Color(0xFF333333),
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: isUser
                              ? FontWeight.w500
                              : FontWeight.w400)),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(message.time,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey[400])),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(left: 8, top: 4),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [
                      Color(0xFF2E7D32),
                      Color(0xFF43A047)
                    ]),
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 16)),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  TYPING DOT WIDGET
// ═══════════════════════════════════════════════════════════════
class _TypingDot extends StatelessWidget {
  final int index;
  final AnimationController controller;
  const _TypingDot({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    final delay = (index * 0.2).clamp(0.0, 0.4);
    final sizeAnim = Tween<double>(begin: 6.0, end: 10.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, delay + 0.4, curve: Curves.easeInOut),
      ),
    );
    final fadeAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, delay + 0.4, curve: Curves.easeInOut),
      ),
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: sizeAnim.value,
          height: sizeAnim.value,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: Color.lerp(
                Colors.grey[300], Colors.grey[500], fadeAnim.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  GENERIC ANIMATED BUILDER (used by typing dots)
// ═══════════════════════════════════════════════════════════════
class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}