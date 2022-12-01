import 'package:breaking_bapp/presentation/pull_to_refresh/user_list_view.dart';
import 'package:breaking_bapp/presentation/search_grid_bloc/user_sliver_grid.dart';
import 'package:breaking_bapp/presentation/search_snackbar/user_sliver_list.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  int _selectedBottomNavigationIndex = 0;

  final List<_BottomNavigationItem> _bottomNavigationItems = [
    _BottomNavigationItem(
      label: 'Pull to Refresh',
      iconData: Icons.refresh,
      widgetBuilder: (context) => UserListView(),
    ),
    _BottomNavigationItem(
      label: 'Search/Snackbar',
      iconData: Icons.search,
      widgetBuilder: (context) => UserSliverList(),
    ),
    _BottomNavigationItem(
      label: 'BLoC/Grid/Search',
      iconData: Icons.grid_on,
      widgetBuilder: (context) => UserSliverGrid(),
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedBottomNavigationIndex,
          items: _bottomNavigationItems
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.iconData),
                  label: item.label,
                ),
              )
              .toList(),
          onTap: (newIndex) => setState(
            () => _selectedBottomNavigationIndex = newIndex,
          ),
        ),
        body: IndexedStack(
          index: _selectedBottomNavigationIndex,
          children: _bottomNavigationItems
              .map(
                (item) => item.widgetBuilder(context),
              )
              .toList(),
        ),
      );
}

class _BottomNavigationItem {
  const _BottomNavigationItem({
    required this.label,
    required this.iconData,
    required this.widgetBuilder,
  });

  final String label;
  final IconData iconData;
  final WidgetBuilder widgetBuilder;
}
