import 'package:delicious_app/model/home_categorylist_model.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/home/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: white,
        centerTitle: true,
        title: Text(
          'Search',
          style: bodyText16w600(color: black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: height(context) * 0.05,
                    width: width(context) * 0.75,
                    child: TextField(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResultsScreen(
                                  exclusive: false,
                                  category: 0,  
                                  search: "",
                                      title: '',
                                    )));
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            color: primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          contentPadding:
                              const EdgeInsets.only(top: 12, left: 20),
                          filled: true,
                          hintStyle: TextStyle(color: ligthRed),
                          hintText: 'What do you want to order?',
                          fillColor: const Color.fromRGBO(255, 187, 186, 0.2)),
                    ),
                  ),
                  Center(
                    child: Image.asset('assets/images/filter.png'),
                  )
                ],
              ),
              addVerticalSpace(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Search',
                    style: bodyText16w600(color: black),
                  ),
                  Text(
                    'CLEAR',
                    style: bodyText16w600(color: primary),
                  ),
                ],
              ),
              addVerticalSpace(15),
              Wrap(
                  children: List.generate(searchtypeList.length, (index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 5, right: 5),
                  width: width(context) * 0.3,
                  decoration:
                      myOutlineBoxDecoration(0, black.withOpacity(0.3), 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.replay_circle_filled_outlined,
                        color: Colors.black38,
                      ),
                      Text(
                        searchtypeList[index].toString(),
                        style: bodyText12Small(color: black),
                      )
                    ],
                  ),
                );
              })),
              addVerticalSpace(15),
              Text(
                'Categories',
                style: bodyText16w600(color: black),
              ),
              addVerticalSpace(10),
              SizedBox(
                height: height(context) * 0.36,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: homeCategoryList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 20,
                        mainAxisExtent: height(context) * 0.18),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Image.asset(homeCategoryList[index]['img']),
                          Text(
                            homeCategoryList[index]['name'],
                            textAlign: TextAlign.center,
                            style: bodyText13normal(color: black),
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
