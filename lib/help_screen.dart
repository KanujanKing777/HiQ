import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// Access your API key as an environment variable (see "Set up your API key" above)
final apiKey = 'AIzaSyAMr6gYkI6ZAqSdAAz67xRtfogvYJbALTw';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add an initial bot message
    _messages.add({'sender': 'bot', 'message': 'How can we assist you today?'});
  }

  void _sendMessage(String text) async{
    if (text.trim().isEmpty) return;
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );
    final prompt = text;
    final response = await model.generateContent([Content.text(prompt)]);
    setState(() {
      _messages.add({'sender': 'user', 'message': text});
      _messages.add({
        'sender': 'bot',
        'message': '${response.text}'
      });
      _controller.clear();
      // Make sure to include this import:
// import 'package:google_generative_ai/google_generative_ai.dart';
      
    });
  }

  Widget _buildChatBubble(String message, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot', style: TextStyle(color: Colors.white),),
        backgroundColor: isLightMode ? Colors.blue : Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isUser = message['sender'] == 'user';
                return _buildChatBubble(message['message']!, isUser);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
