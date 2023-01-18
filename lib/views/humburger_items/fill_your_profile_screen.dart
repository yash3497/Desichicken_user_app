import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:delicious_app/views/start/otp_verify.dart';
import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:delicious_app/widget/custom_textfield.dart';
import 'package:delicious_app/widget/humburger_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../widget/custom_appbar.dart';

class FillYourProfileScreen extends StatefulWidget {
  final bool existing;

  const FillYourProfileScreen({super.key, required this.existing});

  @override
  State<FillYourProfileScreen> createState() => _FillYourProfileScreenState();
}

String msgToken = '';

class _FillYourProfileScreenState extends State<FillYourProfileScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void userDetails() {
    if (!widget.existing) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .set({
        "Address": "",
        "Email": emailController.text,
        "Name": nameController.text,
        "Surname": surnameController.text,
        "Number": auth.currentUser!.phoneNumber,
        "userID": auth.currentUser!.uid,
        "token": msgToken,
        "image": url
      }).whenComplete(() => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateProfileSuccesful())));
    } else {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(auth.currentUser!.uid)
          .update({
        "Address": "",
        "Email": emailController.text,
        "Name": nameController.text,
        "Number": auth.currentUser!.phoneNumber,
        "userID": auth.currentUser!.uid,
        "token": msgToken,
        "image": url
      }).then((value) => Navigator.pop(context));
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    firebaseMessaging.getToken().then((token) {
      print("token is $token");
      msgToken = token!;
      if (mounted) {
        setState(() {});
      }
    });
    if (userDetail != null) {
      nameController.text = userDetail["Name"];
      surnameController.text = userDetail["Surname"];
      emailController.text = userDetail["Email"];
      dobController.text = userDetail["Name"];
    }
  }

  Future selectPhoto(BuildContext context, double d, int i) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera),
                      title: const Text("Camera"),
                      onTap: () async {
                        Navigator.pop(context);

                        getImage(ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.album),
                      title: const Text("Gallery"),
                      onTap: () async {
                        Navigator.pop(context);
                        getImage(ImageSource.gallery);
                      },
                    )
                  ],
                );
              });
        });
  }

  Future getImage(ImageSource source) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      final XFile? image =
          await ImagePicker().pickImage(source: source, imageQuality: 60);
      setState(() {});

      if (image == null) return;
      Reference reference = storage
          .ref()
          .child("gallery")
          .child(FirebaseAuth.instance.currentUser!.uid);

      UploadTask uploadTask = reference.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;
      url = await (snapshot).ref.getDownloadURL();
      print(url);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  String url = '';
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    log(msgToken);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child:
            CustomAppbar(title: 'Fill Your Profile', button: const SizedBox()),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          addVerticalSpace(20),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade500,
                  child: Icon(
                    Icons.person_rounded,
                    size: 50,
                    color: white,
                  ),
                ),
                Positioned(
                    bottom: 1,
                    right: 1,
                    child: InkWell(
                      onTap: () {
                        selectPhoto(context, 1.0, 0);
                      },
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: myFillBoxDecoration(0, primary, 30),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            color: white,
                            size: 20,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          ),
          addVerticalSpace(40),
          CustomTextfield(
            hintext: 'Name',
            controller: nameController,
          ),
          addVerticalSpace(20),
          CustomTextfield(
            hintext: 'Surname',
            controller: surnameController,
          ),
          addVerticalSpace(20),
          /*  CustomTextfield(
            controller: dobController,
            hintext: 'Date Of Birth',
            suffixIcon: Icon(
              Icons.calendar_month_rounded,
              color: Colors.black38,
            ),
          ),
          addVerticalSpace(20),*/
          CustomTextfield(
            hintext: 'Email',
            controller: emailController,
          ),
          addVerticalSpace(20),
          addVerticalSpace(height(context) * 0.23),
          CustomButton(
              buttonName: 'Done',
              onClick: () {
                userDetails();
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const CreateProfileSuccesful()));
              })
        ]),
      ),
    );
  }
}
