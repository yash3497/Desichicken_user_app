import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

bool isToggle = false;
bool isPremium = false;
bool isPosition = false;


const textColor = Colors.black;
const textLightColor = Color(0xFF888888);

String? Stime;
String SDate = DateFormat('EEEE,d,MMM,yyy').format(DateTime.now());

TextStyle bodyText1(
    {Color color = textColor,
      required context,
      TextDecoration textDecoration = TextDecoration.none}) {
  return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 13,
      decoration: textDecoration,
      color: color);
}

// for gradient
Color ligthRed = const Color.fromRGBO(255, 187, 186, 1);
Color darkRed = const Color.fromRGBO(255, 29, 29, 1);
Color darkRed2 = const Color.fromRGBO(197, 8, 8, 1);

// for custom
Color primary = Color.fromRGBO(228, 1, 1, 1);
Color boxBgColor = const Color.fromRGBO(51, 51, 51, 1);
Color white = Colors.white;
Color blackLight = Color.fromRGBO(50, 50, 50, 1);
Color black = Colors.black;

// only gradient
Gradient redGradient() {
  return LinearGradient(
    colors: [ligthRed, darkRed, darkRed, darkRed, darkRed2],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

// only gradient
Gradient tabGradient() {
  return LinearGradient(
    colors: [
      ligthRed.withOpacity(0.2),
      ligthRed,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

Gradient whiteLinerGradient() {
  return const LinearGradient(
    colors: [Colors.white, Colors.white],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

// Gradient decorations
BoxDecoration gradientBoxDecoration(Gradient gradient, double radius) {
  return BoxDecoration(
    gradient: gradient,
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

//box decoration with border colors only
BoxDecoration myOutlineBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    border: Border.all(width: width, color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

//box decoration with fill box colors
BoxDecoration myFillBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    color: color,
    border: Border.all(width: width, color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

TextStyle bodyText14w600({required Color color}) {
  return TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600);
}

TextStyle bodyText14normal({required Color color}) {
  return TextStyle(
    fontSize: 13,
    color: color,
  );
}

TextStyle bodyText13normal({required Color color}) {
  return TextStyle(
    fontSize: 13,
    color: color,
  );
}

TextStyle bodyText16w600({required Color color}) {
  return TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w700);
}

// small Size
TextStyle bodyText12Small({required Color color}) {
  return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w400);
}

TextStyle bodyText11Small({required Color color}) {
  return TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w400);
}

TextStyle bodytext12Bold({required Color color}) {
  return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600);
}

TextStyle bodyText20w700({required Color color}) {
  return TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold);
}

TextStyle bodyText30W600({required Color color}) {
  return TextStyle(fontSize: 30, color: color, fontWeight: FontWeight.w700);
}

TextStyle bodyText30W400({required Color color}) {
  return TextStyle(
    fontSize: 30,
    color: color,
  );
}

// box decoration with Boxshadow
BoxDecoration shadowDecoration(double radius, double blur) {
  return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: blur,
        ),
      ]);
}

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addHorizontalySpace(double width) {
  return SizedBox(width: width);
}
// const kTextFieldDecoration = InputDecoration(
//   prefix: Text(
//     '    +91  ',
//     style: TextStyle(color: Colors.white, fontSize: 18),
//   ),
//   contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
//   border: OutlineInputBorder(
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
//   enabledBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.white, width: 1.0),
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
//   focusedBorder: OutlineInputBorder(
//     borderSide: BorderSide(color: Colors.white, width: 2.0),
//     borderRadius: BorderRadius.all(Radius.circular(32.0)),
//   ),
// );
