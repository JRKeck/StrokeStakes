import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BetAmountInputs extends StatelessWidget {
  final TextEditingController zookeeperController;
  final TextEditingController greeniesController;
  final TextEditingController wadController;

  const BetAmountInputs({
    super.key,
    required this.zookeeperController,
    required this.greeniesController,
    required this.wadController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildBetInput(zookeeperController, 'Zookeeper Bet Amount'),
        _buildBetInput(greeniesController, 'Greenies Bet Amount'),
        _buildBetInput(wadController, 'Wad Bet Amount'),
      ],
    );
  }

  Widget _buildBetInput(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: '\$',
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      validator: _validateBetAmount,
    );
  }

  String? _validateBetAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a bet amount';
    }
    final numericValue = double.tryParse(value);
    if (numericValue == null || numericValue <= 0) {
      return 'Please enter a valid bet amount';
    }
    return null;
  }
}