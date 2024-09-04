import 'package:flutter/material.dart';

class DialogTitleBar extends StatelessWidget {
  final String title;

  const DialogTitleBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor, // Use the primary color for background
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0), // Match the dialog's border radius
          topRight: Radius.circular(8.0),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .primaryTextTheme
            .titleLarge
            ?.copyWith(color: Colors.white), // Use titleLarge and set text color to white
      ),
    );
  }
}
