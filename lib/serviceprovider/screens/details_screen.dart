import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../hosts/widget/widgets.dart';
import '../screens/select_location.dart';

class DetailScreen extends StatefulWidget {
  final String categoryName;
  DetailScreen({
    required this.categoryName,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final formkey = GlobalKey<FormState>();
  String title = '';
  String desc = '';
  double? price;
  final List<XFile> images = [];
  bool _isloading = false;

  final ImagePicker imagePicker = ImagePicker();
  Future pickImage() async {
    try {
      final List<XFile>? selectedImage = await imagePicker.pickMultiImage();

      if (selectedImage == null) {
        return [];
      }
      setState(() {
        images.addAll(selectedImage);
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to pick image:$e");
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                    decoration: textinputDecoration.copyWith(
                      labelText: "Enter your title",
                      contentPadding: const EdgeInsets.all(5),
                      prefixIcon: Icon(
                        Icons.title,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        title = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "title cannot be empty";
                      }
                    }),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                    decoration: textinputDecoration.copyWith(
                      labelText: "Enter your description",
                      hintMaxLines: 4,
                      prefixIcon: Icon(
                        Icons.description,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        desc = val;
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "description cannot be empty";
                      }
                    }),
                const SizedBox(
                  height: 15.0,
                ),
                TextFormField(
                    decoration: textinputDecoration.copyWith(
                      labelText: "Enter your price",
                      contentPadding: const EdgeInsets.all(5),
                      hintMaxLines: 4,
                      prefixIcon: Icon(
                        Icons.euro,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        price = double.parse(val);
                      });
                    },
                    validator: (val) {
                      if (val!.isNotEmpty) {
                        return null;
                      } else {
                        return "price cannot be empty";
                      }
                    }),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(
                        10.0,
                      )),
                  child: images.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: images.length,
                          itemBuilder: (_, index) {
                            return Row(
                              children: [
                                InkWell(
                                  onTap: pickImage,
                                  child: Container(
                                    height: 150,
                                    width: 90,
                                    margin: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Image.file(
                                      File(images[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 25,
                                // ),
                                // IconButton(
                                //   icon: const Icon(
                                //     Icons.add_a_photo,
                                //     size: 50,
                                //   ),
                                //   onPressed: () async {
                                //     await pickImage();
                                //   },
                                // ),
                              ],
                            );
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.add_a_photo,
                                size: 50,
                              ),
                              onPressed: () {
                                pickImage();
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text("Please upload your images"),
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: IconButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        nextScreen(
                          context,
                          SelectLocation(
                            categoryName: widget.categoryName,
                            title: title,
                            desc: desc,
                            price: price,
                            images: images,
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_circle_right,
                      size: 45,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
