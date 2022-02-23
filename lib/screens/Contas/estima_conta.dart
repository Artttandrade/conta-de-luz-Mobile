import 'package:conta_de_luz/components/gesture.dart';
import 'package:conta_de_luz/databases/conta_database.dart';
import 'package:conta_de_luz/databases/taxa_database.dart';
import 'package:conta_de_luz/models/Conta.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class EstimaContaState extends State<EstimaConta> {
  TextEditingController numeroContadorController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController numeroAntigoController = TextEditingController();
  String valor = 'R\$ 0,00';
  String? mes;

  bool flag = true;

  EstimaContaState(this.mes);

  @override
  Widget build(BuildContext context) {
    if (widget.contaAntiga != null) {
      numeroAntigoController.text = widget.contaAntiga!.numeroConta;
    }

    return GestureDetector(
      onTap: () {
        unfocusInput(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calcular Conta'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: numeroAntigoController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Contagem anterior',
                    hintText: '0000001',
                  ),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: numeroContadorController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Número no contador hoje',
                    hintText: '0000001',
                  ),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 16),
                child:
                    Text('Taxa atual: ' + widget.taxa.toString() + ' (Kw/H)'),
              ),
              buttonCalcular(),
              widgetValor(),
            ],
          ),
        ),
      ),
    );
  }

  Container widgetValor() {
    return Container(
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
    );
  }

  ElevatedButton buttonCalcular() {
    return ElevatedButton(
      onPressed: () {
        calculaConta();
      },
      child: Text('Calcular'),
    );
  }

  void calculaConta() {
    int difContador;

    NumberFormat format = NumberFormat.simpleCurrency(locale: 'pt_Br');

    if (widget.contaAntiga != null) {
      difContador = int.parse(numeroContadorController.text) -
          int.parse(widget.contaAntiga!.numeroConta);
      valorController.text = format.format((difContador * widget.taxa));
    } else {
      difContador = int.parse(numeroContadorController.text) -
          int.parse(numeroAntigoController.text);
      valorController.text = format.format((difContador * widget.taxa));
    }
  }
}

class EstimaConta extends StatefulWidget {
  Conta? contaAntiga;
  late double taxa;
  String? mes;
  TextEditingController taxaController = TextEditingController();

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
  late Future<double> taxaBd;

  EstimaConta(this.contaAntiga, this.taxa);

  @override
  State<StatefulWidget> createState() {
    DateTime hoje = DateTime.now();
    this.mes = meses[hoje.month - 1];

    return EstimaContaState(mes);
  }
}
