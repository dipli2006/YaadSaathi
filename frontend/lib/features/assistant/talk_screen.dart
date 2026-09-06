import 'package:flutter/material.dart';

class TalkScreen extends StatefulWidget {
  const TalkScreen({super.key});

  @override
  State<TalkScreen> createState() => _TalkScreenState();
}

class _TalkScreenState extends State<TalkScreen> {
  final _messageController = TextEditingController();
  final _messages = <String>['Hello. I am here to listen.'];
  bool _isListening = false;
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) {
      return;
    }
    setState(() {
      _messages.add(message);
      _messageController.clear();
      _isSending = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    setState(() {
      _messages.add('Thank you for telling me. I am listening.');
      _isSending = false;
    });
  }

  void _toggleListening() {
    setState(() => _isListening = !_isListening);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Talk')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) => Align(
                alignment: index.isEven ? Alignment.centerLeft : Alignment.centerRight,
                child: Card(
                  color: index.isEven
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(_messages[index], style: const TextStyle(fontSize: 19)),
                  ),
                ),
              ),
            ),
          ),
          if (_isSending) const LinearProgressIndicator(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  IconButton.filled(
                    onPressed: _toggleListening,
                    icon: Icon(_isListening ? Icons.stop : Icons.mic),
                    tooltip: _isListening ? 'Stop listening' : 'Start listening',
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(hintText: 'Type a message'),
                    ),
                  ),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    tooltip: 'Send message',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}