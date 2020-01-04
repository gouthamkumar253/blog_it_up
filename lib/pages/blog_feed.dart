import 'package:blogitup/pages/blog_comments.dart';
import 'package:blogitup/pages/new_blog.dart';
import 'package:blogitup/shared_preferences/shared_pref.dart';
import 'package:blogitup/utils/logout.dart';
import 'package:blogitup/utils/no_results.dart';
import 'package:blogitup/utils/page_route.dart';
import 'package:blogitup/utils/write_blog_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pk_skeleton/pk_skeleton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

class UsersList extends StatefulWidget {
  const UsersList({this.callback});

  final VoidCallback callback;

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  String username;

  Future<void> initializeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final PreferencesClient preferencesClient = PreferencesClient(prefs: prefs);
    setState(() {
      username = preferencesClient.getUserName();
      print('Username from shared preference $username');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Feed'),
        actions: <Widget>[
          IconButton(
            icon: Icon(MyFlutterApp.logout),
            color: Colors.white,
            onPressed: () {
              widget.callback();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('blogs')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      child: Card(
                        elevation: 2,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                items[index].data['blog_title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(
                                items[index].data['blog_content'],
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              trailing: Container(
                                width: 70,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  image: DecorationImage(
                                    image: const AssetImage(
                                      'assets/images/blog_image.png',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  items[index]
                                      .data['author']
                                      .toString()
                                      .substring(0, 1),
                                ),
                              ),
                              title: Text(
                                toBeginningOfSentenceCase(
                                  items[index]
                                      .data['author']
                                      .toString()
                                      .split('@')
                                      .first,
                                ),
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              subtitle: Text(
                                timeago
                                    .format(items[index]
                                        .data['created_at']
                                        .toDate())
                                    .toString(),
                              ),
                              trailing: Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2, bottom: 12, left: 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder<Widget>(
                                        opaque: false,
                                        pageBuilder:
                                            (BuildContext context, __, _) =>
                                                BlogComments(
                                          blogId: items[index].documentID,
                                        ),
                                      ),
                                    );
//                                    PageRoutes().cupertinoNavigation(
//                                      BlogComments(
//                                        blogId: items[index].documentID,
//                                      ),
//                                      context,
//                                    );
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        const Text(
                                          'View all comments ',
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return NoResults(
                message: 'No blogs available. Start Writing one',
                height: MediaQuery.of(context).size.height,
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          WriteBlog.edit,
          color: Colors.white,
        ),
        onPressed: () {
          PageRoutes().cupertinoNavigation(NewBlog(), context);
        },
      ),
    );
  }
}
