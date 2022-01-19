import 'package:flutter/foundation.dart';
import 'package:chaseapp/src/shared/enums/view_state.dart';

class BaseModel with ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  set state(ViewState viewState) {
    if (kDebugMode) {
      print('State:$viewState');
    }
    _state = viewState;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
