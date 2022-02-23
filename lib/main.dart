import 'package:conta_de_luz/screens/Taxa/formulario_taxa.dart';
import 'package:conta_de_luz/screens/Contas/lista_contas.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ContaDeLuz());
}

class ContaDeLuz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListaContas(),
    );
  }
}
