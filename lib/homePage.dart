import 'package:adde_commerce/addProduct.dart';
import 'package:adde_commerce/deleteProduct.dart';
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
  String? value;
  String? category;
  String? value2;
  final options = [
    "Saree",
    "Gowns",
    "Westerns",
    "Dress Material",
    "Lehengas",
    "Kurti",
    "Top with Bottom"
  ];
  final saree = [
    "Daily Wear Saree",
    "Printed Saree",
    "Cotton Saree",
    "Silk Saree",
    "All Saree"
  ];
  final gowns = ["Gown 1", "Gown 2", "Gown 3"];
  final westerns = ["Western 1", "Western 2", "Western 3"];
  final dressMaterial = [
    "Dress Material 1",
    "Dress Material 2",
    "Dress Material 3"
  ];
  final lehengas = ["All Lehengas"];
  final kurti = ["Designer Kurti", "Printed Kurti", "All Kurti"];
  final topWithBottom = ["Kurti Plazo", "All Top with Bottom"];
  bool loading = false;

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
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
                        value: value,
                        items: options.map(buildMenuItem).toList(),
                        onChanged: (value) => setState(
                          () {
                            this.value = value;
                            category = value;
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (value == "Saree")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                          value: value2,
                          items: saree.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(
                            () {
                              value2 = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  if (value == "Gowns")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                          value: value2,
                          items: gowns.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(
                            () {
                              value2 = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  if (value == "Westerns")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                          value: value2,
                          items: westerns.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(
                            () {
                              value2 = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  if (value == "Dress Material")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                          value: value2,
                          items: dressMaterial.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(
                            () {
                              value2 = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  if (value == "Lehengas")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                          value: value2,
                          items: lehengas.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(
                            () {
                              value2 = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  if (value == "Kurti")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                          value: value2,
                          items: kurti.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(
                            () {
                              value2 = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  if (value == "Top with Bottom")
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
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
                          value: value2,
                          items: topWithBottom.map(buildMenuItem).toList(),
                          onChanged: (value) => setState(
                            () {
                              value2 = value;
                            },
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      addCollection()
                     .then((value) {
                        setState(() {
                          category = null;
                          value2 = null;
                          value = null;
                          loading = false;
                        });
                        Utils().toastMessage('Product Added Successfully');
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage(error.toString());
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: MediaQuery.of(context).size.width * 0.80,
                      height: 50,
                      child: Center(
                        child: loading ? const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ) : const Text('Add Product'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ));
  }
  Future<String?> addCollection() async {
    final users = FirebaseFirestore.instance.collection('Single Piece');
    var result = await users.add({
    'category': category.toString(),
    },);
    await addSubCollection(
      id: result.id,
    );
    return "Created";
  }
  Future<String?> addSubCollection({String? id}) async {
    final users = FirebaseFirestore.instance.collection('Single Piece');
    users.doc(id).collection("subCategory").add({
      'subCategoryName': value2.toString(),
    },);
    return "Created";
  }
}

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: const TextStyle(fontSize: 20),
    ));
