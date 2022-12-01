import 'package:breaking_bapp/presentation/common/user_list_item.dart';
import 'package:breaking_bapp/remote_api.dart';
import 'package:breaking_bapp/user_summary.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserListView extends StatefulWidget {
  @override
  _UserListViewState createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  static const _pageSize = 20;

  final PagingController<int, UserSummary> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await RemoteApi.getUserList(pageKey, _pageSize);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, UserSummary>.separated(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<UserSummary>(
            animateTransitions: true,
            itemBuilder: (context, item, index) => UserListItem(
              user: item,
            ),
          ),
          separatorBuilder: (context, index) => const Divider(),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
