import 'package:flutter/widgets.dart';

class LoadingProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading {
    return _isLoading;
  }

  set isLoading(bool newValue) {
    this._isLoading = newValue;
    notifyListeners();
  }
}
