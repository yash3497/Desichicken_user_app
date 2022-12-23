import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderWidget extends StatefulWidget {
  List imageList;
  SliderWidget({required this.imageList});
  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  final _carouselController = CarouselController();

  // int inActive = 0;
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
                viewportFraction: 1,
                enlargeCenterPage: true,
                autoPlay: true,
                // enlargeCenterPage: true,
                // height: MediaQuery.of(context).size.height * 0.18,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
            items: widget.imageList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    // width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.1,
                    margin: const EdgeInsets.symmetric(horizontal: 0.0),

                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.network(
                        i,
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(
            height: 10,
          ),
          // buildPage(),
        ],
      ),
    );
  }

  // Widget buildPage() => AnimatedSmoothIndicator(
  //       activeIndex: _current,
  //       count: widget.imageList.length,
  //       effect: ExpandingDotsEffect(
  //           spacing: MediaQuery.of(context).size.width * 0.021,
  //           dotWidth: MediaQuery.of(context).size.width * 0.03,
  //           dotHeight: MediaQuery.of(context).size.height * 0.008,
  //           dotColor: Colors.grey,
  //           activeDotColor: Colors.black),
  //     );
}
