import 'package:flutter/foundation.dart';

import '../services/secure_storage.dart';
import '../views/loading/loading_state.dart';

class LoadingController extends ChangeNotifier {
  LoadingController({
    required this.secureStorageService,
  });

  final SecureStorageService secureStorageService;

  LoadingState _state = LoadingStateInitial();

  LoadingState get state => _state;

  void _changeState(LoadingState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> isUserLogged() async {
    final result = await secureStorageService.readOne(key: "CURRENT_USER");
    if (result != null) {
      _changeState(AuthenticatedUser());
    } else {
      _changeState(UnauthenticatedUser());
    }
  }
}
