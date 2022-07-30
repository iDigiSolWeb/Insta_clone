import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_clone/screens/feed/feed_screen.dart';
import 'package:insta_clone/screens/profile/profile_screen.dart';
import 'package:insta_clone/screens/search/search_screen.dart';

import '../screens/add_post/add_post.dart';

const webScreenSize = 600;

String uid = '';
List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(
    child: Text('Notification'),
  ),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
