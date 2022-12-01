import 'dart:async';

import 'package:breaking_bapp/presentation/search_grid_bloc/user_sliver_grid_states.dart';
import 'package:breaking_bapp/remote_api.dart';
import 'package:rxdart/rxdart.dart';

class UserSliverGridBloc {
  UserSliverGridBloc() {
    _onPageRequest.stream
        .flatMap(_fetchUserSummaryList)
        .listen(_onNewListingStateController.add)
        .addTo(_subscriptions);

    _onSearchInputChangedSubject.stream
        .flatMap((_) => _resetSearch())
        .listen(_onNewListingStateController.add)
        .addTo(_subscriptions);
  }

  static const _pageSize = 20;

  final _subscriptions = CompositeSubscription();

  final _onNewListingStateController = BehaviorSubject<UserListingState>.seeded(
    UserListingState(),
  );

  Stream<UserListingState> get onNewListingState =>
      _onNewListingStateController.stream;

  final _onPageRequest = StreamController<int>();

  Sink<int> get onPageRequestSink => _onPageRequest.sink;

  final _onSearchInputChangedSubject = BehaviorSubject<String?>.seeded(null);

  Sink<String?> get onSearchInputChangedSink =>
      _onSearchInputChangedSubject.sink;

  String? get _searchInputValue => _onSearchInputChangedSubject.value;

  Stream<UserListingState> _resetSearch() async* {
    yield UserListingState();
    yield* _fetchUserSummaryList(0);
  }

  Stream<UserListingState> _fetchUserSummaryList(int pageKey) async* {
    final lastListingState = _onNewListingStateController.value;
    try {
      final newItems = await RemoteApi.getUserList(
        pageKey,
        _pageSize,
        searchTerm: _searchInputValue,
      );
      final isLastPage = newItems.length < _pageSize;
      final nextPageKey = isLastPage ? null : pageKey + newItems.length;
      yield UserListingState(
        error: null,
        nextPageKey: nextPageKey,
        itemList: [...lastListingState.itemList ?? [], ...newItems],
      );
    } catch (e) {
      yield UserListingState(
        error: e,
        nextPageKey: lastListingState.nextPageKey,
        itemList: lastListingState.itemList,
      );
    }
  }

  void dispose() {
    _onSearchInputChangedSubject.close();
    _onNewListingStateController.close();
    _subscriptions.dispose();
    _onPageRequest.close();
  }
}
