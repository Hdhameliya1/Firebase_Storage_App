import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FiresStoreScreen extends StatefulWidget {
  const FiresStoreScreen({Key? key}) : super(key: key);

  @override
  State<FiresStoreScreen> createState() => _FiresStoreScreenState();
}

class _FiresStoreScreenState extends State<FiresStoreScreen> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker image = ImagePicker();
  var fileName = "assets/images/beg.png";
  XFile? picture;
  String dataUrl = 'data:text/plain;base64,SGVsbG8sIFdvcmxkIQ==';

  setImage() async {
    try {
      Reference ref = storage.ref();
      Reference imageRef = ref.child("image/${picture!.name}");
      File image = File(picture!.path);
      await imageRef.putFile(image);
      String url = await imageRef.getDownloadURL();
      debugPrint("FileUrl ---> $url");
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  downloadImage() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = "${appDocDir.absolute}assets/images/Media.jpg";
      File file = File(filePath);

      Reference ref = storage.ref();
      Reference downloadRef = ref.child("image/${picture!.name}");
      String url = await downloadRef.getDownloadURL();
      debugPrint("Downloadurl ---->>> $url");

      await downloadRef.writeToFile(file);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  deleteImage() async {
    try {
      Reference ref = storage.ref();
      Reference deleteFile = ref.child("image/${picture!.name}");
      await deleteFile.delete();
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  dataImage() async {
    try {
      ByteData bytes = await rootBundle.load(fileName);
      Reference ref = storage.ref();
      Reference dataString = ref.child(fileName);
      Uint8List rawData =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      await dataString.putData(rawData);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  stringImage() async {
    try {
      Reference ref = storage.ref();
      Reference stringRef = ref.child("image/${picture!.name}");
      // File image = File(picture!.path);
      await stringRef.putString(dataUrl, format: PutStringFormat.dataUrl);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage Image"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              picture = await image.pickImage(source: ImageSource.camera);
              setState(() {});
            },
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                color: Color(0xbbffffff),
              ),
              child: picture != null
                  ? Image.file(
                      File(picture!.path),
                    )
                  : const Icon(Icons.add, size: 90),
            ),
          ),
          ElevatedButton(
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                setImage();
              },
              child: const Text('Press for Images')),
          ElevatedButton(
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                stringImage();
              },
              child: const Text('Press for String')),
          ElevatedButton(
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                dataImage();
              },
              child: const Text('Press for Data')),
          ElevatedButton(
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                downloadImage();
              },
              child: const Text('Press for Download')),
          ElevatedButton(
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
              onPressed: () {
                deleteImage();
              },
              child: const Text('Press for Delete')),
        ],
      ),
    );
  }
}
