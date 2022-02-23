import 'package:conta_de_luz/OptionsConstants.dart';
import 'package:conta_de_luz/databases/conta_database.dart';
import 'package:conta_de_luz/models/Conta.dart';
import 'package:conta_de_luz/models/Taxa.dart';
import 'package:conta_de_luz/screens/Contas/estima_conta.dart';
import 'package:conta_de_luz/screens/Contas/formulario_conta.dart';
import 'package:conta_de_luz/screens/Taxa/formulario_taxa.dart';
import 'package:conta_de_luz/screens/Contas/show_conta.dart';
import 'package:conta_de_luz/screens/Options/sobre.dart';
import 'package:flutter/material.dart';

class ListaContasState extends State<ListaContas> {
  List<Conta> contas = [];

  @override
  Widget build(BuildContext context) {
    Taxa.getTaxa().then((value) => widget.taxa = value);
    return Scaffold(
      appBar: AppBar(
        title: Text('Contas'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              debugPrint(value.toString());
              if (value.toString() == 'Taxa') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FormularioTaxa(widget.taxa)));
              }
              if (value.toString() == 'Sobre') {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Sobre()));
              }
            },
            itemBuilder: (context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 35.0,
                maxHeight: (MediaQuery.of(context).size.height - 160),
              ),
              child: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 200))
                    .then((value) => findAllContas()),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return CircularProgressIndicator();
                  }

                  this.contas = snapshot.data as List<Conta>;

                  if (this.contas.length == 0) {
                    return withoutData();
                  }

                  return listBuilder();
                },
              ),
            ),
            buttonCalcular(context)
          ],
        ),
      ),
      floatingActionButton: fab(context),
    );
  }

  Padding fab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: FloatingActionButton(
        onPressed: () {
          Conta? conta;
          if (contas.isEmpty) {
            conta = null;
          } else {
            conta = contas.first;
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FormularioConta(conta, widget.taxa)));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  SizedBox buttonCalcular(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: () {
          Conta contaAntiga = contas.first;
          print(widget.taxa);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EstimaConta(contaAntiga, widget.taxa)));
        },
        child: Text('Calcular'),
      ),
    );
  }

  ListView listBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: contas.length,
      itemBuilder: (context, indice) {
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowConta(contas[indice], contas),
                ),
              ).then((value) {
                setState(() {});
              });
            },
            title: Text(contas[indice].mes),
            subtitle: Text(
              'Contador: ' + contas[indice].numeroConta,
            ),
          ),
        );
      },
    );
  }

  Padding withoutData() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('Ainda não há contas no momento.'),
          Text('Suas contas aparecerão aqui ao salvá-las.')
        ],
      ),
    );
  }

  Widget buildLista(AsyncSnapshot<Object?> snapshot, BuildContext context) {
    if (snapshot.data == null) {
      return CircularProgressIndicator();
    }

    this.contas = snapshot.data as List<Conta>;

    return ListView.builder(
      shrinkWrap: true,
      itemCount: contas.length,
      itemBuilder: (context, indice) {
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowConta(contas[indice], contas),
                ),
              ).then((value) {
                setState(() {});
              });
            },
            title: Text(contas[indice].mes),
            subtitle: Text(
              'Contador: ' + contas[indice].numeroConta,
            ),
          ),
        );
      },
    );
  }
}

class ListaContas extends StatefulWidget {
  double taxa = 1;

  @override
  State<StatefulWidget> createState() {
    //taxaPreferences().then((value) => {taxa = value});

    return ListaContasState();
  }
}
