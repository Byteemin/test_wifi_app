import 'package:flutter/material.dart';

class BoottomNavigationWidget extends StatefulWidget {
  const BoottomNavigationWidget({
    super.key,
  });

  @override
  State<BoottomNavigationWidget> createState() => _BoottomNavigationWidgetState();
}

class _BoottomNavigationWidgetState extends State<BoottomNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'label'),
        NavigationDestination(icon: Icon(Icons.home), label: 'label'),
      ],
    );
  }
}