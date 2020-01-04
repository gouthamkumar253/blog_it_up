//import 'package:flutter/material.dart';
//
//class BlogCommentReplies extends StatefulWidget {
//  @override
//  _BlogCommentRepliesState createState() => _BlogCommentRepliesState();
//}
//
//class _BlogCommentRepliesState extends State<BlogCommentReplies> {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance
//            .collection('blogs')
//            .document(widget.blogId)
//            .collection('comments')
//            .orderBy('created_at', descending: true)
//            .snapshots(),
//        builder:
//            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//          if (!snapshot.hasData) {
//            return PKCardListSkeleton(
//              isCircularImage: true,
//              isBottomLinesActive: true,
//              length: 10,
//            );
//          } else {
//            final List<DocumentSnapshot> items = snapshot.data.documents;
//            if (items.isNotEmpty) {
//              return ListView.builder(
//                  itemCount: items.length,
//                  itemBuilder: (BuildContext context, int index) {
//                    return Padding(
//                      padding: const EdgeInsets.symmetric(
//                        vertical: 8,
//                        horizontal: 12,
//                      ),
//                      child: Row(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          CircleAvatar(
//                            child: Text(
//                              items[index]
//                                  .data['author']
//                                  .toString()
//                                  .substring(0, 1),
//                            ),
//                          ),
//                          const SizedBox(
//                            width: 10,
//                          ),
//                          Expanded(
//                            child: Column(
//                              children: <Widget>[
//                                Container(
//                                  decoration: BoxDecoration(
//                                    color: const Color(0xffF0F2F5),
//                                    borderRadius: BorderRadius.circular(20),
//                                  ),
//                                  child: Column(
//                                    children: <Widget>[
//                                      ListTile(
//                                        title: Text(
//                                          items[index]
//                                              .data['author']
//                                              .toString()
//                                              .split('@')
//                                              .first,
//                                          style: TextStyle(
//                                            fontWeight: FontWeight.w500,
//                                            fontSize: 18,
//                                          ),
//                                        ),
//                                        subtitle: Text(
//                                          items[index].data['comment'],
//                                          style: const TextStyle(
//                                            color: Colors.black,
//                                            fontSize: 14,
//                                          ),
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.symmetric(
//                                    horizontal: 10,
//                                    vertical: 6,
//                                  ),
//                                  child: Row(
//                                    children: <Widget>[
//                                      Text(
//                                        timeago
//                                            .format(items[index]
//                                            .data['created_at']
//                                            .toDate())
//                                            .toString(),
//                                        style: const TextStyle(
//                                            color: Color(0xFF929498)),
//                                      ),
//                                      const SizedBox(
//                                        width: 10,
//                                      ),
//                                      InkWell(
//                                        onTap: () {
//                                          showBottomModalSheet(
//                                            context,
//                                            'Reply to comment',
//                                            2,
//                                            id: items[index].documentID,
//                                          );
//                                        },
//                                        child: const Text(
//                                          'Reply',
//                                          style: const TextStyle(
//                                            color: Color(0xFF929498),
//                                          ),
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ],
//                      ),
//                    );
//                  });
//            } else {
//              return NoResults(
//                message: 'Be the first to write a comment',
//                height: MediaQuery.of(context).size.height,
//              );
//            }
//          }
//        },
//      ),
//    );
//  }
//}
