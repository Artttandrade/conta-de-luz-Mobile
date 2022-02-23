class Conta {
  int? _id;
  String? _numeroConta;
  String? _valor;
  String? _mes;

  Conta(this._numeroConta);
  Conta.all(this._id, this._numeroConta, this._valor, this._mes);

  get id => this._id;

  set id(value) => this._id;

  get numeroConta => this._numeroConta;

  set numeroConta(value) => this._numeroConta = value;

  get valor => this._valor;

  set valor(value) => this._valor = value;

  get mes => this._mes;

  set mes(value) => this._mes = value;
}
