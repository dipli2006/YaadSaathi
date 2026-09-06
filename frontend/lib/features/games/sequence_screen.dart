import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';
import 'models/sequence_puzzle.dart';

class SequenceScreen extends StatefulWidget {
  const SequenceScreen({super.key});

  @override
  State<SequenceScreen> createState() => _SequenceScreenState();
}

class _SequenceScreenState extends State<SequenceScreen> {
  final _generator = SequencePuzzleGenerator();
  late SequencePuzzle _puzzle;
  final _selected = <int>[];
  String? _message;

  @override
  void initState() {
    super.initState();
    _puzzle = _generator.next();
  }

  void _select(int value) {
    if (_selected.contains(value)) {
      return;
    }
    setState(() => _selected.add(value));
    if (_selected.length == _puzzle.answer.length) {
      setState(() {
        _message = _selected.join() == _puzzle.answer.join()
            ? 'Wonderful. You found the order.'
            : 'That is okay. Let us try the order again.';
      });
    }
  }

  void _reset() {
    setState(() {
      _puzzle = _generator.next();
      _selected.clear();
      _message = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sequence'),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            const Text(
              'Choose the numbers in their natural order.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: _puzzle.choices
                  .map(
                    (value) => SizedBox(
                      width: 120,
                      height: 100,
                      child: ElevatedButton(
                        onPressed: _selected.length == _puzzle.answer.length
                            ? null
                            : () => _select(value),
                        child: Text('$value', style: const TextStyle(fontSize: 32)),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 28),
            Text(
              _selected.isEmpty ? 'Your order will appear here.' : _selected.join('  '),
              style: const TextStyle(fontSize: 24),
            ),
            if (_message != null) ...[
              const SizedBox(height: 24),
              Text(_message!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
            ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}