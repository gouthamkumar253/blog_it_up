import 'package:blogitup/models/comments_model.dart';
import 'package:blogitup/shared_preferences/shared_pref.dart';
import 'package:blogitup/utils/no_results.dart';
import 'package:blogitup/utils/toast_display.dart';
import 'package:blogitup/utils/write_blog_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class BlogComments extends StatefulWidget {
  const BlogComments({Key key, this.blogId}) : super(key: key);

  final String blogId;

  @override
  _BlogCommentsState createState() => _BlogCommentsState();
}

class _BlogCommentsState extends State<BlogComments> {
  void postComment(CommentPost post) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final PreferencesClient preferencesClient = PreferencesClient(prefs: prefs);
    post.author = preferencesClient.getUserName();
    final DocumentReference documentReference = Firestore.instance
        .collection('blogs')
        .document(widget.blogId)
        .collection('comments')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.set(
        documentReference,
        post.toJson(),
      );
    }).then((_) {
      ToastMessage().showToast('Comment posted successfully', 3, context);
      Navigator.of(context).pop();
    }).catchError((dynamic error) {
      ToastMessage()
          .showToast('Something went wrong. Try again later', 3, context);
    });
  }

  void postReply(CommentPost post, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final PreferencesClient preferencesClient = PreferencesClient(prefs: prefs);
    post.author = preferencesClient.getUserName();
    final DocumentReference documentReference = Firestore.instance
        .collection('blogs')
        .document(widget.blogId)
        .collection('comments')
        .document(id)
        .collection('reply')
        .document(
          DateTime.now().millisecondsSinceEpoch.toString(),
        );

    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.set(
        documentReference,
        post.toJson(),
      );
    }).then((_) {
      ToastMessage().showToast('Reply posted successfully', 3, context);
      Navigator.of(context).pop();
    }).catchError((dynamic error) {
      ToastMessage()
          .showToast('Something went wrong. Try again later', 3, context);
    });
  }

  void showBottomModalSheet(BuildContext context, String title, int mode,
      {String id = ''}) {
    TextEditingController _commentController = TextEditingController();
    showModalBottomSheet<dynamic>(
      context: context,
      builder: (BuildContext buildContext) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  onTap: () => Navigator.pop(context),
                  title: Text(title),
                  trailing: const Icon(Icons.clear),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    maxLength: 50,
                    controller: _commentController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: const OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        borderSide: const BorderSide(
                          color: Color(0xFFF3F1F1),
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(
                        20,
                      ),
                      fillColor: const Color(0xFFF3F1F1),
                      filled: true,
                      hintText: 'Enter the comment',
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          final CommentPost postData = CommentPost();
                          postData.comment = _commentController.text;
                          postData.master = mode == 1 ? true : false;
                          mode == 1
                              ? postComment(postData)
                              : postReply(postData, id);
                        },
                        child: Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(500),
                          ),
                          child: const Center(
                            child: Text(
                              'Post',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('blogs')
              .document(widget.blogId)
              .collection('comments')
              .orderBy('created_at', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return PKCardListSkeleton(
                isCircularImage: true,
                isBottomLinesActive: true,
                length: 10,
              );
            } else {
              final List<DocumentSnapshot> items = snapshot.data.documents;
              if (items.isNotEmpty) {
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              child: Text(
                                items[index]
                                    .data['author']
                                    .toString()
                                    .substring(0, 1),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF0F2F5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          title: Text(
                                            items[index]
                                                .data['author']
                                                .toString()
                                                .split('@')
                                                .first,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Text(
                                            items[index].data['comment'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          timeago
                                              .format(items[index]
                                                  .data['created_at']
                                                  .toDate())
                                              .toString(),
                                          style: const TextStyle(
                                              color: Color(0xFF929498)),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showBottomModalSheet(
                                              context,
                                              'Reply to comment',
                                              2,
                                              id: items[index].documentID,
                                            );
                                          },
                                          child: const Text(
                                            'Reply',
                                            style: const TextStyle(
                                              color: Color(0xFF929498),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection('blogs')
                                          .document(widget.blogId)
                                          .collection('comments')
                                          .document(items[index].documentID)
                                          .collection('reply')
                                          .orderBy('created_at',
                                              descending: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container(
                                            height: 300,
                                            child: PKCardListSkeleton(
                                              isCircularImage: true,
                                              isBottomLinesActive: true,
                                              length: 2,
                                            ),
                                          );
                                        } else {
                                          final List<DocumentSnapshot> items =
                                              snapshot.data.documents;
                                          if (items.isNotEmpty) {
                                            return Container(
                                              height: 120.0 * items.length,
                                              child: ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: items.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 8,
                                                        horizontal: 12,
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          CircleAvatar(
                                                            child: Text(
                                                              items[index]
                                                                  .data[
                                                                      'author']
                                                                  .toString()
                                                                  .substring(
                                                                      0, 1),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        const Color(
                                                                      0xffF0F2F5,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                      20,
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      ListTile(
                                                                        title:
                                                                            Text(
                                                                          items[index]
                                                                              .data['author']
                                                                              .toString()
                                                                              .split('@')
                                                                              .first,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize:
                                                                                18,
                                                                          ),
                                                                        ),
                                                                        subtitle:
                                                                            Text(
                                                                          items[index]
                                                                              .data['comment'],
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                14,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical: 6,
                                                                  ),
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        timeago
                                                                            .format(items[index].data['created_at'].toDate())
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Color(0xFF929498)),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
//                                                                        print(items[index].reference.parent().parent().documentID);
                                                                          showBottomModalSheet(
                                                                            context,
                                                                            'Reply to comment',
                                                                            2,
                                                                            id: items[index].reference.parent().parent().documentID,
                                                                          );
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          'Reply',
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Color(0xFF929498),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return NoResults(
                  message: 'Be the first to write a comment',
                  height: MediaQuery.of(context).size.height,
                );
              }
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          WriteBlog.edit,
          color: Colors.white,
        ),
        onPressed: () {
          showBottomModalSheet(context, 'New Comment', 1);
        },
      ),
    );
  }
}
