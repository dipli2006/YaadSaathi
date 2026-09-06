import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';

class MemoryMatchScreen extends StatefulWidget {
  const MemoryMatchScreen({super.key});

  @override
  State<MemoryMatchScreen> createState() => _MemoryMatchScreenState();
}

class _MemoryMatchScreenState extends State<MemoryMatchScreen> {
  static const _cards = [
    Icons.home,
    Icons.home,
    Icons.local_florist,
    Icons.local_florist,
    Icons.favorite,
    Icons.favorite,
  ];

  final _random = Random();
  late List<IconData> _shuffledCards;
  final _openCards = <int>[];
  final _matchedCards = <int>{};
  bool _checkingPair = false;

  @override
  void initState() {
    super.initState();
    _shuffledCards = [..._cards]..shuffle(_random);
  }

  Future<void> _selectCard(int index) async {
    if (_checkingPair ||
        _matchedCards.contains(index) ||
        _openCards.contains(index) ||
        _openCards.length == 2) {
      return;
    }

    setState(() => _openCards.add(index));
    if (_openCards.length != 2) {
      return;
    }

    _checkingPair = true;
    final first = _openCards[0];
    final second = _openCards[1];
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) {
      return;
    }

    if (_shuffledCards[first] == _shuffledCards[second]) {
      setState(() {
        _matchedCards.addAll(_openCards);
        _openCards.clear();
        _checkingPair = false;
      });
      if (_matchedCards.length == _shuffledCards.length) {
        _showCompletion();
      }
    } else {
      setState(() {
        _openCards.clear();
        _checkingPair = false;
      });
    }
  }

  void _showCompletion() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Wonderful!'),
        content: const Text('You found all the pairs.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _reset() {
    setState(() {
      _shuffledCards = [..._cards]..shuffle(_random);
      _openCards.clear();
      _matchedCards.clear();
      _checkingPair = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        leading: IconButton(
          onPressed: () => Navigator.popUntil(
            context,
            ModalRoute.withName(AppRoutes.elderlyHome),
          ),
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Home',
        ),
        actions: [
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
            tooltip: 'Try again',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Find the cards that belong together.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _shuffledCards.length,
                itemBuilder: (context, index) {
                  final isVisible =
                      _openCards.contains(index) || _matchedCards.contains(index);
                  return _MemoryCard(
                    icon: _shuffledCards[index],
                    isVisible: isVisible,
                    isMatched: _matchedCards.contains(index),
                    onTap: () => _selectCard(index),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _matchedCards.length == _shuffledCards.length
                  ? null
                  : () {
                      final hidden = List<int>.generate(
                        _shuffledCards.length,
                        (index) => index,
                      )..removeWhere(
                          (index) => _matchedCards.contains(index),
                        );
                      if (hidden.isNotEmpty) {
                        final hint = hidden.first;
                        setState(() => _openCards.add(hint));
                      }
                    },
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('Give me a hint'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryCard extends StatelessWidget {
  const _MemoryCard({
    required this.icon,
    required this.isVisible,
    required this.isMatched,
    required this.onTap,
  });

  final IconData icon;
  final bool isVisible;
  final bool isMatched;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isMatched
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Icon(
            isVisible ? icon : Icons.question_mark,
            size: 56,
          ),
        ),
      ),
    );
  }
}