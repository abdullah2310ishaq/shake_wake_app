import 'package:flutter/material.dart';

// Custom colors
const Color mustardColor = Color(0xFFFFD700); // Mustard color
const Color blackColor = Color(0xFF000000); // Black color

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

    if (lowerMessage.contains('menu') ||
        lowerMessage.contains('items') ||
        lowerMessage.contains('products') ||
        lowerMessage.contains('drinks')) {
      _addBotMessage(
        'We offer a variety of beverages including coffee, shakes, smoothies, and more! '
        'You can check our full menu in the Menu tab.',
      );
    } else if (lowerMessage.contains('hour') ||
        lowerMessage.contains('open') ||
        lowerMessage.contains('close') ||
        lowerMessage.contains('timing')) {
      _addBotMessage(
        'ShakeWake I-8 is open from 9:00 AM to 11:00 PM, seven days a week.',
      );
    } else if (lowerMessage.contains('location') ||
        lowerMessage.contains('address') ||
        lowerMessage.contains('where')) {
      _addBotMessage(
        'We are located in Sector I-8, Islamabad. You can find us near the main market.',
      );
    } else if (lowerMessage.contains('delivery') ||
        lowerMessage.contains('time') ||
        lowerMessage.contains('how long')) {
      _addBotMessage(
        'Our typical delivery time is 30-45 minutes, depending on your location and order volume.',
      );
    } else if (lowerMessage.contains('payment') ||
        lowerMessage.contains('pay') ||
        lowerMessage.contains('cash') ||
        lowerMessage.contains('card')) {
      _addBotMessage(
        'We currently accept Cash on Delivery (COD) only.',
      );
    } else if (lowerMessage.contains('order') &&
        (lowerMessage.contains('track') || lowerMessage.contains('status'))) {
      _addBotMessage(
        'You can track your order status in the Orders tab. If you have any specific concerns, '
        'please call us at 051-1234567.',
      );
    } else if (lowerMessage.contains('cancel') &&
        lowerMessage.contains('order')) {
      _addBotMessage(
        'To cancel an order, please call us immediately at 051-1234567. '
        'Note that orders already in preparation may not be eligible for cancellation.',
      );
    } else if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hey')) {
      _addBotMessage(
        'Hello there! How can I assist you with ShakeWake today?',
      );
    } else if (lowerMessage.contains('thank')) {
      _addBotMessage(
        'You\'re welcome! Is there anything else I can help you with?',
      );
    } else if (lowerMessage.contains('bye') ||
        lowerMessage.contains('goodbye')) {
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
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: blackColor, // Set scaffold background to black
      appBar: AppBar(
        title: const Text(
          'ShakeWake Assistant',
          style: TextStyle(color: mustardColor), // Title to mustard
        ),
        backgroundColor: blackColor, // AppBar background to black
        iconTheme: const IconThemeData(color: mustardColor), // Icons to mustard
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            color: mustardColor, // Icon to mustard
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: blackColor, // Dialog background to black
                  title: Text(
                    'About ShakeWake Assistant',
                    style: TextStyle(
                      color: mustardColor, // Title to mustard
                      fontSize: screenSize.width * 0.05, // 5% of screen width
                    ),
                  ),
                  content: Text(
                    'This is a simple rule-based chatbot to help with basic queries. '
                    'For complex issues, please contact our customer support at 0300 0099222.',
                    style: TextStyle(
                      color: mustardColor
                          .withOpacity(0.6), // Text to lighter mustard
                      fontSize: screenSize.width * 0.04, // 4% of screen width
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'OK',
                        style: TextStyle(
                          color: mustardColor, // Text to mustard
                          fontSize:
                              screenSize.width * 0.04, // 4% of screen width
                        ),
                      ),
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        screenSize.width * 0.03), // 3% of screen width
                  ),
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
              padding:
                  EdgeInsets.all(screenSize.width * 0.04), // 4% of screen width
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[_messages.length - 1 - index];
              },
            ),
          ),
          if (_isTyping)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.04, // 4% of screen width
                vertical: screenSize.height * 0.01, // 1% of screen height
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  SizedBox(
                    width: screenSize.width * 0.05, // 5% of screen width
                    height: screenSize.width * 0.05, // Keep square
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: mustardColor, // Indicator to mustard
                    ),
                  ),
                  SizedBox(
                      width: screenSize.width * 0.02), // 2% of screen width
                  Text(
                    'Typing...',
                    style: TextStyle(
                      color: mustardColor
                          .withOpacity(0.6), // Text to lighter mustard
                      fontStyle: FontStyle.italic,
                      fontSize:
                          screenSize.width * 0.035, // 3.5% of screen width
                    ),
                  ),
                ],
              ),
            ),
          Divider(
            height: 1,
            color: mustardColor.withOpacity(0.3), // Divider to mustard
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.02), // 2% of screen width
            color: blackColor, // Background to black
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle: TextStyle(
                        color: mustardColor
                            .withOpacity(0.6), // Hint to lighter mustard
                        fontSize: screenSize.width * 0.04, // 4% of screen width
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(
                          screenSize.width * 0.04), // 4% of screen width
                    ),
                    style: TextStyle(
                      color: mustardColor, // Text to mustard
                      fontSize: screenSize.width * 0.04, // 4% of screen width
                    ),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: mustardColor, // Icon to mustard
                  iconSize: screenSize.width * 0.06, // 6% of screen width
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
    // Get screen size for responsive scaling
    final screenSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.01), // 1% of screen height
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: screenSize.width * 0.09, // 9% of screen width
              height: screenSize.width * 0.09, // Keep square
              decoration: BoxDecoration(
                color: mustardColor, // Background to mustard
                borderRadius: BorderRadius.circular(
                    screenSize.width * 0.045), // Half of width
              ),
              child: Icon(
                Icons.coffee,
                color: blackColor, // Icon to black
                size: screenSize.width * 0.05, // 5% of screen width
              ),
            ),
            SizedBox(width: screenSize.width * 0.02), // 2% of screen width
          ],
          Flexible(
            child: Container(
              padding:
                  EdgeInsets.all(screenSize.width * 0.03), // 3% of screen width
              decoration: BoxDecoration(
                color: isUser
                    ? mustardColor // User bubble to mustard
                    : mustardColor
                        .withOpacity(0.2), // Bot bubble to lighter mustard
                borderRadius: BorderRadius.circular(
                    screenSize.width * 0.04), // 4% of screen width
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: blackColor, // Text to black
                  fontSize: screenSize.width * 0.04, // 4% of screen width
                ),
              ),
            ),
          ),
          if (isUser)
            SizedBox(width: screenSize.width * 0.02), // 2% of screen width
        ],
      ),
    );
  }
}
