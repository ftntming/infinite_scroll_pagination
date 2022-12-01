import 'package:breaking_bapp/user_summary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserGridItem extends StatelessWidget {
  const UserGridItem({
    required this.user,
    Key? key,
  }) : super(key: key);
  final UserSummary user;

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: user.pictureUrl,
      );
}
