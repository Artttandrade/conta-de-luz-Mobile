import 'package:conta_de_luz/databases/conta_database.dart';
import 'package:conta_de_luz/models/Conta.dart';
import 'package:conta_de_luz/screens/Contas/edit_conta.dart';
import 'package:flutter/material.dart';

class ShowConta extends StatefulWidget {
  Conta conta;
  List<Conta> listaContas;

  ShowConta(this.conta, this.listaContas);

  @override
  _ShowContaState createState() => _ShowContaState();
}

class _ShowContaState extends State<ShowConta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mês: ${widget.conta.mes}'),
      ),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Card(
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                alignment: Alignment.centerLeft,
                width: double.maxFinite,
                child: Text(
                  'Mês: ${this.widget.conta.mes}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Text(
                  'Número Contador: ${widget.conta.numeroConta}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Card(
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Text(
                  'Valor: ${widget.conta.valor}',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  goToEditScreen(context);
                },
                child: Text('Editar'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    deleteDialog(context);
                  },
                  child: Text('Deletar'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void deleteDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Deletar esta conta'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'cancelar');
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'deletar');
            },
            child: Text('Deletar'),
          ),
        ],
      ),
    ).then((value) {
      if (value != 'cancelar') {
        deleteConta(widget.conta);
        Navigator.pop(context);
      }
    });
  }

  void goToEditScreen(BuildContext context) {
    print(widget.conta.id);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditConta(this.widget.conta))).then(
      (value) => checkConta(value),
    );
  }

  void checkConta(value) {
    if (value != null) {
      this
              .widget
              .listaContas[this.widget.listaContas.indexOf(this.widget.conta)] =
          value;
      setState(
        () {
          widget.conta = value;
        },
      );
    }
  }
}
