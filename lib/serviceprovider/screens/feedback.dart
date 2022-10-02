import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class FeedBack extends StatefulWidget {
  const FeedBack({Key? key}) : super(key: key);

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  var rating = 3.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FeedBack',
          style: TextStyle(
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Reviews",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          ListView.builder(
              itemCount: 1,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.13,
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/aziz.jpeg'),
                      ),
                      title: const Text(
                        'Ahmad ibrar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        "A very great company providing exellent service recommented",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 3,
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SmoothStarRating(
                            rating: rating,
                            isReadOnly: true,
                            size: 15,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: true,
                            spacing: 2.0,
                            onRated: (value) {
                              print("rating value -> $value");
                              // print("rating value dd -> ${value.truncate()}");
                            },
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const Text("just now")
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
