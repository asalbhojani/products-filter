import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class ProductsList extends StatefulWidget {

  String brandName;
  ProductsList({required this.brandName});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  var searchName = "";
  String? selectedPriceFilter;
  String? selectedStorageFilter;

  Stream<QuerySnapshot> getFilteredData() {
    CollectionReference collection =
    FirebaseFirestore.instance.collection("Product-Data");

    Query query =
    collection.where('Product-Brand', isEqualTo: widget.brandName);

    if (selectedPriceFilter != null) {
      if (selectedPriceFilter == "lowToHigh") {
        query = query.orderBy('Product-Price', descending: false);
      }
      if (selectedPriceFilter == "highToLow") {
        query = query.orderBy('Product-Price', descending: true);
      }
    }

    if (selectedStorageFilter != null) {
      if (selectedStorageFilter == "lowToHigh") {
        query = query.orderBy('Product-Storage', descending: false);
      }
      if (selectedStorageFilter == "highToLow") {
        query = query.orderBy('Product-Storage', descending: true);
      }
    }

    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, left: 75, right: 20),
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async{
                      showDialog<void>(
                        context: context,
                        builder: (BuildContext dialogContext ) {
                          return AlertDialog(
                            title: Text("Filter Options"),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Price"),
                                DropdownButton<String>(
                                  value: selectedPriceFilter,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedPriceFilter = value;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: "null",
                                      child: Text("None"),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: "lowToHigh",
                                      child: Text("Low to High"),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: "highToLow",
                                      child: Text("High to Low"),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text("Storage"),
                                DropdownButton<String>(
                                  value: selectedStorageFilter,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedStorageFilter = value;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: "null",
                                      child: Text("None"),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: "lowToHigh",
                                      child: Text("Low to High"),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: "highToLow",
                                      child: Text("High to Low"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: (){
                                    Navigator.of(dialogContext).pop();
                                  },  child:Text("Not Now")
                              ),
                              TextButton(
                                onPressed: () {
                                  getFilteredData();
                                  Navigator.of(context).pop();

                                },
                                child: Text("Apply Filters"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Color(0xffffffff)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                          side: BorderSide(color: Color(0xf0003333)),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 4, vertical: 11),
                      child: Row(
                        children: [
                          Text(
                            "Filter",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: Color(0xf0000000),
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(Icons.expand_more, color: Color(0xf0000000)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            StreamBuilder(
                stream: getFilteredData(),
                builder: (BuildContext context, snapshot) {

                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    var dataLength = snapshot.data!.docs.length;
                    return dataLength==0?Text("Nothing to Show"):
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: GridView.count(
                        crossAxisCount: 2,
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 280/450,
                        children: List.generate(dataLength, (index) {
                          String name = snapshot.data!.docs[index]['Product-Name'];
                          String img = snapshot.data!.docs[index]['Product-Image'];
                          String price = snapshot.data!.docs[index]['Product-Price'];
                          return  Stack(
                            children: [
                              // Container(
                              //    width: 30,
                              //    height: 320,
                              //    decoration: BoxDecoration(
                              //      borderRadius: BorderRadius.circular(20),
                              //      color: Color(0xff002a62),
                              //        boxShadow: [
                              //          BoxShadow(
                              //            color: Color(0xff8f8989,),
                              //            spreadRadius: 4,
                              //            blurRadius: 10,
                              //            offset: Offset(4, 4),
                              //          )
                              //        ]
                              //    ),
                              //  ),

                              GestureDetector(
                                onTap: (){
                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=> sofaDescription(img: img[index], price: price[index], name: name[index]),));
                                },
                                child: Container(
                                  width: 350,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Color(0xffffffff),
                                      // image: DecorationImage(
                                      //     colorFilter: ColorFilter.mode(Color(
                                      //         0xf44d4d4d).withOpacity(0.2), BlendMode.darken),
                                      //     fit: BoxFit.cover,
                                      //     image: AssetImage("${img[index]}")),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                              0xf4a1a1a1),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(1, 1),
                                        )
                                      ]
                                  ),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Stack(
                                          children: <Widget>[

                                            Container(
                                              width: 200,
                                              height: 170,
                                              margin: EdgeInsets.only(top: 20),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: Color(0xffffffff),
                                                image: DecorationImage(
                                                    colorFilter: ColorFilter.mode(Color(
                                                        0xffffffff).withOpacity(0.2), BlendMode.darken),
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage("$img")),
                                                // boxShadow: [
                                                //   BoxShadow(
                                                //     color: Color( 0xf44d4d4d),
                                                //     spreadRadius: 1,
                                                //     blurRadius: 5,
                                                //     offset: Offset(1, 1),
                                                //   )
                                                // ]
                                              ),
                                            ),
                                            Container(
                                                width: 40,
                                                height: 33,
                                                margin: EdgeInsets.only(left: 135,right: 5,top: 5),
                                                decoration: BoxDecoration(

                                                    shape: BoxShape.circle,
                                                    color: Color(0xffffffff),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:  Color(
                                                            0xf3c4c4c4),
                                                        spreadRadius: 1,
                                                        blurRadius: 5,
                                                        offset: Offset(2, 2),
                                                      )
                                                    ]
                                                  // border: Border.all(color: Color(0xffa19e9e))
                                                ),
                                                child: Icon(CupertinoIcons.heart,color: Color(0xf0003333))
                                            ),

                                          ],),
                                        // SizedBox(height: 30,),
                                        Container(
                                          margin: EdgeInsets.only(top: 6,left: 10,right: 10),
                                          child: Text("$name",style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color:Theme.of(context).iconTheme.color,
                                          ),),
                                        ),

                                        Row(
                                          children: [
                                            SizedBox(width: 10,),
                                            Icon(Icons.star_outline_rounded,color: Color(
                                                0xf0343434)),
                                            SizedBox(width: 5,),
                                            Text("5.00", style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color:  Color(0xf0343434),
                                            ),),
                                            SizedBox(width: 18,),
                                            Text("\$$price",style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xf0003333),
                                            ),),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            ],
                          );
                        }),

                      ),
                    );
                  }if (snapshot.hasError) {
                    return Icon(Icons.error_outline);
                  }
                  return Container();
                }),
          ],
        ),
      ),
    );
  }

}
