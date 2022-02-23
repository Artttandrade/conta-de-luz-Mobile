import 'package:conta_de_luz/components/ContaFunctions.dart';
import 'package:conta_de_luz/components/gesture.dart';
import 'package:conta_de_luz/databases/conta_database.dart';
import 'package:conta_de_luz/models/Conta.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditConta extends StatefulWidget {
  Conta conta;
  TextEditingController contadorController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController mesController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  String? mes;
  String? year;

  List<String> years = [];

  List<String> meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  EditConta(this.conta);

  @override
  _EditContaState createState() {
    //this.mes = conta.mes;
    contadorController.text = conta.numeroConta;
    valorController.text = conta.valor;

    this.mes = conta.mes.toString().split(' de ')[0];
    this.year = conta.mes.toString().split(' de ')[1];
    this.years = getYears();

    print(conta.mes.toString().split(' de ')[1]);

    return _EditContaState();
  }
}

class _EditContaState extends State<EditConta> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        unfocusInput(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mês: ${widget.conta.mes}'),
        ),
        body: Container(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: widget.contadorController,
                  decoration: InputDecoration(labelText: 'Número do Contador'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'Mês:',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      DropdownButton(
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        onChanged: (mesEdit) {
                          setState(() {
                            widget.mes = mesEdit.toString();
                          });
                        },
                        value: widget.mes,
                        items: widget.meses
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          'Ano:',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      DropdownButton(
                        value: widget.year,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        onChanged: (value) {
                          widget.year = value.toString();
                          setState(() {
                            widget.year;
                            print(widget.mes);
                          });
                        },
                        items: widget.years
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: widget.valorController,
                  decoration: InputDecoration(labelText: 'Valor da conta'),
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 20),
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      symbol: 'R\$',
                      locale: 'PT',
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      editarConta(context);
                    },
                    child: Text('Salvar'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void editarConta(BuildContext context) {
    String date = widget.mes.toString() + ' de ' + widget.year.toString();
    Conta contaEditada = Conta.all(widget.conta.id,
        widget.contadorController.text, widget.valorController.text, date);
    //print('id edit: ' + contaEditada.id.toString());
    editConta(contaEditada);
    Navigator.pop(context, contaEditada);
  }
}
