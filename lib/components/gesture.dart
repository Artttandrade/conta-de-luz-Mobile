import 'package:flutter/cupertino.dart';

void unfocusInput(BuildContext context) {
  FocusScopeNode node = FocusScope.of(context);

  if (node.hasPrimaryFocus != null) {
    node.unfocus();
  }
}
