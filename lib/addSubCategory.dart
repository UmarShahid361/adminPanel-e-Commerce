

import 'package:adde_commerce/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSubCategory extends StatefulWidget {
  final String mainCategoryId;
  const AddSubCategory({super.key, required this.mainCategoryId});

  @override
  State<AddSubCategory> createState() => _AddSubCategoryState();
}

class _AddSubCategoryState extends State<AddSubCategory> {
  var subCategoryController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = FirebaseFirestore.instance.collection("Single Piece").doc(widget.mainCategoryId).collection("subCategory").snapshots();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    subCategoryController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              Expanded(
                child: StreamBuilder(
                  stream: stream,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(color: Colors.purple,));
                    }
                    if(snapshot.hasError){
                      return Center(child: Text(snapshot.error.toString()),);
                    }
                    if(snapshot.connectionState == ConnectionState.active && snapshot.data!.docs.isEmpty){
                      return Center(child: Text("No Sub Categories found"),);
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var mainCategory = snapshot.data!.docs[index];
                        print(mainCategory['subCategoryName']);
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Text(mainCategory["subCategoryName"], style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),),
                          ),
                        );
                      },
                    );

                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  showAddMainCategoryDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.of(context).size.width * 0.80,
                  height: 50,
                  child: Center(
                    child: const Text('Add Sub Category'),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
  Future showAddMainCategoryDialog(BuildContext context){
    return showDialog(context: context, builder: (context) {
      return Center(
        child: Material(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 240,
            width: MediaQuery.of(context).size.width*0.85,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sub Category", style: TextStyle(fontSize: 18),),
                  const SizedBox(height: 20,),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      labelText: 'Main Sub Name',
                    ),
                    controller: subCategoryController,
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        if(subCategoryController.text.trim().isEmpty){
                          Utils().toastMessage("Please enter some sub Category");
                          return;
                        }
                        addSubCollection(subCategoryController.text.toString()).then((value) {
                          subCategoryController.clear();
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: 50,
                        child: Center(
                          child: const Text('Add'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },);
  }
  Future<String?> addSubCollection(String subCategory) async {
    final users = FirebaseFirestore.instance.collection('Single Piece');
    users.doc(widget.mainCategoryId).collection("subCategory").add({
      'subCategoryName': subCategory,
    },);
    return "Created";
  }
}
