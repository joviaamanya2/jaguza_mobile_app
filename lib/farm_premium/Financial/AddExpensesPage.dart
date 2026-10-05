import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';

class AddExpensesPage extends StatefulWidget{
  const AddExpensesPage({super.key});

  @override
  State<AddExpensesPage> createState() {
    return _AddExpensesPage();
  }

}

class _AddExpensesPage extends State<AddExpensesPage>{

  final _formKey = GlobalKey<FormState>();

  var _item = "";
  var _amount = "";
  var _date = "";
  var _comment = "";
  var _category = "";
  var _payment_method = "";
  var _quantity = "";
  final _user_id = "";
  var _time = "";

  var _loading = false;
  Future<void> action() async {

    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");

    requestAPI("create_financial", {
      "farm_id": farmId,
      "item": _item,
      "type": "Expense",
      "amount": _amount,
      "date": _date,
      "paid_date": _date,
      "comment": _comment,
      "category": _category,
      "payment_method": _payment_method,
      "quantity": _quantity,
      "status": "active",
      "user_id": _user_id,
      "time": _time,
    }, (progress){
      setState(() {
        _loading = progress;
      });
    }, (response){
      setState(() {
        if( response["status_code"] == 200 ){
          var statusMessage = response["status_message"];
          showSnackBar(context, statusMessage);
          Navigator.pop(context,true);
        } else {

        }
      });}, (){
      print("Error:");
    });

  }



  @override
  void initState() {
    super.initState();

    var now = DateTime.now();
    _date = "${now.year}-${now.month}-${now.day}";
    _time = "${now.hour}:${now.minute}:${now.second}";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expenses"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //farm_id, item, type (expense,income,sale-ticket), amount, date, comment, category, invoice, check_number, payment_method, paid_date, animal_id, contact_id, picture, quantity, status, user_id

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Date", style: TextStyle(
                          color: mainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),),
                    ),

                    Container(
                      margin: EdgeInsets.all(smallMargin),
                      decoration: boxDecoration,
                      width: double.infinity,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () =>
                            helperSelectDate(context, (value) {
                              setState(() {
                                _date = value;
                              });
                            }),
                        decoration: inputDecoration("Date").copyWith(
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        controller: TextEditingController(text: _date),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a date.";
                          }
                          return null;
                        },
                      ),
                    ),

                    artyTechTextInput("Item", (value){
                      _item = value;
                    }),
                    artyTechTextInput("amount", (value){
                      _amount = value;
                    }),
                    artyTechTextInput("category", (value){
                      _category = value;
                    }),
                    artyTechTextInput("payment method", (value){
                      _payment_method = value;
                    }),

                    artyTechTextInput("quantity", (value){
                      _quantity = value;
                    }),

                    artyTechTextArea("comment", (value){
                      _comment = value;
                    }),


                    _loading ? Center(child: CircularProgressIndicator(),) :
                    artyTechButtonOvalFilled("Save Expense", (){
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        action();
                      }
                    })
                  ],),
              ),
            ),
          ],
        ),
      ),
    );
  }
}