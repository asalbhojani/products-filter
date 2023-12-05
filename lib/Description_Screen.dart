
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';


class DescriptionScreen extends StatefulWidget {
  String image;
  String name;
  double price;
  String battery;
  String display;
  String memory;
  String processor;
  String storage;
  String operatingSystem;
  String power;


  DescriptionScreen({
    required this.image,
    required this.name,
    required this.price,
    required this.battery,
    required this.display,
    required this.memory,
    required this.processor,
    required  this.storage,
    required  this.operatingSystem,
    required  this.power});


  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {

  void productinsert()async{
    String descId = Uuid().v1();
    var id;
    var name;
    var image;
    var price;

    Map<String, dynamic> productDetail = {
      "Id": descId,

      "Desc-Name": name.toString(),
      "Decs-Image": image.toString(),
      "Desc-Price": price.toString(),
    };
    FirebaseFirestore.instance.collection("productDetail").doc(descId).set(productDetail);
  }
  TextEditingController review = TextEditingController();
  double rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50)),
                  image: DecorationImage(
                    image: AssetImage(widget.image),
                  )
              ),
            ),
            Stack(
                children: [ Container(
                  width: double.infinity,
                  height: 500,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50)),
                      color: Color(0xf0003333)
                  ),
                ),
                  Row(
                    children: [
                      Container(
                        width: 200,
                        height: 70,
                        margin: EdgeInsets.only(left: 30, top: 30),
                        child: Text(widget.name, style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),),
                      ),
                      SizedBox(width: 120,),

                      CircleAvatar(
                        backgroundColor: Color(0xf0003333),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite, color: Colors.white, size: 40,),
                            Container(

                              decoration: BoxDecoration(
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    children: [

                      Container(
                        margin: EdgeInsets.only(left: 30, top: 80),
                        width: 300,
                        height: 70,
                        child: Text(widget.price.toString() , style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: Text("Ratings and Reviews"),
                              content: Container(
                                height: 200,
                                child: Column(
                                  children: [

                                    Container(
                                        margin: EdgeInsets.only(top: 10,
                                            bottom: 20,
                                            left: 10,
                                            right: 10),
                                        child: TextFormField(
                                            controller: review,
                                            decoration: InputDecoration(
                                              label: Text("Enter your Review"),
                                              // filled: true,
                                              // fillColor: Color(0xffff6d40),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius
                                                    .circular(15.0),
                                                borderSide: BorderSide(
                                                    color: Color(0xf0003333)),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius
                                                    .circular(15.0),
                                                borderSide: BorderSide(
                                                    color: Color(0xf0003333)),
                                              ),
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15.0, right: 10),
                                                child: Icon(
                                                  Icons.rate_review_outlined,
                                                  color: Color(0xf0003333),),),
                                              // prefixIcon: Icon(Icons.person,color: Color(0xf001074f),),
                                            )
                                        )
                                    ),

                                    Center(
                                      child: RatingBar.builder(
                                        initialRating: 0,
                                        minRating: 1,
                                        allowHalfRating: true,
                                        unratedColor: Colors.grey,
                                        itemCount: 5,
                                        itemSize: 30.0,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        updateOnDrag: true,
                                        itemBuilder: (context, index) =>
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                        onRatingUpdate: (ratingvalue) {
                                          setState(() {
                                            rating = ratingvalue;
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        rating = 0;
                                      });
                                      Navigator.of(dialogContext).pop();
                                    }, child: Text("Not Now")
                                ),
                                ElevatedButton(
                                    child: Text("OK"),
                                    onPressed: () async {
                                      String productId = Uuid().v1();

                                      Map<String, dynamic> productDetails = {
                                        "Review-Id": productId,
                                        "Review-message": review.text
                                            .toString(),
                                        "Star-Rating": rating
                                      };
                                      await FirebaseFirestore.instance
                                          .collection("Product-Reviews").doc(
                                          productId).set(productDetails);
                                      Navigator.of(dialogContext).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xf0003333),
                                    )),
                              ],
                            );
                          });
                    },

                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 30,
                          margin: EdgeInsets.only(top: 200),
                        ),
                        Center(
                          child: RatingBar.builder(
                            initialRating: rating,
                            ignoreGestures: true,
                            unratedColor: Colors.grey,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 25.0,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            updateOnDrag: true,
                            itemBuilder: (context, index) =>
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                            onRatingUpdate: (ratingvalue) {},
                          ),
                        ),

                        SizedBox(width: 100,),

                        CircleAvatar(
                          backgroundColor: Color(0xf0003333),
                          child: Row(
                            children: [
                              Icon(Icons.reviews, color: Colors.white,
                                size: 30,),
                              Container(
                                decoration: BoxDecoration(
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),


                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 170, left: 20),
                        child: Text("-------------------", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25
                        ),),
                      )
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 220, left: 20),
                        child: Text("Specification: ", style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25
                        ),),
                      )
                    ],
                  ),

                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 280, left: 20),
                        child: Text(widget.operatingSystem, style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13
                        ),),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 300, left: 20),
                        child: Text(
                          "02: Memory:" + widget.memory, style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13
                        ),),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 320, left: 20),
                        child: Text(
                          "03: Storage:" + widget.storage, style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13
                        ),),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 340, left: 20),
                        child: Text(
                          "04: processor:" + widget.processor, style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13
                        ),),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 360, left: 20),
                        child: Text(
                          "05: Display:" + widget.display, style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13
                        ),),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 380, left: 20),
                        child: Text(
                          "06: Power:" + widget.power, style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13
                        ),),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 400, left: 20),
                        child: Text(
                          "07: battery:" + widget.battery, style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13
                        ),),
                      )
                    ],
                  ),

                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          productinsert();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 440, left: 70),
                          width: 250,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.only(left: 40, top: 8),
                          child: Text("Add To Card", style: GoogleFonts.poppins(
                              color: Color.fromRGBO(6, 27, 28, 1),
                              fontSize: 25,
                              fontWeight: FontWeight.w600
                          ),),
                        ),
                      )
                    ],
                  )
                ]
            ),
          ],
        ),

      ),

    );
  }
}