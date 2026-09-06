import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';

class RememberObjectsScreen extends StatefulWidget {
  const RememberObjectsScreen({super.key});

  @override
  State<RememberObjectsScreen> createState() => _RememberObjectsScreenState();
}

class _RememberObjectsScreenState extends State<RememberObjectsScreen> {
  static final _remembered = {
    Icons.local_florist,
    Icons.home,
    Icons.coffee,
  };

  static const _choices = [
    Icons.local_florist,
    Icons.home,
    Icons.coffee,
    Icons.directions_car,
    Icons.pets,
    Icons.music_note,
  ];

  bool _isRemembering = true;
  final _selected = <IconData>{};
  String? _message;

  void _checkSelection() {
    final isCorrect = _selected.length == _remembered.length &&
        _selected.containsAll(_remembered);
    setState(() {
      _message = isCorrect
          ? 'Well done. You remembered the objects.'
          : 'That is okay. Take another look and try again.';
    });
  }

  void _reset() {
    setState(() {
      _isRemembering = true;
      _selected.clear();
      _message = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remember Objects'),
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
            Text(
              _isRemembering
                  ? 'Look at these objects and remember them.'
                  : 'Which objects did you see?',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: (_isRemembering ? _remembered.toList() : _choices)
                    .map(
                      (icon) => _ObjectTile(
                        icon: icon,
                        isSelected: _selected.contains(icon),
                        onTap: _isRemembering
                            ? null
                            : () => setState(() {
                                  if (_selected.contains(icon)) {
                                    _selected.remove(icon);
                                  } else {
                                    _selected.add(icon);
                                  }
                                }),
                      ),
                    )
                    .toList(),
              ),
            ),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ElevatedButton(
              onPressed: _isRemembering
                  ? () => setState(() => _isRemembering = false)
                  : _checkSelection,
              child: Text(_isRemembering ? 'I am ready' : 'Check my answer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ObjectTile extends StatelessWidget {
  const _ObjectTile({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.primaryContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Icon(icon, size: 58),
      ),
    );
  }
}