import "dart:io";

import "package:blog_app/services/crud.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import "package:random_string/random_string.dart";

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String authorName = "", title = "", desc = "";

  Type selectedimage = File;
  bool _isLoading = false;
  CrudMethods crudMethods = CrudMethods();

  /* Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = image;
    });
  }*/

  /*pickImage(ImageSource src) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: src);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    print("No image selected");
  }*/

  Future getImageFromGallery(BuildContext context) async {
    await ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        // _cropImage(image, context);
      }
    });
  }
  /*  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
  }*/

  uploadBlog() async {
    if (selectedimage != null) {
      setState(() {
        _isLoading = true;
      });
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");

      final UploadTask task = firebaseStorageRef.putBlob(selectedimage);

      var downloadUrl = await (await task.whenComplete(() => 'File Uploaded'))
          .ref
          .getDownloadURL();
      print("this is url $downloadUrl");

      Map<String, String> blogMap = {
        "imgUrl": downloadUrl,
        "authorName": authorName,
        "title": title,
        "desc": desc,
      };
      crudMethods.addData(blogMap).then((result) {
        Navigator.pop(context);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Flutter",
                style: TextStyle(fontSize: 22),
              ),
              Text("Blog", style: TextStyle(fontSize: 22, color: Colors.blue))
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                uploadBlog();
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.file_upload)),
            )
          ]),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: selectedimage != null
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(selectedimage as File,
                                    fit: BoxFit.cover),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(horizontal: 16),
                              height: 150,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6)),
                              width: MediaQuery.of(context).size.width,
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.black45,
                              ),
                            )),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          decoration: InputDecoration(hintText: "Author Name"),
                          onChanged: (val) {
                            authorName = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Title"),
                          onChanged: (val) {
                            title = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(hintText: "Desc"),
                          onChanged: (val) {
                            desc = val;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
