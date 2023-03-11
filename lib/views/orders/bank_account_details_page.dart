import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delicious_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BankAccountForm extends StatefulWidget {
  final String orderId;

  const BankAccountForm({super.key, required this.orderId});
  @override
  _BankAccountFormState createState() => _BankAccountFormState();
}

class _BankAccountFormState extends State<BankAccountForm> {
  // form key for validation
  final _formKey = GlobalKey<FormState>();

  // form fields values
  String _accountHolderName = '';
  String _accountNumber = '';
  String _bankName = '';
  String _branchName = '';
  String _ifscCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Bank Account Details Form'),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context, false);
            },
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Account Holder Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account holder name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _accountHolderName = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Account Number',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter account number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _accountNumber = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter bank name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _bankName = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Branch Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter branch name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _branchName = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'IFSC Code',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter IFSC code';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _ifscCode = value;
                    });
                  },
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primary)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // form is valid, do something with the data
                      FirebaseFirestore.instance
                          .collection("Orders")
                          .doc(widget.orderId)
                          .update({
                        "orderCancelled": true,
                        'userBankAccountDetail': {
                          'accountNumber': _accountNumber,
                          'accountHolderName': _accountHolderName,
                          'bankName': _bankName,
                          'branchName': _branchName,
                          'ifscCode': _ifscCode,
                        }
                      }).then((value) {
                        Fluttertoast.showToast(msg: 'Order Cancelled');
                        Navigator.pop(context, true);
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
