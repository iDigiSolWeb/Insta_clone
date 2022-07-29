import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/provider/user_provider.dart';
import 'package:insta_clone/screens/add_post/services/firestore_methods.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../widgets/comment_card.dart';
import '../../widgets/loader.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  TextEditingController commentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) {
                return CommentCard(
                  snap: (snapshot.data! as dynamic).docs[index].data(),
                );
              });
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.photoUrl,
                  ),
                  radius: 18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 8),
                    child: TextField(
                      controller: commentsController,
                      decoration: InputDecoration(
                        hintText: 'Comment as ${user.username}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    String res = await FireStoreMethods().postComment(
                        widget.snap['postId'],
                        commentsController.text.trim(),
                        user.uid,
                        user.username,
                        user.photoUrl,
                        context);

                    if (res == 'Successful') {
                      commentsController.clear();
                      setState(() {});
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: const Text(
                      'Post',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
