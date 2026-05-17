import 'package:flutter/material.dart';

class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.text,
    required this.index,
    required this.selectedIndex,
    required this.correctIndex,
    required this.submitted,
    required this.onTap,
  });

  final String text;
  final int index;
  final int? selectedIndex;
  final int correctIndex;
  final bool submitted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    final isCorrectChoice = correctIndex == index;

    Color? backgroundColor;
    IconData? icon;

    if (submitted) {
      if (isCorrectChoice) {
        backgroundColor = Colors.green.withValues(alpha: 0.15);
        icon = Icons.check;
      } else if (isSelected && !isCorrectChoice) {
        backgroundColor = Colors.red.withValues(alpha: 0.15);
        icon = Icons.close;
      }
    }

    return Card(
      color: backgroundColor,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text(text),
        trailing: icon == null ? null : Icon(icon),
        selected: isSelected,
      ),
    );
  }
}
