import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';

import 'package:flutter/material.dart';

import '../../widget/custom_appbar.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final Stream<QuerySnapshot> notifications =
      FirebaseFirestore.instance.collection('userNotification').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppbar(
          title: 'Notification',
          button: const SizedBox(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Text(
          //   'Today',
          //   style: bodyText20w700(color: black),
          // ),
          addVerticalSpace(10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: notifications,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something wrong occurred");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.size,
                    itemBuilder: (BuildContext context, int index) {
                      return NotificationTile(
                        title: snapshot.data!.docs[index]['content'],
                        desc: snapshot.data!.docs[index]["createdAt"]
                            .toDate().toString().substring(0,16),
                        imageURL: "",
                      );
                    },
                  );
                }),
          )
        ]),
      ),
    );
  }
}


class NotificationTile extends StatelessWidget {
  final String imageURL;
  final String title;
  final String desc;
  const NotificationTile({super.key, required this.imageURL, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          bottom: 15, left: 5, right: 5, top: 5),
      height: height(context) * 0.1,
      width: width(context) * 0.99,
      decoration: shadowDecoration(10, 1),
      child: Center(
        child: ListTile(
          // leading: CircleAvatar(
          //   radius: 28,
          //   backgroundImage:
          //       NetworkImage(imageURL),
          // ),
          title: Text(
            title,
            style: bodyText13normal(color: black),
          ),
          trailing: Text(desc),
        ),
      ),
    );
  }
}
