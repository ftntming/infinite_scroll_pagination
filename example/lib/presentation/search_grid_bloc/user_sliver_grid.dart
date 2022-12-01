import 'dart:async';

import 'package:breaking_bapp/presentation/common/user_search_input_sliver.dart';
import 'package:breaking_bapp/presentation/search_grid_bloc/user_grid_item.dart';
import 'package:breaking_bapp/presentation/search_grid_bloc/user_sliver_grid_bloc.dart';
import 'package:breaking_bapp/user_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserSliverGrid extends StatefulWidget {
  @override
  _UserSliverGridState createState() => _UserSliverGridState();
}

class _UserSliverGridState extends State<UserSliverGrid> {
  final UserSliverGridBloc _bloc = UserSliverGridBloc();
  final PagingController<int, UserSummary> _pagingController =
      PagingController(firstPageKey: 0);
  late StreamSubscription _blocListingStateSubscription;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _bloc.onPageRequestSink.add(pageKey);
    });

    // We could've used StreamBuilder, but that would unnecessarily recreate
    // the entire [PagedSliverGrid] every time the state changes.
    // Instead, handling the subscription ourselves and updating only the
    // _pagingController is more efficient.
    _blocListingStateSubscription =
        _bloc.onNewListingState.listen((listingState) {
      _pagingController.value = PagingState(
        nextPageKey: listingState.nextPageKey,
        error: listingState.error,
        itemList: listingState.itemList,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: <Widget>[
          UserSearchInputSliver(
            onChanged: (searchTerm) => _bloc.onSearchInputChangedSink.add(
              searchTerm,
            ),
          ),
          PagedSliverGrid<int, UserSummary>(
            pagingController: _pagingController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 100 / 150,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
            ),
            builderDelegate: PagedChildBuilderDelegate<UserSummary>(
              itemBuilder: (context, item, index) => UserGridItem(
                user: item,
              ),
            ),
          ),
        ],
      );

  @override
  void dispose() {
    _pagingController.dispose();
    _blocListingStateSubscription.cancel();
    _bloc.dispose();
    super.dispose();
  }
}
