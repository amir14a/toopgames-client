import 'package:flutter/material.dart';
import 'package:toopgames_client/util/request_state.dart';

class BaseViewModel with ChangeNotifier {
  Future<T?> handleApiRequests<T>(
      Future<T> f, ValueNotifier<T> response, ValueNotifier<RequestState>? requestState) async {
    requestState?.value = RequestState.SENDING;
    notifyListeners();
    try {
      response.value = await f;
      requestState?.value = RequestState.SUCCESS;
      notifyListeners();
      return response.value;
    } catch (e) {
      print(e);
      requestState?.value = RequestState.FAILED;
      notifyListeners();
    }
  }
}
