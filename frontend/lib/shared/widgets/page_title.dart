import 'package:flutter/material.dart';

import '../../core/theme/text_styles.dart';

class PageTitle extends StatelessWidget {
  final String title;

  const PageTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.title,
    );
  }
}