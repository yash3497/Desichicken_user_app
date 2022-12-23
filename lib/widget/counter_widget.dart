import 'package:delicious_app/services/cart_services.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CounterWidget extends StatefulWidget {
  final String uid;
  final String pid;
  final num price;
  final num stock;
  final String docID;
  final bool insideProduct;
  int count;
  bool _updating = false;
  CounterWidget(
      {super.key,
      required this.pid,
      required this.stock,
      required this.uid,
      required this.count,
      required this.price,
      required this.docID,
      required this.insideProduct});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final CartServices _cartServices = CartServices();
  @override
  Widget build(BuildContext context) {
    if (widget._updating) {
      return const SizedBox(
          height: 5, width: 5, child: CircularProgressIndicator());
    } else {
      return FittedBox(
        child: SizedBox(
          width: width(context) * 0.24,
          height: height(context) * 0.04,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  if (widget.count > 1) {
                    widget.count--;
                    widget._updating = true;
                  } else if (widget.count == 1) {
                    // isSlide = !isSlide;
                    widget.count = 0;
                    _cartServices
                        .removeFromCart(widget.uid, widget.docID)
                        .then((value) {
                      if (mounted)
                        setState(() {
                          widget._updating = false;
                        });
                    });
                    _cartServices.checkData(widget.uid);
                  }
                  if (mounted) setState(() {});
                  if (widget.count == 0) setState(() {});
                  if (widget.count > 0) {
                    Fluttertoast.showToast(
                        msg: "Product removed",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    var total = widget.price * widget.count;
                    _cartServices
                        .update(widget.uid, widget.pid, widget.count,
                            widget.docID, total.toString())
                        .then((value) {
                      if (mounted)
                        setState(() {
                          widget._updating = false;
                        });
                    });
                  }
                },
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: widget.insideProduct ? 34 : 26,
                ),
              ),
              Text(
                widget.count.toString(),
                style: TextStyle(
                  fontSize: widget.insideProduct ? 20 : 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (widget.count == widget.stock) {
                    Fluttertoast.showToast(
                        msg: "Maximum Stock reached",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    widget.count++;

                    widget._updating = true;
                    if (widget.count >= 1) {}
                    if (mounted) setState(() {});
                    Fluttertoast.showToast(
                        msg: "Product added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    var total = widget.price * widget.count;
                    _cartServices
                        .update(widget.uid, widget.pid, widget.count,
                            widget.docID, total.toString())
                        .then((value) {
                      if (mounted)
                        setState(() {
                          widget._updating = false;
                        });
                    });
                  }
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: widget.insideProduct ? 36 : 26,
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
