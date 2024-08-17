import 'package:flutter/material.dart';

class BootPage extends StatelessWidget {
  const BootPage({required this.onBoot, super.key});

  final ValueChanged<BuildContext> onBoot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Builder(
        builder: (context) {
          return Center(
            child: TextButton(
              onPressed: () {
                onBoot(context);
              },
              child: const Text('!!!SHOW!!!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Lato',
                    fontFamilyFallback: ['Roboto', 'San Francisco'],
                  )),
            ),
          );
        },
      ),
    );
  }
}
