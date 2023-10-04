import 'package:flutter/material.dart';

class MapWyzeButton extends StatelessWidget {
  const MapWyzeButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
  final String text;
  final IconData icon;
  final Color color;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        onPressed();
      },
      icon: Icon(
        icon,
        size: 20,
      ),
      label: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      ),
    );
  }
}
