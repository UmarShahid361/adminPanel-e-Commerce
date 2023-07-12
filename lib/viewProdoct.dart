import 'package:adde_commerce/updateProduct.dart';
import 'package:adde_commerce/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  final fireStore = FirebaseFirestore.instance.collection('Products').get();

  final String docID =
      FirebaseFirestore.instance.collection('Products').doc().id;

  Future<void> deleteSubcollection(String collectionPath, String documentId,
      String subcollectionPath) async {
    final documentRef =
        FirebaseFirestore.instance.collection(collectionPath).doc(documentId);
    final subcollectionQuerySnapshot =
        await documentRef.collection(subcollectionPath).get();
    final batch = FirebaseFirestore.instance.batch();
    for (var document in subcollectionQuerySnapshot.docs) {
      batch.delete(document.reference);
      // final storageRef = FirebaseStorage.instance.ref().child(filePath);
      // storageRef
      //     .delete()
      //     .then((_) => print('File $filePath deleted successfully!'));
    }
    FirebaseFirestore.instance.collection('Products').doc(documentId).delete();
    return batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Product'),
      ),
      body: FutureBuilder(
        future: fireStore,
        builder: (context, dynamic snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 160,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset:
                              const Offset(2, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateProduct(
                                            id: snapshot.data!.docs[index].id,
                                              title: snapshot.data!.docs[index]
                                                  ['title'],
                                              discountedPrice:
                                                  snapshot.data!.docs[index]
                                                      ['discountedPrice'],
                                              price: snapshot.data!.docs[index]
                                                  ['price'],
                                              off: snapshot.data!.docs[index]
                                                  ['off'],
                                              description:
                                                  snapshot.data!.docs[index]
                                                      ['description'])));
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 22,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Utils().toastMessage(
                                      "Details Deleted Successfully");
                                  String collectionPath = 'Products';
                                  String documentId =
                                      snapshot.data!.docs[index].id;
                                  String subcollectionPath = 'variants';

                                  deleteSubcollection(collectionPath,
                                          documentId, subcollectionPath)
                                      .then((_) => print(
                                          'Subcollection deleted successfully!'))
                                      .catchError((error) => print(
                                          'Failed to delete subcollection: $error'));
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.delete,
                                  size: 22,
                                )),
                            const SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Title ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              snapshot.data!.docs[index]['title'],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Category ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              snapshot.data!.docs[index]['category'],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Price ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              snapshot.data!.docs[index]['price'],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Discounted Price ",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              snapshot.data!.docs[index]['discountedPrice'],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
