import 'package:breaking_bapp/user_summary.dart';

class UserListingState {
  UserListingState({
    this.itemList,
    this.error,
    this.nextPageKey = 0,
  });

  final List<UserSummary>? itemList;
  final dynamic error;
  final int? nextPageKey;
}
