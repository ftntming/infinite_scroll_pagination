import 'package:breaking_bapp/presentation/common/user_list_item.dart';
import 'package:breaking_bapp/presentation/common/user_search_input_sliver.dart';
import 'package:breaking_bapp/remote_api.dart';
import 'package:breaking_bapp/user_summary.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserSliverList extends StatefulWidget {
  @override
  _UserSliverListState createState() => _UserSliverListState();
}

class _UserSliverListState extends State<UserSliverList> {
  static const _pageSize = 17;

  final PagingController<int, UserSummary> _pagingController =
      PagingController(firstPageKey: 0);

  String? _searchTerm;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });

    super.initState();
  }

  Future<void> _fetchPage(pageKey) async {
    try {
      final newItems = await RemoteApi.getUserList(
        pageKey,
        _pageSize,
        searchTerm: _searchTerm,
      );

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
  Widget build(BuildContext context) => CustomScrollView(
        slivers: <Widget>[
          UserSearchInputSliver(
            onChanged: (searchTerm) => _updateSearchTerm(searchTerm),
          ),
          PagedSliverList<int, UserSummary>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<UserSummary>(
              animateTransitions: true,
              itemBuilder: (context, item, index) => UserListItem(
                user: item,
              ),
            ),
          ),
        ],
      );

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
