import 'package:conta_de_luz/components/ContaFunctions.dart';
import 'package:conta_de_luz/databases/conta_database.dart';
import 'package:conta_de_luz/models/Conta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class FormularioContaState extends State<FormularioConta> {
  TextEditingController numeroContadorController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController numeroAntigoController = TextEditingController();
  String valor = 'R\$ 0,00';
  String? mes;
  String? year;

  bool flag = true;

  FormularioContaState(this.year, this.mes);

  @override
  Widget build(BuildContext context) {
    if (widget.contaAntiga != null) {
      numeroAntigoController.text = widget.contaAntiga!.numeroConta;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              child: TextField(
                controller: numeroContadorController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: 'Número do contador',
                  hintText: '0000001',
                ),
                style: TextStyle(fontSize: 20),
              ),
            ),
            chooseDate(),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: valorController,
                inputFormatters: [
                  CurrencyTextInputFormatter(symbol: 'R\$', locale: 'PT'),
                ],
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'Valor',
                  hintText: 'Valor: R\$0.00',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    submitFormulario(context);
                  },
                  child: Text('Salvar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container chooseDate() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              'Mês:',
              style: TextStyle(fontSize: 20),
            ),
          ),
          DropdownButton(
            value: this.mes,
            style: TextStyle(fontSize: 20, color: Colors.black),
            onChanged: (value) {
              this.mes = value.toString();
              setState(() {
                this.mes;
                print(this.mes);
              });
            },
            items: widget.meses.map<DropdownMenuItem<String>>((String value) {
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
            value: this.year,
            style: TextStyle(fontSize: 20, color: Colors.black),
            onChanged: (value) {
              this.year = value.toString();
              setState(() {
                this.year;
                print(this.mes);
              });
            },
            items: widget.years.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void submitFormulario(BuildContext context) {
    Conta conta = Conta(numeroContadorController.text);
    print(valorController.text);
    conta.valor = valorController.text;
    conta.mes = this.mes.toString() + ' de ' + this.year.toString();

    saveConta(conta);
    //conta.valor(valorController.text);
    Navigator.pop(context);
  }
}

class FormularioConta extends StatefulWidget {
  Conta? contaAntiga;
  double taxa;
  String? mes;

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

  late List<String> years = [];

  FormularioConta(this.contaAntiga, this.taxa);

  @override
  State<StatefulWidget> createState() {
    DateTime hoje = DateTime.now();
    this.mes = meses[hoje.month - 1];

    // Populate array Years with 4 last years;
    years = getYears();
    debugPrint(years.toString());

    return FormularioContaState(years[0], mes);
  }
}
