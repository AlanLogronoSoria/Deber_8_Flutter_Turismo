import 'package:flutter/material.dart';

import '../data/lugares_data.dart';
import '../widgets/lugar_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Turismo en Quito',
        ),
      ),
      body: ListView.builder(
        itemCount: lugares.length,
        itemBuilder: (context, index) {
          return LugarCard(
            lugar: lugares[index],
          );
        },
      ),
    );
  }
}