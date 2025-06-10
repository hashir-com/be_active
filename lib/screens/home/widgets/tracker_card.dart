import 'package:flutter/material.dart';

class TrackerCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final int value;
  final int goal;
  final VoidCallback onTap;
  final Color? iconColor; // 🎨 Optional icon color

  const TrackerCard({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.goal,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    double progress = value / goal;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Theme.of(context).shadowColor.withOpacity(0.12),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 45,
                  width: 45,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 5,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Icon(
                  icon,
                  size: 24,
                  color: iconColor ?? Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Text(
              '$value of $goal $label',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).primaryColor,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
