import 'dart:io';

import 'package:adde_commerce/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddBanner extends StatefulWidget {
  const AddBanner({super.key});

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  // Widget buildProgress() => SteamBuilder<TaskSnapshot>(
  //   stream: uploadTask?.snapshotEvents,
  //   builder: (context, snapshot){
  //     if(snapshot.hasData){
  //       final data = snapshot.data!;
  //       double progress = data.bytesTransferred / data.totalBytes;
  //       return SizedBox(
  //         height: 50,
  //         child: Stack(
  //           fit: StackFit.expand,
  //           children: [
  //             LinearProgressIndicator(value: progress,),
  //             Center(child: Text('${(progress * 100).toStringAsFixed(2)} %')),
  //           ],
  //         ),
  //       );
  //     }
  //   },
  // );

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;

    setState((){
      pickedFile = result.files.first;
    });
  }

  Future uploadFile() async {
    final path = "banner/${pickedFile!.name}";
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Downlad-Link: $urlDownload");
    Utils().toastMessage("Image Uploaded Successfully!");
    FirebaseFirestore.instance.collection("Banners").doc().set(
      {
        "url": urlDownload,
      }
    );

    setState(() {
      pickedFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Banner'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(pickedFile != null)
                Expanded(child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.5,
                    child: Image.file(File(pickedFile!.path!), width: double.infinity, fit: BoxFit.cover,)),),
              const SizedBox(height: 20,),
              Center(
                child: ElevatedButton(onPressed: (){
                  selectFile();
                }, child: const Text('Select Image', style: TextStyle(
                  fontSize: 20,
                ),),),
              ),
              const SizedBox(height: 20,),
              Center(
                child: ElevatedButton(onPressed: (){
                  uploadFile();
                }, child: const Text('Upload Image', style: TextStyle(
                  fontSize: 20,
                ),),),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
