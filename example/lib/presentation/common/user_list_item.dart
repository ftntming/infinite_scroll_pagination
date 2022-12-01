import 'package:breaking_bapp/user_summary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// List item representing a single User with its photo and name.
class UserListItem extends StatelessWidget {
  const UserListItem({
    required this.user,
    Key? key,
  }) : super(key: key);

  final UserSummary user;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: CachedNetworkImageProvider(user.pictureUrl),
        ),
        title: Text(user.name),
      );
}
