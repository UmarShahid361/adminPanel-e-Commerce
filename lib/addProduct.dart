import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adde_commerce/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  PlatformFile? pickedFile;
  firebase_storage.UploadTask? uploadTask;
  List<PlatformFile> files = [];
  List<List<PlatformFile>> allImages = [];
  List<List<String>> uploadedImages = [];
  String dateTime = DateTime.now().millisecondsSinceEpoch.toString();

  Future selectFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (pickedFile == null) return;

    openFiles(pickedFile.files);
  }

  final titleController = TextEditingController();
  final discountedController = TextEditingController();
  final priceController = TextEditingController();
  final offController = TextEditingController();
  final descriptionController = TextEditingController();
  bool loading = false;

  String? mainCategory;
  String? mainCategoryId;


  String? subCategory;
  late Future<QuerySnapshot<Map<String, dynamic>>> mainCategoryFuture;
  late Future<QuerySnapshot<Map<String, dynamic>>> subCategoryFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mainCategoryFuture = FirebaseFirestore.instance.collection("Single Piece").get();

  }

  getSubCategories(){
    subCategoryFuture = FirebaseFirestore.instance.collection("Single Piece").doc(mainCategoryId).collection("subCategory").get();
  }
  @override
  Widget build(BuildContext context) {
    // print(files.isEmpty);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (allImages.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...allImages.asMap().entries.map((e1) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...e1.value.asMap().entries.map((e) {
                              return Stack(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          right: 20, bottom: 20),
                                      width: 80,
                                      height: 100,
                                      child: Image.file(
                                        File(e.value.path!),
                                        width: double.infinity,
                                        fit: BoxFit.scaleDown,
                                      )),
                                  Positioned(
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        allImages[e1.key].removeAt(e.key);
                                        if (allImages[e1.key].isEmpty) {
                                          allImages.removeAt(e1.key);
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 25,
                                        width: 25,
                                        decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: const Center(
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    selectFile();
                  },
                  child: const Text(
                    'Select Image',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  labelText: 'Product Name',
                ),
                controller: titleController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  labelText: 'Discounted Price',
                ),
                controller: discountedController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  labelText: 'Price',
                ),
                controller: priceController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  labelText: 'OFF%',
                ),
                controller: offController,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 9,
                minLines: 1,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  labelText: 'Description',
                ),
                controller: descriptionController,
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: mainCategoryFuture,
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(color: Colors.purple,));
                  }
                  if(snapshot.hasError){
                    return Center(child: Text(snapshot.error.toString()),);
                  }
                  if(snapshot.connectionState == ConnectionState.done && snapshot.data!.docs.isEmpty){
                    return Center(child: Text("No Sub Categories found"),);
                  }

                  return Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.deepPurple),
                        iconSize: 36,
                        isExpanded: true,
                        value: mainCategory,
                        items: snapshot.data!.docs.map((e) => buildMenuItem(e.data()['category'], e.id),).toList(),
                        onChanged: (value) => setState(
                              () {
                                getSubCategories();
                                print(mainCategoryId);
                                subCategory = null;
                                mainCategory = value;
                          },
                        ),
                      ),
                    ),
                  );

                },
              ),

              const SizedBox(height: 20,),
              if(mainCategory != null)

                FutureBuilder(
                  future: subCategoryFuture,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(color: Colors.purple,));
                    }
                    if(snapshot.hasError){
                      return Center(child: Text(snapshot.error.toString()),);
                    }
                    if(snapshot.connectionState == ConnectionState.done && snapshot.data!.docs.isEmpty){
                      return Center(child: Text("No Main Categories found"),);
                    }

                    return Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Colors.deepPurple),
                          iconSize: 36,
                          isExpanded: true,
                          value: subCategory,
                          items: snapshot.data!.docs.map((e) => buildMenuItem(e.data()['subCategoryName'], e.id),).toList(),
                          onChanged: (value) {
                            setState(() {
                              subCategory = value;
                            });
                          }
                        ),
                      ),
                    );

                  },
                ),
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  print(allImages);
                  String id = '';
                  await Future.wait(allImages
                      .asMap()
                      .entries
                      .map((e) => uploadFiles(e.value, dateTime).then((value) {
                            List<String> urls = [];
                            urls.addAll(value);
                            uploadedImages.add(urls);
                          }))).then((value) {
                    List<String> url1 = [];
                    List<String> allImagesURLs = [];
                    for (int i = 0; i < uploadedImages.length; i++) {
                      url1.add(uploadedImages[i][0].toString());
                    }
                    for (int i = 0; i < uploadedImages.length; i++) {
                      for (int j = 0; j < uploadedImages[i].length; j++) {
                        allImagesURLs.add(uploadedImages[i][j]);
                      }
                    }
                    print(url1);
                    print(allImagesURLs);
                    FirebaseFirestore.instance.collection('Products').add(
                      {
                        'title': titleController.text.toString(),
                        'price': priceController.text.toString(),
                        'discountedPrice': discountedController.text.toString(),
                        'off': offController.text.toString(),
                        'description': descriptionController.text.toString(),
                        'category': mainCategory,
                        'subCategory' : subCategory,
                        'imageURL': url1,
                      },
                    ).then((value) async {
                      id = value.id;
                      Utils().toastMessage('Product Added Successfully');
                      Utils().toastMessage("Image Uploaded Successfully!");
                      await Future.wait(uploadedImages.map((e) {
                       return FirebaseFirestore.instance
                            .collection('Products')
                            .doc(id)
                            .collection("variants")
                            .doc()
                            .set({
                          'imageURLs': e,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      })).then((value) {
                        titleController.clear();
                        priceController.clear();
                        discountedController.clear();
                        offController.clear();
                        descriptionController.clear();
                      });

                    });
                  });


                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 50,
                  child: Center(
                    child: loading
                        ? const CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          )
                        : const Text('Add Product'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  openFiles(List<PlatformFile> file) async {
    setState(() {
      allImages.add(file);
    });
  }

  Future<List<String>> uploadFiles(
      List<PlatformFile>? _images, String dateTime) async {
    print(_images!.length);
    print(_images);
    var imageUrls = await Future.wait(
        _images!.map((_image) => uploadFile(_image, dateTime)));
    print(imageUrls);
    return imageUrls;
  }

  Future<String> uploadFile(
      PlatformFile _image, String timeInMilliSeconds) async {
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('productImages/${_image.name + timeInMilliSeconds}');
    if (_image != null) {
      firebase_storage.UploadTask uploadTask = ref.putFile(File(_image.path!),
          firebase_storage.SettableMetadata(contentType: 'image/jpeg'));
      await uploadTask.whenComplete(() => null);
      return await ref.getDownloadURL();
    }
    else {
      return '========== Image in null ==========';
    }
  }
  DropdownMenuItem<String> buildMenuItem(String item, String docId) => DropdownMenuItem(
      value: item,
      onTap: () {
        mainCategoryId = docId;
      },
      child: Text(
        item,
        style: const TextStyle(fontSize: 20),
      ));

}

