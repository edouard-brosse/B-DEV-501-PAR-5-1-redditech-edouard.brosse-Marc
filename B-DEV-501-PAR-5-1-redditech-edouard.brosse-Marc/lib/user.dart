import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier, DiagnosticableTreeMixin {
  String _token = '';
  String get token => _token;
  void setToken(String token) {
    this._token = token;
    notifyListeners();
  }
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('token :', this._token));
  }
}
