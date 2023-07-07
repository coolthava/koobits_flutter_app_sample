import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Now Loading',
        style: TextStyle(fontSize: 24, color: Colors.deepPurpleAccent),
      ),
    );
  }
}
