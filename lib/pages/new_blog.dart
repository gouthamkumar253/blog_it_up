
import 'package:blogitup/models/blog_model.dart';
import 'package:blogitup/shared_preferences/shared_pref.dart';
import 'package:blogitup/utils/app_loader.dart';
import 'package:blogitup/utils/toast_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewBlog extends StatefulWidget {
  @override
  _NewBlogState createState() => _NewBlogState();
}

class _NewBlogState extends State<NewBlog> {
  final TextEditingController _blogTitleController = TextEditingController();
  final TextEditingController _blogContentController = TextEditingController();

  void postBlog(BlogPost post) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final PreferencesClient preferencesClient = PreferencesClient(prefs: prefs);
    post.author = preferencesClient.getUserName();
    final DocumentReference documentReference = Firestore.instance
        .collection('blogs')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((Transaction transaction) async {
      await transaction.set(
        documentReference,
        post.toJson(),
      );
    }).then((_) {
      ToastMessage().showToast('Blog posted successfully', 3, context);
      Navigator.of(context).pop();
      Navigator.of(context).pop();

    }).catchError((dynamic error) {
      ToastMessage().showToast('Something went wrong. Try again later', 3, context);
    });
  }

//  void uploadFile() async {
//    final File result = await ImagePicker.pickImage(
//      source: ImageSource.gallery,
//      imageQuality: 80,
//      maxHeight: 400,
//      maxWidth: 400,
//    );
//
//    if (result != null) {
//
//      final StorageReference storageRef =
//      FirebaseStorage.instance.ref().child('blog_images/1.jpg');
//
//      final StorageUploadTask uploadTask = storageRef.putFile(
//        result,
//        StorageMetadata(
//          contentType: 'image/jpg',
//        ),
//      );
//      final StorageTaskSnapshot download = await uploadTask.onComplete;
//
//      final String url = await download.ref.getDownloadURL();
//
//
//      final DocumentReference documentReference = Firestore.instance
//          .collection('users')
//          .document(chatId)
//          .collection('messages').document(DateTime.now().millisecondsSinceEpoch.toString());
//      Firestore.instance.runTransaction((Transaction transaction) async {
//        await transaction.set(
//          documentReference,
//          message.toJson(),
//        );
//      });
//    }
//  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Blog'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Blog title',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  maxLength: 50,
                  controller: _blogTitleController,
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
                    hintText: 'Add your title here',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Blog Content',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  maxLength: 200,
                  controller: _blogContentController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
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
                    hintText: 'Add your content here',
                    hintStyle: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder<Widget>(
                            opaque: false,
                            pageBuilder: (BuildContext context, __, _) =>
                                AppLoader(),
                          ),
                        );
                        final BlogPost post = BlogPost();
                        post.blogTitle = _blogTitleController.text;
                        post.blogContent = _blogContentController.text;
                        post.likes = 0;
                        postBlog(post);
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
