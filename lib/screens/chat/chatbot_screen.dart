import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _addBotMessage(
      'Hello! I\'m ShakeWake\'s virtual assistant. How can I help you today?',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _messageController.clear();
    
    if (text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
      ));
      _isTyping = true;
    });
    
    // Simulate bot thinking
    Future.delayed(const Duration(seconds: 1), () {
      _respondToMessage(text);
    });
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
      ));
      _isTyping = false;
    });
  }

  void _respondToMessage(String message) {
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('menu') || lowerMessage.contains('items') || 
        lowerMessage.contains('products') || lowerMessage.contains('drinks')) {
      _addBotMessage(
        'We offer a variety of beverages including coffee, shakes, smoothies, and more! '
        'You can check our full menu in the Menu tab.',
      );
    } else if (lowerMessage.contains('hour') || lowerMessage.contains('open') || 
               lowerMessage.contains('close') || lowerMessage.contains('timing')) {
      _addBotMessage(
        'ShakeWake I-8 is open from 9:00 AM to 11:00 PM, seven days a week.',
      );
    } else if (lowerMessage.contains('location') || lowerMessage.contains('address') || 
               lowerMessage.contains('where')) {
      _addBotMessage(
        'We are located in Sector I-8, Islamabad. You can find us near the main market.',
      );
    } else if (lowerMessage.contains('delivery') || lowerMessage.contains('time') || 
               lowerMessage.contains('how long')) {
      _addBotMessage(
        'Our typical delivery time is 30-45 minutes, depending on your location and order volume.',
      );
    } else if (lowerMessage.contains('payment') || lowerMessage.contains('pay') || 
               lowerMessage.contains('cash') || lowerMessage.contains('card')) {
      _addBotMessage(
        'We currently accept Cash on Delivery (COD) only.',
      );
    } else if (lowerMessage.contains('order') && (lowerMessage.contains('track') || 
               lowerMessage.contains('status'))) {
      _addBotMessage(
        'You can track your order status in the Orders tab. If you have any specific concerns, '
        'please call us at 051-1234567.',
      );
    } else if (lowerMessage.contains('cancel') && lowerMessage.contains('order')) {
      _addBotMessage(
        'To cancel an order, please call us immediately at 051-1234567. '
        'Note that orders already in preparation may not be eligible for cancellation.',
      );
    } else if (lowerMessage.contains('hello') || lowerMessage.contains('hi') || 
               lowerMessage.contains('hey')) {
      _addBotMessage(
        'Hello there! How can I assist you with ShakeWake today?',
      );
    } else if (lowerMessage.contains('thank')) {
      _addBotMessage(
        'You\'re welcome! Is there anything else I can help you with?',
      );
    } else if (lowerMessage.contains('bye') || lowerMessage.contains('goodbye')) {
      _addBotMessage(
        'Thank you for chatting with ShakeWake! Have a great day!',
      );
    } else {
      _addBotMessage(
        'I\'m not sure I understand. Would you like to know about our menu, location, '
        'delivery times, or something else?',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShakeWake Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About ShakeWake Assistant'),
                  content: const Text(
                    'This is a simple rule-based chatbot to help with basic queries. '
                    'For complex issues, please contact our customer support at 051-1234567.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[_messages.length - 1 - index];
              },
            ),
          ),
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: const Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Typing...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask me anything...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF8B4513),
                  onPressed: () => _handleSubmitted(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF8B4513),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.coffee,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFF8B4513)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}