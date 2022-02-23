import 'package:flutter/material.dart';

class Sobre extends StatelessWidget {
  const Sobre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          child: Text(
            'App desenvolvido pela ThinkAloud Solutions',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
