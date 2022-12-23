import 'package:delicious_app/views/orders/order_status_screen.dart';
import 'package:delicious_app/widget/BottomNavBar.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../widget/custom_gradient_button.dart';

class PaymentSuccesfulScreen extends StatefulWidget {
  const PaymentSuccesfulScreen({super.key});

  @override
  State<PaymentSuccesfulScreen> createState() => _PaymentSuccesfulScreenState();
}

class _PaymentSuccesfulScreenState extends State<PaymentSuccesfulScreen> {
  void initState() {
  /*  Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OrderStatusScreen()));
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ShaderMask(
            child: const Image(
              image: AssetImage("assets/images/splash1.png"),
            ),
            shaderCallback: (Rect bounds) {
              return const LinearGradient(colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 0.1)
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
                  .createShader(bounds);
            },
          ),
          Image.asset('assets/images/succesicon.png'),
          addVerticalSpace(height(context) * 0.04),
          SizedBox(
            width: width(context) * 0.6,
            child: Text(
              'Order placed Successfully!!',
              textAlign: TextAlign.center,
              style: bodyText30W400(color: primary),
            ),
          ),
          addVerticalSpace(10),
          SizedBox(
            width: width(context) * 0.8,
            child: Text(
                'Congratulations! \nThe lorem i ipsum is a placeholder text used in publishing and graphic design',
                textAlign: TextAlign.center,
                style: bodyText14w600(color: black)),
          ),
        ],
      ),
    );
  }
}
