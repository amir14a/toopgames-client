import 'package:flutter/cupertino.dart';
import 'package:toopgames_client/api.dart';
import 'package:toopgames_client/model/base_response.dart';
import 'package:toopgames_client/model/user_model.dart';
import 'package:toopgames_client/util/request_state.dart';
import 'package:toopgames_client/viewmodel/base.dart';

class LoginViewModel extends BaseViewModel {
  ValueNotifier<RequestState> requestState = ValueNotifier(RequestState.NOT_SEND);
  ValueNotifier<BaseResponse<UserModel>?> response = ValueNotifier(null);

  void doLogin(String emailOrId, String pass) async {
    await handleApiRequests(ApiRequests.login(emailOrId, pass), response, requestState);
  }
}
