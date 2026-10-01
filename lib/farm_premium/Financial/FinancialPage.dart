import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Financial/ExpensesPage.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'IncomesPage.dart';

class FinancialPage extends StatefulWidget{
  @override
  State<FinancialPage> createState() {
    return _FinancialPage();
  }
  
}

class _FinancialPage extends State<FinancialPage>{

  var incomes = [];
  var showIncomesProgress = false;
  var expenses = [];
  var showExpensesProgress = false;

  @override
  void initState() {
    super.initState();
    //initIncomes();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text("Financial"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Incomes",),
              Tab(text: "Expenses",),
            ],
          ),),
        body:  TabBarView(
          children: [
            IncomesPage(),
            ExpensesPage(),
          ],
        ),
      ),
    );
  }

  Widget fragment( String title){
    var records = [];
    if (title == "incomes") {
      records = incomes;
    } else {
      records = expenses;
    }


    return Column(
      children: [
        Text(title),

        if (title == "incomes" && showIncomesProgress) CircularProgressIndicator(),
        if (title == "expenses" && showExpensesProgress) CircularProgressIndicator(),

        Expanded(
          child: ListView.builder(
            primary: false,
                    shrinkWrap: true,
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(records[index]),
                      );
                    },
                  ),
        ),

      ],
    );
  }

  initIncomes() async {
    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");

    var path = "get_incomes";
    var data = {
      "farm_id": farm_id
    };
    var onProgress = (progress){
      setState(() {
        showIncomesProgress = progress;
      });
    };
    var onSuccess = (data){
      print(data);
      setState(() {
        incomes = data;
      });
    };
    var onError = (){
      print("Error:");
    };
    requestAPI(path, data, onProgress, onSuccess, onError);
  }



}
