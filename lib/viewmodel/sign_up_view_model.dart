import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toopgames_client/api.dart';
import 'package:toopgames_client/model/base_response.dart';
import 'package:toopgames_client/model/user_model.dart';
import 'package:toopgames_client/util/request_state.dart';
import 'package:toopgames_client/viewmodel/base.dart';

class SignUpViewModel extends BaseViewModel {
  ValueNotifier<RequestState> requestState = ValueNotifier(RequestState.NOT_SEND);
  ValueNotifier<BaseResponse<UserModel>?> response = ValueNotifier(null);

  void doSignUp(
    String email,
    String pass,
    String? name,
    String userId,
    XFile? image,
  ) async {
    await handleApiRequests(ApiRequests.signUp(email, pass, name, userId, image), response, requestState);
  }
}
