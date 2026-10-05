import 'package:jaguza_app/farm_premium/Financial/AddIncomesPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';

class IncomesPage extends StatefulWidget{
  const IncomesPage({super.key});

  @override
  State<IncomesPage> createState() {
    return _IncomesPage();
  }
  
}

class _IncomesPage extends State<IncomesPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (showExpensesProgress)
            Center(child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            )),

          if (expenses.isEmpty && !showExpensesProgress)
            Center(child: Text("No incomes yet")),

          Expanded(
            child: ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index){
                var expense = expenses[index];
                return Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))
                  ),
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text(makeDateShorter(expense["paid_date"] ?? ""), style: TextStyle(fontSize: 12),),
                      Expanded(child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(expense["item"] ?? "", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                              Text(expense["comment"] ?? "", style: TextStyle(fontSize: 12),),
                            ],
                          ))),
                      SizedBox(
                          width: 40,
                          child: Text(expense["quantity"] ?? "")),
                      SizedBox(
                          width: 70,
                          child: Text(formatNumberWithCommas(expense["amount"] ?? ""), style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 1,horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text(expense["payment_method"] ?? "", style: TextStyle(fontSize: 11, color: Colors.white),)),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           addIncomes();
        },
        child: Icon(Icons.add),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initExpenses();
  }

  var expenses = [];
  var showExpensesProgress = false;

  initExpenses() async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");
    print(farmId);

    var path = "get_financials";
    var data = {
      "farm_id": farmId,
      "type": "income"
    };
    void onProgress(progress){
      setState(() {
        showExpensesProgress = progress;
      });
    }
    void onSuccess(data){
      print("incomes");
      print(data);
      setState(() {
        expenses = data;
      });
    }
    void onError(){
      print("Error:");
    }
    requestAPI(path, data, onProgress, onSuccess, onError);
  }

  Future<void> addIncomes() async {
    var refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddIncomesPage() ) );
    if (refresh == true) {
      initExpenses();
    }
  }




}