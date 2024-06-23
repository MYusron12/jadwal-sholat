import 'package:flutter/material.dart';

class AlQuranScreen extends StatelessWidget {
  const AlQuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AlQuran'),
      ),
      body: const Center(
        child: Text('Ini adalah halaman AlQuran'),
      ),
    );
  }
}