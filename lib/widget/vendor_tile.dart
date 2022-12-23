import 'package:delicious_app/model/category_model.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../views/categories/vendor_product_screen.dart';
import 'custom_gradient_button.dart';

class VendorTile extends StatelessWidget {
  final String id;
  final String category;
  final String title;
  final String imageURL;
  final double rating;
  final int timing;
  VendorTile(
      {super.key,
      required this.title,
      required this.imageURL,
      required this.rating,
      required this.timing,
      required this.category,
      required this.id});

  bool deliverable = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!deliverable) {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.white,
                insetAnimationDuration: const Duration(milliseconds: 100),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  // use container to change width and height
                  height: 200,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        'We’re sorry :(',
                        style: bodyText30W600(color: black),
                      ),
                      SizedBox(
                        width: width(context) * 0.6,
                        child: Text(
                          'This vendor is not functioning in your locality',
                          textAlign: TextAlign.center,
                          style: bodyText14w600(color: black),
                        ),
                      ),
                      SizedBox(
                          width: width(context) * 0.4,
                          height: 40,
                          child: CustomButton(
                              buttonName: 'Call us',
                              onClick: () {
                                Navigator.pop(context);
                              }))
                    ],
                  ),
                ),
              );
            },
          ).then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) =>
                      // ProductScreen(
                      //   name: category.toLowerCase(),
                      //   vendor: id,
                      // )
                      VendorProductScreen(
                        vendorName: title,
                        category: category,
                        vendorID: id,
                        subCategoryId: '',
                        // title: mainCategory[index]['name'],
                      ))));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) =>
                      // ProductScreen(
                      //   name: category.toLowerCase(),
                      //   vendor: title,
                      // )
                      VendorProductScreen(
                        vendorName: title,
                        vendorID: id,
                        category: category,
                        subCategoryId: '',
                      )));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: 7, right: 8, bottom: 7, top: 7),
        // color: ligthRed,
        height: height(context) * 0.14,
        width: width(context) * 0.5,
        decoration: shadowDecoration(15, 5),
        child: Column(
          children: [
            SizedBox(
              height: height(context) * 0.1,
              width: width(context) * 0.45,
              child: Image.network(
                imageURL,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              height: height(context) * 0.13,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width(context) * 0.25,
                        child: Text(
                          title,
                          style: bodyText14w600(color: black),
                        ),
                      ),
                      Container(
                        height: 21,
                        width: width(context) * 0.15,
                        decoration: myFillBoxDecoration(
                            0, const Color.fromRGBO(251, 188, 4, 1), 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              rating.toString(),
                              style: bodyText12Small(color: white),
                            ),
                            Icon(
                              Icons.star,
                              size: 15,
                              color: white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.timer,
                        size: 18,
                        color: Colors.yellow,
                      ),
                      addHorizontalySpace(5),
                      Text(
                        '${timing} mins',
                        style: bodyText11Small(color: Colors.black38),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
