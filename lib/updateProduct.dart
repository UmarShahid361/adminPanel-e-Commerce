import 'package:adde_commerce/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateProduct extends StatefulWidget {
  String id;
  String title;
  String discountedPrice;
  String price;
  String off;
  String description;
  UpdateProduct({super.key,required this.id, required this.title, required this.discountedPrice, required this.price, required this.off, required this.description});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  bool loading = false;

  final titleController = TextEditingController();

  final discountedController = TextEditingController();

  final priceController = TextEditingController();

  final offController = TextEditingController();

  final descriptionController = TextEditingController();


  updateData(id, value1, value2, value3, value4, value5) async {
    await FirebaseFirestore.instance.collection('Products').doc(id).update({
      'title': value1,
      'discountedPrice': value2,
      'price': value3,
      'off': value4,
      'description': value5,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance.collection("Products").get(),
              builder: (context, dynamic snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(18)),
                            ),
                            labelText: 'Product Name',
                          ),
                          controller: TextEditingController(
                              text: widget.title),
                          onChanged: (value1) {
                            widget.title = value1;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(18)),
                            ),
                            labelText: 'Discounted Price',
                          ),
                          controller: TextEditingController(
                              text: widget.discountedPrice),
                          onChanged: (value2) {
                            widget.discountedPrice = value2;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(18)),
                            ),
                            labelText: 'Price',
                          ),
                          controller: TextEditingController(
                              text: widget.price),
                          onChanged: (value3) {
                            widget.price = value3;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(18)),
                            ),
                            labelText: 'OFF%',
                          ),
                          controller: TextEditingController(
                              text: widget.off),
                          onChanged: (value4) {
                            widget.off = value4;
                          },
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(18)),
                            ),
                            labelText: 'Description',
                          ),
                          controller: TextEditingController(
                              text: widget.description),
                          onChanged: (value5) {
                            widget.description = value5;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            updateData(widget.id, widget.title,
                                widget.discountedPrice, widget.price, widget.off, widget.description);
                            Utils().toastMessage("Product Details Updated!");
                            titleController.clear();
                            discountedController.clear();
                            priceController.clear();
                            offController.clear();
                            descriptionController.clear();
                          },
                          child: SizedBox(
                            height: 40,
                            width: 200,
                            child: Center(
                              child: loading
                                  ? const CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              )
                                  : const Text(
                                "Update Product Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
