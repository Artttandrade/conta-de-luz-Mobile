import 'package:conta_de_luz/components/gesture.dart';
import 'package:conta_de_luz/databases/taxa_database.dart';
import 'package:conta_de_luz/models/Taxa.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormularioTaxa extends StatefulWidget {
  double taxaAtual;
  late Future<double> taxaAt;
  late TextEditingController taxaController = TextEditingController();

  FormularioTaxa(this.taxaAtual);

  @override
  _FormularioTaxaState createState() {
    NumberFormat format = NumberFormat.simpleCurrency(locale: 'pt_BR');
    String valor = format.format(this.taxaAtual);
    taxaController.text = valor;
    taxaAt = Taxa.getTaxa();
    print(taxaAt.toString() + '?');

    return _FormularioTaxaState();
  }
}

class _FormularioTaxaState extends State<FormularioTaxa> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusInput(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Taxa da Conta de Luz'),
        ),
        body: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 50))
                .then((value) => (TaxaDatabase().getTaxa())),
            builder: (context, snapshot) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Taxa da Conta de luz atualmente:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      controller: widget.taxaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 16),
                          labelText: 'Taxa'),
                      inputFormatters: [
                        CurrencyTextInputFormatter(symbol: 'R\$', locale: 'PT'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            onPressed: () {
                              String novaTaxa = widget.taxaController.text
                                  .toString()
                                  .split('\$')[1];

                              novaTaxa = novaTaxa.replaceRange(0, 1, '');
                              novaTaxa = novaTaxa.replaceAll(',', '.');
                              //print("?" + novaTaxa);
                              Taxa.setTaxa(double.parse(novaTaxa));
                              Navigator.pop(context);
                            },
                            child: Text('Salvar')),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
