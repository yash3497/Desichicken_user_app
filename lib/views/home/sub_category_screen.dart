import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widget/custom_gradient_button.dart';
import '../categories/vendor_product_screen.dart';
import '../my_cart/cart_tab_screen.dart';

class SubCategoryScreen extends StatefulWidget {
  final String categoryId;

  const SubCategoryScreen({super.key, required this.categoryId});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  List<Map<String, dynamic>> data = [];

  _fetchSubCategory() async {
    await FirebaseFirestore.instance
        .collection('SubCategories')
        .where('categoryId', isEqualTo: widget.categoryId)
        .get()
        .then((value) {
      setState(() {
        value.docs.map((e) => data.add(e.data())).toList();
        print('SubCategory $data');
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchSubCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Visibility(
        visible: cartList.isNotEmpty ? true : false,
        child: Container(
          height: height(context) * 0.1,
          width: width(context),
          padding: const EdgeInsets.only(top: 10, left: 15, right: 20),
          decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.grey,
                )
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.spaceBetween,
            children: [
              ListTile(
                leading: Icon(Icons.shopping_cart_outlined),
                title: Text('${cartList.length} Items'),
                trailing: Container(
                  width: width(context) * 0.4,
                  child: CustomButton(
                      buttonName: 'Go to Cart',
                      onClick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyCartScreen()));
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          'SubCategories',
          style: TextStyle(color: black),
        ),
      ),
      body: Column(
        children: [
          data.isNotEmpty
              ? GridView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisExtent: height(context) * 0.25,
                    crossAxisSpacing: 20.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return SubCategoryTile(
                      imageURL: data[index]['image'],
                      title: data[index]['name'],
                      subCategoryId: data[index]['subCategoryId'],
                    );
                  },
                )
              : const Center(
                  child: Text('No Data Available'),
                ),
        ],
      ),
    );
  }
}

class SubCategoryTile extends StatelessWidget {
  final String title;
  final String imageURL;
  final String subCategoryId;

  const SubCategoryTile(
      {super.key,
      required this.title,
      required this.imageURL,
      required this.subCategoryId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // for direct product screen
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VendorProductScreen(
                      category: title,
                      vendorID: '',
                      vendorName: '',
                      subCategoryId: subCategoryId,
                    )));
      },
      child: Column(
        children: [
          Container(
            height: height(context) * 0.2,
            width: width(context) * 0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                image: DecorationImage(
                    image: NetworkImage(imageURL), fit: BoxFit.fill)),
          ),
          FittedBox(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: bodyText13normal(color: black),
            ),
          )
        ],
      ),
    );
  }
}
