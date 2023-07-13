

import 'package:adde_commerce/addProduct.dart';
import 'package:adde_commerce/addSubCategory.dart';
import 'package:adde_commerce/deleteProduct.dart';
import 'package:adde_commerce/main.dart';
import 'package:adde_commerce/updateProduct.dart';
import 'package:adde_commerce/utils.dart';
import 'package:adde_commerce/viewProdoct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'addBanner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool loading = false;

  var mainCategoryController = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = FirebaseFirestore.instance.collection("Single Piece").snapshots();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    mainCategoryController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: ListView(
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                    ),
                    child: Text(
                      'E-Commerce App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Add Single Piece',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Add Banner',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddBanner()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Add Product',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddProduct()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'View Products',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ViewProduct()));
                    },
                  ),
                ],
              )),
        ),
        appBar: AppBar(
          title: const Text('Add Single Piece'),
        ),
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
                      if(snapshot.connectionState == ConnectionState.done && snapshot.data!.docs.isEmpty){
                        return Center(child: Text("No Main Categories found"),);
                      }

                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var mainCategory = snapshot.data!.docs[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AddSubCategory(mainCategoryId: mainCategory.id),));
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                child: Text(mainCategory["category"], style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),),
                              ),
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
                      child: loading ? const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.purple,
                      ) : const Text('Add Main Category'),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
              ],
            ),
          ),
        ));
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
                  Text("Main Category", style: TextStyle(fontSize: 18),),
                  const SizedBox(height: 20,),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      labelText: 'Main Category Name',
                    ),
                    controller: mainCategoryController,
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        if(mainCategoryController.text.trim().isEmpty){
                          Utils().toastMessage("Please enter some main Category");
                          return;
                        }
                        addCollection(mainCategoryController.text.toString()).then((value) {
                          mainCategoryController.clear();
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
  Future<String?> addCollection(String mainCategory) async {
    final users = FirebaseFirestore.instance.collection('Single Piece');
    await users.add({
    'category': mainCategory,
    },);
    return "Created";
  }

}

