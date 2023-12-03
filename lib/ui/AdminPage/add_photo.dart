import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/main.dart';
import 'package:google_fonts/google_fonts.dart';

const Duration _duration = Duration(milliseconds: 300);

class AddPhotoPage extends StatefulWidget {
  const AddPhotoPage({Key? key}) : super(key: key);

  @override
  State<AddPhotoPage> createState() => _AddPhotoPageState();
}

class _AddPhotoPageState extends State<AddPhotoPage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  var _picked = false;
  var _check = false;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
      _picked = true;
    });
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
      _check = true;
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final title = pickedFile!.name;
    final urlDonwload = await snapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection('eventImage').doc().set({
      'url': urlDonwload,
      'title': title,
    });

    setState(() {
      uploadTask = null;
    });

    Navigator.of(context).pop();
    toastMessage('업로드 완료!');
  }

  void _deleteItemDialog(DocumentSnapshot doc) {
    (Platform.isAndroid)
        ? showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [Text('정말로 삭제하시겠습니까?')],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        _deleteItem(doc);
                        Navigator.of(context).pop();
                      },
                      child: const Text("확인")),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("취소")),
                ],
              );
            })
        : showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [Text('정말로 삭제하시겠습니까?')],
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        _deleteItem(doc);
                        Navigator.of(context).pop();
                      },
                      child: const Text("확인")),
                  CupertinoDialogAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("취소")),
                ],
              );
            });
  }

  void _deleteItem(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('eventImage').doc(doc.id).delete();
    FirebaseStorage.instance.ref('/files').child(doc['title']).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData.fallback(),
        backgroundColor: Colors.white,
        title: Text(
          "배너 사진 관리",
          style: GoogleFonts.doHyeon(
            textStyle: mainStyle,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: selectFile,
            icon: Icon(Icons.add_a_photo),
          ),
          IconButton(onPressed: uploadFile, icon: Icon(Icons.check))
        ],
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          if (pickedFile != null)
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Container(
                    child: Image.file(
                      File(pickedFile!.path!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                      duration: _duration,
                      opacity: _check ? 0.0 : 1.0,
                      child: (Platform.isAndroid)
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  pickedFile = null;
                                });
                              },
                              child: Text("취소"))
                          : CupertinoButton.filled(
                              onPressed: () {
                                setState(() {
                                  pickedFile = null;
                                });
                              },
                              child: Text("취소"))),
                ],
              ),
            ),
          _buildProgress(),
          _buildItemPhoto(),
        ],
      ),
    );
  }

  Widget _buildItemPhoto() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('eventImage').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator.adaptive());
          }
          final documents = snapshot.data!.docs;

          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: documents.map((doc) => _buildItem(doc)).toList(),
          );
        });
  }

  Widget _buildItem(DocumentSnapshot doc) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                imageUrl: doc['url']!,
                fit: BoxFit.fitWidth,
                placeholder: (context, url) => Container(
                  color: Colors.black,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          (Platform.isAndroid)
              ? ElevatedButton(
                  onPressed: () {
                    _deleteItemDialog(doc);
                  },
                  child: Text("위 사진 삭제하기"))
              : CupertinoButton.filled(
                  onPressed: () {
                    _deleteItemDialog(doc);
                  },
                  child: Text("위 사진 삭제하기")),
          Divider()
        ],
      ),
    );
  }

  Widget _buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(
            height: 50,
          );
        }
      });
}
