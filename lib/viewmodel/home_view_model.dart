import 'package:flutter/cupertino.dart';
import 'package:toopgames_client/api.dart';
import 'package:toopgames_client/model/base_response.dart';
import 'package:toopgames_client/model/match_model.dart';
import 'package:toopgames_client/model/stats_model.dart';
import 'package:toopgames_client/util/request_state.dart';
import 'package:toopgames_client/util/shared_preferences.dart';
import 'package:toopgames_client/viewmodel/base.dart';

class HomeViewModel extends BaseViewModel {
  ValueNotifier<RequestState> matchesRequestState = ValueNotifier(RequestState.NOT_SEND);
  ValueNotifier<ListedBaseResponse<MatchModel?>?> matchesResponse = ValueNotifier(null);
  ValueNotifier<RequestState> topsRequestState = ValueNotifier(RequestState.NOT_SEND);
  ValueNotifier<ListedBaseResponse<StatsModel?>?> topsResponse = ValueNotifier(null);
  ValueNotifier<RequestState> statsRequestState = ValueNotifier(RequestState.NOT_SEND);
  ValueNotifier<BaseResponse<StatsModel?>?> statsResponse = ValueNotifier(null);

  void getUserMatches() async {
    matchesRequestState.value = RequestState.SENDING;
    notifyListeners();
    var user = await AppSharedPreferences.getUser();
    await handleApiRequests(
        ApiRequests.getUserMatches(user!.id!, count: 30), matchesResponse, matchesRequestState);
  }

  void getUserStats() async {
    matchesRequestState.value = RequestState.SENDING;
    notifyListeners();
    var user = await AppSharedPreferences.getUser();
    await handleApiRequests(ApiRequests.getUserStats(user!.id!), statsResponse, statsRequestState);
  }

  void getTopUsers() async {
    await handleApiRequests(ApiRequests.getTopStats(), topsResponse, topsRequestState);
  }
}
