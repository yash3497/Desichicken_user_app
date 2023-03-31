import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/constants.dart';
import '../views/home/search_result_screen.dart';
import '../views/product_screen.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  listen() async {
    try {
      if (listening) {
        bool avaliable = await speech.initialize(
            onStatus: (val) => log("status" + val),
            onError: (val) => log("error" + val.toString()));
        if (avaliable) {
          if (mounted) {
            setState(() {
              listening = true;
            });
          }
          speech.errorListener = (error) {
            print(error);
            if (mounted) {
              setState(() {
                listening = speech.isListening;
              });
            }
          };
          speech.listen(onResult: ((result) {
            print("result");
            print(result);
            if (result.recognizedWords.isEmpty)
              Fluttertoast.showToast(
                  msg: "No words recognized. Sorry!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            // searchQuery = (result.recognizedWords);
            // searchController.text = (result.recognizedWords);
            if (result.recognizedWords.isNotEmpty) {
              Fluttertoast.showToast(
                  msg: "Recognized Words ${result.recognizedWords}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SearchResultsScreen(
              //           category: 2,
              //           exclusive: false,
              //               search: _text,
              //               title: '',
              //             )));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SearchProductScreen(
              //               filterIndex: "selectedSort.four",
              //               search: result.recognizedWords,
              //             )));
              listening = false;
            }
            if (result.hasConfidenceRating && result.confidence > 0) {
              // confidence = result.confidence;
            }
            if (!listening) {
              // widget.search(searchQuery);
            }
          }));
        } else {
          if (mounted) {
            setState(() {
              listening = speech.isListening;
            });
          }
          log(listening.toString(), name: "speech");
          speech.stop();
          // widget.search(searchQuery);
        }
      }
    } on PlatformException catch (_) {
      listening = false;
      Fluttertoast.showToast(
          msg: "Voice Recognition not available on device. Sorry!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<String> fetchId(String name) async {
    String id = '';
    await FirebaseFirestore.instance
        .collection('Products')
        .where('name', isEqualTo: name)
        .get()
        .then((value) => value.docs.forEach((element) {
              id = element.id;
            }));
    return id;
  }

  List<String> allProductsList = [];
  @override
  void initState() {
    speech = stt.SpeechToText();
    populateNameList();
    // TODO: implement initState
    super.initState();
  }

  populateNameList() {
    FirebaseFirestore.instance
        .collection('Products')
        .get()
        .then((value) => value.docs.forEach((element) {
              // print(element['name']);
              allProductsList.add(element['name']);
            }));
  }

  bool listening = false;
  late stt.SpeechToText speech;
  String _text = "Press";
  double _confidence = 1.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: height(context) * 0.05,
          width: width(context) * 0.75,

          // decoration: BoxDecoration(
          //     color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Autocomplete(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              } else {
                List<String> matches = <String>[];
                matches.addAll(allProductsList);

                matches.retainWhere((s) {
                  return s
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
                return matches;
              }
            },
            onSelected: (String selection) async {
              searchResults = selection;
              String id = await fetchId(selection);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => ProductScreen(
                            name: selection,
                            id: id,
                            productType: 'normal',
                          )));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SearchResultsScreen(
              //               category: 2,
              //               exclusive: false,
              //               search: selection,
              //               title: '',
              //             )));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             SearchProductScreen(
              //                 filterIndex:
              //                     "selectedSort.four",
              //                 search: selection
              //                     .toLowerCase())));
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            print("object");
            listening = !listening;
            print(listening);
            listen();
          },
          child: SizedBox(
            height: 30,
            width: 20,
            child: AvatarGlow(
                animate: listening,
                glowColor: Colors.amber,
                duration: Duration(milliseconds: 2000),
                repeat: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                endRadius: 100,
                child: Icon(listening ? Icons.mic_off : Icons.mic)),
          ),
        ),
      ],
    );
  }
}
