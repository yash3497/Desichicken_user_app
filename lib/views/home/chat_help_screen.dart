import 'dart:developer';

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ChatWithOne extends StatefulWidget {
  const ChatWithOne({Key? key}) : super(key: key);

  @override
  State<ChatWithOne> createState() => _ChatWithOneState();
}

class _ChatWithOneState extends State<ChatWithOne> {
  List listOfIssue = [
    'Offers & vouchers',
    'Acoount Related',
    'Traansaction Related',
    'App related',
    'Feedback'
  ];


  late DialogFlowtter dialogFlowtter;

  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

   @override
  void initState() {
     DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance).then((value) {
       sendMessage("Need Help ?");
     });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // log(messages.first["message"].toString());


    return Scaffold(
        body: SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              height: height(context) * 0.8,
              child: ListView.builder(
                itemCount: messages.length,
                // shrinkWrap: false,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    // height: height(context) * 0.,
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (messages[index]["isUserMessage"].toString() == "true"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Column(
                        children: [
                          messages[index]["isUserMessage"].toString() == "false"
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: white,
                                          child: SizedBox(

                                            child: Image.asset(
                                                'assets/images/mainlogo.png'),
                                          ),
                                        ),
                                        Text(
                                          '${DateTime.now().hour } :${DateTime.now().minute}',
                                          style: TextStyle(
                                              fontSize: 12, color: black),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: width(context)*0.66,
                                     padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10)),
                                        color: (ligthRed.withOpacity(0.8)),
                                      ),
                                      // padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(messages[index]["message"].toString())
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: width(context) * 0.5,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        color: (Colors.blueAccent.withOpacity(0.2)),
                                      ),
                                      padding:  EdgeInsets.all(16),
                                      child:Text(messages[index]["message"].toString()),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor: white,
                                            child: const Icon(
                                                Icons.person_outline_outlined)),
                                        Text(
                                          "${DateTime.now().hour } :${DateTime.now().minute}",
                                          style: TextStyle(
                                              fontSize: 12, color: black),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: width(context) * 0.92,
              height: height(context) * 0.06,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Icon(
                      Icons.message_rounded,
                      color: primary,
                    ),
                  ),
                   Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      controller:  _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type Your Query... ",
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.all(10),
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.send,
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }



  void sendMessage(String text) async {
    if (text.isEmpty) return;
    setState(() {
      addMessage(
        text,
        true,
      );
    });

    dialogFlowtter.projectId = "delicioushelpbot-igj9";

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text,
        languageCode: "en",)),

    );
    log(response.text.toString());

    if (response.message == null) return;
    setState(() {
      addMessage(response.text!);
    });
  }

  void addMessage(String message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }
}
