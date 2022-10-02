import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/hosts/helper/provider_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../screens/details_screen.dart';
import '../widget/widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

String _showCat = "All";

class CategoryChoise {
  CategoryChoise({required this.category, required this.categoryName});
  final String category;
  final String categoryName;

  @override
  String toString() {
    // TODO: implement toString
    return 'category:$category categoryName $categoryName';
  }
}

const categories = <String>[
  'All',
  'Resturant',
  'Venue',
  'Photographer',
  'Decorator',
  'Transport',
  'Catering',
  'BeautySaloon',
  'Bakeries'
];
List<CategoryChoise> selectCategories = <CategoryChoise>[
  CategoryChoise(category: categories.elementAt(0), categoryName: 'All'),
  CategoryChoise(category: categories.elementAt(1), categoryName: 'Resturant'),
  CategoryChoise(category: categories.elementAt(2), categoryName: 'Venue'),
  CategoryChoise(
      category: categories.elementAt(3), categoryName: 'Photographer'),
  CategoryChoise(category: categories.elementAt(4), categoryName: 'Decorator'),
  CategoryChoise(category: categories.elementAt(5), categoryName: 'Transport'),
  CategoryChoise(category: categories.elementAt(6), categoryName: 'Catering'),
  CategoryChoise(
      category: categories.elementAt(7), categoryName: 'BeautySaloon'),
  CategoryChoise(category: categories.elementAt(7), categoryName: 'Bakeries'),
];

class _MainScreenState extends State<MainScreen> {
  List<String> urls = [];
  var rating = 3.0;

  void _select(String newcategory) {
    setState(() {
      _showCat = newcategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.pink,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_border_sharp),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 7,
                      width: 80,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black26,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _select(selectCategories[index].categoryName);
                        },
                        child: Center(
                          child: Text(
                            categories[index],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  _showCat,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _showCat == "All"
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('category', isEqualTo: 'ServiceProvider')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            // List<dynamic> extractedData = snapshot.data!.docs
                            //     .where(
                            //         (e) => e['category'] == 'ServiceProvider')
                            //     .toList();
                            return Flexible(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 380,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 15,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.docs[index];

                                  return GestureDetector(
                                    onTap: () {
                                      List<String> geturl = [];
                                      for (var a in snapshot.data!.docs[index]
                                          ['images']) {
                                        geturl.add(a);
                                      }
                                      nextScreen(
                                        context,
                                        DetailsScreen(
                                          title: data['title'],
                                          imageUrl: data['images'][0],
                                          price: data['price'],
                                          desc: data['desc'],
                                          id: data['uid'],
                                          fullname: data['fullName'],
                                          lat:
                                              double.parse(data['location'][0]),
                                          lon:
                                              double.parse(data['location'][1]),
                                          images: geturl,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black26),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 80,
                                            width: double.infinity,
                                            child: Image.network(
                                              data['images'][0],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            "${data['title']}".toUpperCase(),
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${data['price']}Rs"
                                                    .toUpperCase(),
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SmoothStarRating(
                                                rating: rating,
                                                isReadOnly: true,
                                                size: 15,
                                                filledIconData: Icons.star,
                                                halfFilledIconData:
                                                    Icons.star_half,
                                                defaultIconData:
                                                    Icons.star_border,
                                                starCount: 5,
                                                allowHalfRating: true,
                                                spacing: 2.0,
                                                onRated: (value) {
                                                  print(
                                                      "rating value -> $value");
                                                  // print("rating value dd -> ${value.truncate()}");
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }
                        return Center(child: Text("No category for $_showCat"));
                      },
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('accountcategory', isEqualTo: _showCat)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            // final list = snapshot.data!.docs;
                            // Map data = {};
                            // dynamic b;
                            // List<Widget> listwidget = [];
                            return Flexible(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 380,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 15,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  var data = snapshot.data!.docs[index];
                                  return data['category'] == 'ServiceProvider'
                                      ? GestureDetector(
                                          onTap: () {
                                            List<String> geturl = [];
                                            for (var a in snapshot
                                                .data!.docs[index]['images']) {
                                              geturl.add(a);
                                              print(
                                                  "Aziz khan   ${a.toString()}");
                                            }
                                            nextScreen(
                                              context,
                                              DetailsScreen(
                                                title: data['title'],
                                                imageUrl: data['images'][0],
                                                price: data['price'],
                                                desc: data['desc'],
                                                id: data['uid'],
                                                fullname: data['fullName'],
                                                lat: double.parse(
                                                    data['location'][0]),
                                                lon: double.parse(
                                                    data['location'][1]),
                                                images: geturl,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black26),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 80,
                                                  width: double.infinity,
                                                  child: Image.network(
                                                    data['images'][0],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Text(
                                                  "${data['title']}"
                                                      .toUpperCase(),
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${data['price']}Rs"
                                                          .toUpperCase(),
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    SmoothStarRating(
                                                      rating: rating,
                                                      isReadOnly: true,
                                                      size: 15,
                                                      filledIconData:
                                                          Icons.star,
                                                      halfFilledIconData:
                                                          Icons.star_half,
                                                      defaultIconData:
                                                          Icons.star_border,
                                                      starCount: 5,
                                                      allowHalfRating: true,
                                                      spacing: 2.0,
                                                      onRated: (value) {
                                                        print(
                                                            "rating value -> $value");
                                                        // print("rating value dd -> ${value.truncate()}");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink();
                                },
                              ),
                            );
                          }
                        }
                        return Center(child: Text("No category for $_showCat"));
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}


// final list = snapshot.data!.docs;
//                             Map data = {};
//                             dynamic b;
//                             List<Widget> listwidget = [];

//                             for (var a in list) {
//                               if (a.data().toString().contains('provider')) {
//                                 b = a.data();
//                                 data.addAll(b);
//                                 final visible = GestureDetector(
//                                   onTap: () {
//                                     // for (var a in snapshot.data!.docs[index]
//                                     //     ['images']) {
//                                     //   geturls.add(a);
//                                     //   print("Aziz khan   ${a.toString()}");
//                                     //   print(geturls.length);
//                                     // }
//                                     nextScreen(
//                                       context,
//                                       DetailsScreen(
//                                         title: data['title'],
//                                         imageUrl: data['images'][0],
//                                         price: data['price'],
//                                         desc: data['desc'],
//                                         id: data['uid'],
//                                         fullname: data['fullName'],
//                                         lat: double.parse(data['location'][0]),
//                                         lon: double.parse(data['location'][1]),
//                                       ),
//                                     );
//                                   },
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(color: Colors.black26),
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           height: 80,
//                                           width: double.infinity,
//                                           child: Image.network(
//                                             data['images'][0],
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 7,
//                                         ),
//                                         Text(
//                                           "${data['title']}".toUpperCase(),
//                                           maxLines: 1,
//                                           style: const TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 13,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           height: 3,
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Text(
//                                               "${data['price']} \$"
//                                                   .toUpperCase(),
//                                               maxLines: 1,
//                                               style: const TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                             SmoothStarRating(
//                                               rating: rating,
//                                               isReadOnly: true,
//                                               size: 15,
//                                               filledIconData: Icons.star,
//                                               halfFilledIconData:
//                                                   Icons.star_half,
//                                               defaultIconData:
//                                                   Icons.star_border,
//                                               starCount: 5,
//                                               allowHalfRating: true,
//                                               spacing: 2.0,
//                                               onRated: (value) {
//                                                 print("rating value -> $value");
//                                                 // print("rating value dd -> ${value.truncate()}");
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );