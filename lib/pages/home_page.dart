import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_drawer.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('HomePage'),
      ),
      drawer: const MyDrawer(),
    );
  }
}
