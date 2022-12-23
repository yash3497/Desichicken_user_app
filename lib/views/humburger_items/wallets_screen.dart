import 'package:delicious_app/widget/custom_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/constants.dart';
import '../../widget/custom_appbar.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  List lookingForList = [
    'Rs 10',
    'Rs 100',
    'Rs 300',
    'Rs 400',
    'Rs 500',
    'Rs 600',
    'Rs 700',
    'Rs 800',
    'Rs 900',
  ];

  List<bool> listBool = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  int select = 0;
  bool isTrue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppbar(
          title: 'Wallet',
          button: SizedBox(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              height: height(context) * 0.12,
              width: width(context) * 0.95,
              decoration: BoxDecoration(
                  gradient: redGradient(),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2,
                        offset: Offset(1, 5)),
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Balance',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rs 1,000',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600)),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => WithDrawScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 15.0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.wallet,
                              color: black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('Top Up', style: bodytext12Bold(color: black)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 21, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Center(
                          child: Text("Enter the amount of top up",
                              style: bodyText14w600(color: black))),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        height: height(context) * 0.1,
                        width: width(context),
                        decoration: myOutlineBoxDecoration(2, primary, 10),
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: lookingForList[select],
                                hintStyle: bodyText20w700(color: black)),
                          ),
                        ),
                      ),
                      Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children:
                              List.generate(lookingForList.length, (index) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    listBool[index] = !listBool[select];
                                    isTrue = !isTrue;
                                    select = index;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(2),
                                  padding: const EdgeInsets.all(5),
                                  width: width(context) * 0.28,
                                  decoration: select == index
                                      ? myFillBoxDecoration(0, primary, 20)
                                      : BoxDecoration(
                                          border: Border.all(
                                              color: primary, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                  child: SizedBox(
                                    height: height(context) * 0.03,
                                    width: width(context) * 0.19,
                                    child: Center(
                                      child: Text(
                                        lookingForList[index],
                                        textAlign: TextAlign.center,
                                        style: bodyText14w600(
                                            color: select == index
                                                ? white
                                                : Colors.black),
                                      ),
                                    ),
                                  ),
                                ));
                          })),
                      SizedBox(
                        height: height(context) * 0.28,
                      ),
                      CustomButton(buttonName: 'Continue', onClick: () {})
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
