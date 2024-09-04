// features/payouts_card/widgets/payouts_card_widget.dart
import 'package:flutter/material.dart';

class PayoutsCardWidget extends StatelessWidget {
  final Map<String, double> payouts;

  const PayoutsCardWidget({super.key, required this.payouts});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Final Payouts', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (var entry in payouts.entries)
              Text('${entry.key}: ${entry.value >= 0 ? '+' : ''}\$${entry.value.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}