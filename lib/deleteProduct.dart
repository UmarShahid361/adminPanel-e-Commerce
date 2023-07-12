import 'package:flutter/material.dart';

class DeleteProduct extends StatelessWidget {
  const DeleteProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Product'),
      ),
      body: const Center(
        child: Text('Delete Product'),
      ),
    );
  }
}
