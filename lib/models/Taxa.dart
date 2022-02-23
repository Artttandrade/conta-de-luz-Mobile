import 'package:shared_preferences/shared_preferences.dart';

class Taxa {
  static Future<double> getTaxa() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getDouble('taxa') ?? 1.19);
  }

  static Future<int> setTaxa(double novaTaxa) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('taxa', novaTaxa);
      return 1;
    } catch (e) {
      return 0;
    }
  }

  /*Future<double> taxaPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double taxaPref = (prefs.getDouble('taxa') ?? 1.17);
    return taxaPref;
  }*/

}
