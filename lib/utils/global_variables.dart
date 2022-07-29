import 'package:flutter/cupertino.dart';
import 'package:insta_clone/screens/feed/feed_screen.dart';
import 'package:insta_clone/screens/search/search_screen.dart';

import '../screens/add_post/add_post.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(
    child: Text('Notification'),
  ),
  Center(
    child: Text('Profile'),
  ),
];
